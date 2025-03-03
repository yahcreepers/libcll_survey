strategy=$1
tp=$2
seed=$3
cuda=0
strategies=($strategy)
types=(${tp})
lrs=("1e-3" "5e-4" "1e-4" "5e-5" "1e-5")
lrs=($(cat "/work/u8273333/libcll/logs/${strategy}/${strategy}-${tp}-noisy.txt"))
# strategies=("SCL" "URE" "FWD" "DM" "CPE" "MPE")
#strategies=("SCL")
datasets=("mnist" "kmnist" "fmnist" "yeast" "texture" "control" "dermatology" "cifar10" "cifar20" "micro_imagenet10" "micro_imagenet20" "clcifar10" "clcifar20" "clmicro_imagenet10" "clmicro_imagenet20")
# datasets=("clcifar10" "clcifar20")
# datasets=("clcifar10")
# datasets=("yeast" "texture" "control" "dermatology" "cifar10" "cifar20")
# datasets=("mnist" "kmnist" "fmnist" "yeast" "texture" "control" "dermatology" "cifar10")
# datasets=("micro_imagenet10" "micro_imagenet20" "clmicro_imagenet10" "clmicro_imagenet20")
# datasets=("clcifar10" "clcifar20" "clmicro_imagenet10" "clmicro_imagenet20")
datasets=("mnist" "kmnist" "fmnist" "cifar10" "micro_imagenet10")
echo ${lrs[@]}
for strategy in ${strategies[@]}; do
    i=0
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
        multi=1
        for noise in "0.1" "0.2" "0.5"; do
            lr=${lrs[$i]}
            i=$(($i+1))
            for t in ${types[@]}; do
                for model in ${models[@]}; do
                    echo "/work/u8273333/libcll/scripts/noise.sh ${cuda} ${strategy} ${t} ${model} ${dataset} ${valid_type} ${multi} noisy ${lr} ${seed} ${noise}"
                    /work/u8273333/libcll/scripts/noise.sh ${cuda} ${strategy} ${t} ${model} ${dataset} ${valid_type} ${multi} noisy ${lr} ${seed} ${noise}
                    # echo "./scripts/predict.sh ${cuda} ${strategy} ${t} ${model} ${dataset}"
                    # ./scripts/predict.sh ${cuda} ${strategy} ${t} ${model} ${dataset}
                done
            done
        done
    done
done

