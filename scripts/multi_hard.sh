strategy=$1
tp=$2
# lrs=("1e-3" "5e-4" "1e-4" "5e-5" "1e-5")

# echo "Start"
# cd /work/u8273333/libcll/
# for ((i=4; i < 8; i++)); do
# 	c=$(($i%2))
# 	echo /work/u8273333/libcll/scripts/run_all_experiments_lr_multi_hard.sh ${strategy} ${tp} ${i} ${c}
# 	/work/u8273333/libcll/scripts/run_all_experiments_lr_multi_hard.sh ${strategy} ${tp} ${i} ${c} & 
# done
# wait
# echo "End"

output_dir="/work/u8273333/libcll/logs/${strategy}/${strategy}-${tp}-multi-hard.txt"

seeds=("1207" "9213" "17" "33")

source /home/u8273333/.bashrc
conda activate cll
# python /work/u8273333/format_multi.py ${strategy}-${tp} ${output_dir} 1
echo "Start"
cd /work/u8273333/libcll/
for ((i=0; i < 2; i++)); do
	seed=${seeds[$i]}
	c=$(($i%2))
	echo /work/u8273333/libcll/scripts/run_all_experiments_seed_multi_hard.sh ${strategy} ${tp} ${seed} ${c}
	/work/u8273333/libcll/scripts/run_all_experiments_seed_multi_hard.sh ${strategy} ${tp} ${seed} ${c} &
done
wait
echo "End"

echo "Start"
cd /work/u8273333/libcll/
for ((i=2; i < 4; i++)); do
	seed=${seeds[$i]}
	c=$(($i%2))
	echo /work/u8273333/libcll/scripts/run_all_experiments_seed_multi_hard.sh ${strategy} ${tp} ${seed} ${c}
	/work/u8273333/libcll/scripts/run_all_experiments_seed_multi_hard.sh ${strategy} ${tp} ${seed} ${c} &
done
wait
echo "End"
