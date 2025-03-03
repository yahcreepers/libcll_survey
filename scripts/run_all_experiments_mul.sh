strategy=$1
cuda=$2
strategies=($strategy)
# strategies=("SCL" "URE" "FWD" "DM" "CPE" "MPE")
#strategies=("SCL")
datasets=("mnist" "kmnist" "fmnist" "yeast" "texture" "control" "dermatology" "cifar10" "cifar20" "clcifar10" "clcifar20")
# datasets=("clcifar10" "clcifar20")
# datasets=("clcifar10")
# datasets=("yeast" "texture" "control" "dermatology" "cifar10" "cifar20")
datasets=("mnist" "kmnist" "fmnist" "yeast" "texture" "control" "dermatology" "cifar10")
datasets=("micro_imagenet10" "micro_imagenet20" "clmicro_imagenet10" "clmicro_imagenet20")
# datasets=("mnist" "kmnist" "fmnist" "cifar10")
datasets=("micro_imagenet20")

for strategy in ${strategies[@]}; do
    for dataset in ${datasets[@]}; do
        valid_type="URE"
        if [[ $strategy == "SCL" ]]; then
            types=("NL" "EXP" "FWD")
        elif [[ $strategy == "URE" ]]; then
            types=("NN" "GA" "TNN" "TGA")
        elif [[ $strategy == "CPE" ]]; then
            types=("I" "F" "T")
            valid_type="SCEL"
        elif [[ $strategy == "FWD" ]] || [[ $strategy == "DM" ]]; then
            types=("None")
         elif [[ $strategy == "MCL" ]]; then
            types=("MAE" "EXP" "LOG")
        fi
        
        if [[ $dataset == "mnist" ]] || [[ $dataset == "kmnist" ]] || [[ $dataset == "fmnist" ]] || [[ $dataset == "yeast" ]] || [[ $dataset == "texture" ]] || [[ $dataset == "control" ]] || [[ $dataset == "dermatology" ]]; then
            models=("Linear" "MLP")
            models=("Linear")
            # models=("MLP")
        elif [[ $dataset == "cifar10" ]] || [[ $dataset == "cifar20" ]] || [[ $dataset == "clcifar10" ]] || [[ $dataset == "clcifar20" ]] || [[ $dataset == "micro_imagenet10" ]] || [[ $dataset == "micro_imagenet20" ]] || [[ $dataset == "clmicro_imagenet10" ]] || [[ $dataset == "clmicro_imagenet20" ]]; then
            models=("ResNet" "DenseNet")
	    models=("ResNet")
	    # models=("DenseNet")
        fi
        valid_type="Accuracy"
        multi=1
        biased="uniform"
	    for t in ${types[@]}; do
            for model in ${models[@]}; do
                for multi in "0"; do
                    if [[ ${dataset:0:2} != "cl" ]] || [[ ${multi} != "0" ]]; then
                        echo "./scripts/train.sh ${cuda} ${strategy} ${t} ${model} ${dataset} ${valid_type} ${multi} ${biased}"
                        ./scripts/train.sh ${cuda} ${strategy} ${t} ${model} ${dataset} ${valid_type} ${multi} ${biased}
                        # echo "./scripts/predict.sh ${cuda} ${strategy} ${t} ${model} ${dataset}"
                        # ./scripts/predict.sh ${cuda} ${strategy} ${t} ${model} ${dataset}
                    fi
                done
            done
        done
    done
done
