export CUDA_VISIBLE_DEVICES=$1

strategy=$2
tp=$3
model=$4
dataset=$5
valid_type=$6
num_cl=$7
transition_matrix=$8

output_dir="./logs/${strategy}/${dataset}-multi_label_${num_cl}-${transition_matrix}/${strategy}-${tp}-${model}-${dataset}"
output_dir="./logs/test/${strategy}/${dataset}-multi_label_${num_cl}-${transition_matrix}/${strategy}-${tp}-${model}-${dataset}"
python scripts/train.py \
    --do_train \
    --do_predict \
    --strategy ${strategy} \
    --type ${tp} \
    --model ${model} \
    --dataset ${dataset} \
    --lr 1e-4 \
    --batch_size 256 \
    --augment \
    --valid_type ${valid_type} \
    --output_dir ${output_dir} \
    --num_cl ${num_cl} \
    --transition_matrix ${transition_matrix}\
