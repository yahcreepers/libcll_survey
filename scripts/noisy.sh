strategy=$1
tp=$2
lrs=("1e-3" "5e-4" "1e-4" "5e-5" "1e-5")
echo "Start"
cd /work/u8273333/libcll/
for lr in ${lrs[@]}; do
	echo /work/u8273333/libcll/scripts/run_all_experiments_lr_noisy.sh ${strategy} ${tp} ${lr}
	/work/u8273333/libcll/scripts/run_all_experiments_lr_noisy.sh ${strategy} ${tp} ${lr} & 
done
wait
echo "End"

output_dir="/work/u8273333/libcll/logs/${strategy}/${strategy}-${tp}-noisy.txt"

seeds=("1207" "9213" "17" "33")

source /home/u8273333/.bashrc
conda activate cll
python /work/u8273333/format_noisy.py ${strategy}-${tp} ${output_dir}
# echo "1e-4 1e-4 1e-4 1e-4 1e-4 1e-4 1e-4 1e-4 1e-4 1e-4 1e-4 1e-4 1e-4 1e-4 1e-4" > ${output_dir}
echo "Start"
cd /work/u8273333/libcll/
for seed in ${seeds[@]}; do
	echo /work/u8273333/libcll/scripts/run_all_experiments_seed_noisy.sh ${strategy} ${tp} ${seed}
	/work/u8273333/libcll/scripts/run_all_experiments_seed_noisy.sh ${strategy} ${tp} ${seed} &
done
wait
echo "End"
