strategy=$1
tp=$2
lr=$3
cuda=$4
strategies=($strategy)
types=(${tp})
lrs=("1e-3" "5e-4" "1e-4" "5e-5" "1e-5")
# lrs=(${lr})
# strategies=("SCL" "URE" "FWD" "DM" "CPE" "MPE")
#strategies=("SCL")
datasets=("mnist" "kmnist" "fmnist" "yeast" "texture" "control" "dermatology" "cifar10" "cifar20" "micro_imagenet10" "micro_imagenet20" "clcifar10" "clcifar20" "clmicro_imagenet10" "clmicro_imagenet20")
if [[ ${lr} == 0 ]]; then
    datasets=("cifar10")
elif [[ ${lr} == 1 ]]; then
    datasets=("cifar20")
elif [[ ${lr} == 2 ]]; then
    datasets=("clcifar10")
elif [[ ${lr} == 3 ]]; then
    datasets=("clcifar20")
elif [[ ${lr} == 4 ]]; then
    datasets=("micro_imagenet10")
elif [[ ${lr} == 5 ]]; then
    datasets=("micro_imagenet20")
elif [[ ${lr} == 6 ]]; then
    datasets=("clmicro_imagenet10")
elif [[ ${lr} == 7 ]]; then
    datasets=("clmicro_imagenet20")
fi
# datasets=("micro_imagenet10")
# datasets=("clcifar10" "clcifar20")
# datasets=("clcifar10")
# datasets=("yeast" "texture" "control" "dermatology" "cifar10" "cifar20")
# datasets=("mnist" "kmnist" "fmnist" "yeast" "texture" "control" "dermatology" "cifar10")
# datasets=("micro_imagenet10" "micro_imagenet20" "clmicro_imagenet10" "clmicro_imagenet20")
# datasets=("clcifar10" "clcifar20" "clmicro_imagenet10" "clmicro_imagenet20")
# datasets=("mnist" "kmnist" "fmnist" "cifar10")
for strategy in ${strategies[@]}; do
    for dataset in ${datasets[@]}; do
        # valid_type="URE"
        # if [[ $strategy == "SCL" ]]; then
        #     types=("NL" "EXP" "FWD")
        # elif [[ $strategy == "URE" ]]; then
        #     types=("NN" "GA" "TNN" "TGA")
        #     types=("NN" "GA" "TNN")
        # elif [[ $strategy == "CPE" ]]; then
        #     types=("I" "F" "T")
        #     valid_type="SCEL"
        # elif [[ $strategy == "FWD" ]] || [[ $strategy == "DM" ]]; then
        #     types=("None")
        # elif [[ $strategy == "MCL" ]]; then
        #     types=("MAE" "EXP" "LOG")
        # fi
         
        if [[ $dataset == "mnist" ]] || [[ $dataset == "kmnist" ]] || [[ $dataset == "fmnist" ]] || [[ $dataset == "yeast" ]] || [[ $dataset == "texture" ]] || [[ $dataset == "control" ]] || [[ $dataset == "dermatology" ]]; then
            models=("Linear" "MLP")
            models=("MLP")
            # models=("MLP")
        elif [[ $dataset == "cifar10" ]] || [[ $dataset == "cifar20" ]] || [[ $dataset == "clcifar10" ]] || [[ $dataset == "clcifar20" ]] || [[ $dataset == "micro_imagenet10" ]] || [[ $dataset == "micro_imagenet20" ]] || [[ $dataset == "clmicro_imagenet10" ]] || [[ $dataset == "clmicro_imagenet20" ]]; then
            models=("ResNet34" "DenseNet")
       	    models=("ResNet34")
        # models=("DenseNet")
        fi
        valid_type="Accuracy"
        multi=3
        for t in ${types[@]}; do
            for model in ${models[@]}; do
                for lr in ${lrs[@]}; do
                    echo "/work/u8273333/libcll/scripts/lr.sh ${cuda} ${strategy} ${t} ${model} ${dataset} ${valid_type} ${multi} uniform ${lr}"
                    /work/u8273333/libcll/scripts/lr.sh ${cuda} ${strategy} ${t} ${model} ${dataset} ${valid_type} ${multi} uniform ${lr}
                    # echo "./scripts/predict.sh ${cuda} ${strategy} ${t} ${model} ${dataset}"
                    # ./scripts/predict.sh ${cuda} ${strategy} ${t} ${model} ${dataset}
                done
            done
        done
    done
done

