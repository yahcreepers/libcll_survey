import os
import glob
import parse
import sys
from tensorboard.backend.event_processing.event_accumulator import EventAccumulator

key = "noise_real_0."
key = "uniform"
key = "multi_label_3"
path = "/work/u8273333/libcll/logs"
datasets = ["mnist", "kmnist", "fmnist", "cifar10", "micro_imagenet10"]
datasets = ["mnist", "kmnist", "fmnist", "yeast", "texture", "control", "dermatology", "cifar10", "cifar20", "clcifar10", "clcifar20"]
# strategies = {"SCL": {"NL": {}, "EXP": {}, "FWD": {}}, "URE": {"NN": {}, "TNN": {}, "GA": {}, "TGA": {}}, "DM": {"None": {}}, "CPE": {"I": {}, "F": {}, "T": {}}}
# strategies = {"SCL": {"NL": {}, "EXP": {}, "FWD": {}}, "URE": {"NN": {}, "TNN": {}, "GA": {}, "TGA": {}}, "CPE": {"I": {}, "F": {}, "T": {}}}
strategies = {"SCL-NL": {}, "SCL-EXP": {}, "SCL-FWD": {}, "URE-NN": {}, "URE-GA": {}, "DM-None": {}, "MCL-MAE": {}, "MCL-EXP": {}, "MCL-LOG": {}, "FWD-None": {}, "URE-TNN": {}, "URE-TGA": {}, "CPE-I": {}, "CPE-F": {}, "CPE-T": {}}
sss = sys.argv[1]
output_file = sys.argv[2]
mode = sys.argv[3]
if mode == "0":
    datasets = ["mnist", "kmnist", "fmnist", "yeast", "texture", "control", "dermatology", "cifar10", "cifar20", "clcifar10", "clcifar20"]
elif mode == "1":
    datasets = ["micro_imagenet10", "micro_imagenet20", "clmicro_imagenet10", "clmicro_imagenet20"]
# datasets = ["clcifar10", "clcifar20", "clmicro_imagenet10", "clmicro_imagenet20"]
# key = sys.argv[3] if len(sys.argv) == 3 else key
# print()
# print(datasets)
file_names = glob.glob(f"{path}/*/*{key}*/*")

for file_name in file_names:
    format_string = "{strategy}-{tp}-{model}-{dataset}-{lr}"
    res = parse.parse(format_string, os.path.basename(file_name))
    if res["model"] != "MLP" and res["model"] != "ResNet34":
        continue
    s = res["strategy"]
    tp = res["tp"]
    lr = "-".join(res["lr"].split("-")[:2])
    seed = res["lr"].split("-")[-1]
    # print(os.path.basename(file_name))
    if seed != "1126":
        continue
    events = glob.glob(f"{file_name}/lightning_logs/version_0/*")
    acc = 0
    for event in events:
        event_acc = EventAccumulator(event)
        event_acc.Reload()
        if "Test_Accuracy" in event_acc.Tags()["scalars"]:
            acc = event_acc.Scalars("Test_Accuracy")[0].value
            break
    s = f"{s}-{tp}"
    if res["dataset"] not in strategies[s]:
        strategies[s][res["dataset"]] = {}
    if res["model"] == "MLP" or res["model"] == "ResNet34":
        strategies[s][res["dataset"]][lr] = acc * 100
print(strategies)
f = open(output_file, "w")
lrs = []
for dataset in datasets:
    l = "-1"
    acc = 0
    if 0 in strategies[sss][dataset]:
        print(sss, dataset)
    for lr in strategies[sss][dataset]:
        if strategies[sss][dataset][lr] > acc:
            l = lr
            acc = strategies[sss][dataset][lr]
    lrs.append(str(l))
print(" ".join(lrs), file=f)
exit()
f = open(output_file, "w")
for strategy in strategies:
    for method in strategies[strategy]:
        f.write(f"{strategy}-{method},")
        print(strategy, method)
        for dataset in datasets:
            if strategies[strategy][method] == {}:
                break
            print(dataset, dict(sorted(strategies[strategy][method][dataset].items())))
            acc = ",".join(map(str, list(dict(sorted(strategies[strategy][method][dataset].items())).values())))
            f.write(f"{acc},")
        f.write(f"\n")
