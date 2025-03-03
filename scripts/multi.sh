strategy=$1
tp=$2
lrs=("1e-3" "5e-4" "1e-4" "5e-5" "1e-5")
echo "Start"
cd /work/u8273333/libcll/
for ((i=0; i < ${#lrs[@]}; i++)); do
	lr=${lrs[$i]}
	c=0
	echo /work/u8273333/libcll/scripts/run_all_experiments_lr_multi.sh ${strategy} ${tp} ${lr} ${c}
	/work/u8273333/libcll/scripts/run_all_experiments_lr_multi.sh ${strategy} ${tp} ${lr} ${c} & 
done
wait
echo "End"

echo "Start"
cd /work/u8273333/libcll/
for ((i=0; i < 4; i++)); do
	lr=${lrs[$i]}
	c=0
	echo /work/u8273333/libcll/scripts/run_all_experiments_lr_multi_hard.sh ${strategy} ${tp} ${i} ${c}
	/work/u8273333/libcll/scripts/run_all_experiments_lr_multi_hard.sh ${strategy} ${tp} ${i} ${c} & 
done
wait
echo "End"

output_dir="/work/u8273333/libcll/logs/${strategy}/${strategy}-${tp}-multi.txt"

seeds=("1207" "9213" "17" "33")

source /home/u8273333/.bashrc
conda activate cll
python /work/u8273333/format_multi.py ${strategy}-${tp} ${output_dir} 0
echo "Start"
cd /work/u8273333/libcll/
for seed in ${seeds[@]}; do
	echo /work/u8273333/libcll/scripts/run_all_experiments_seed_multi.sh ${strategy} ${tp} ${seed} ${c}
	/work/u8273333/libcll/scripts/run_all_experiments_seed_multi.sh ${strategy} ${tp} ${seed} ${c} &
done
wait
echo "End"
