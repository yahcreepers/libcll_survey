strategy=$1
tp=$2
lrs=("1e-3" "5e-4" "1e-4" "5e-5" "1e-5")
echo "Start"
for lr in ${lrs[@]}; do
	echo scripts/run_all_experiments_lr.sh ${strategy} ${tp} ${lr}
	scripts/run_all_experiments_lr.sh ${strategy} ${tp} ${lr} & 
done
wait
echo "End"

output_dir="logs/${strategy}/${strategy}-${tp}-uniform.txt"

seeds=("1207" "9213" "17" "33")

source /home/u8273333/.bashrc
conda activate cll
python scripts/format.py ${strategy}-${tp} ${output_dir}
echo "Start"
for seed in ${seeds[@]}; do
	echo scripts/run_all_experiments_seed.sh ${strategy} ${tp} ${seed}
	scripts/run_all_experiments_seed.sh ${strategy} ${tp} ${seed} &
done
wait
echo "End"
