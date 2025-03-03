strategy=$1
type=$2
output_dir="/work/u8273333/libcll/logs/${strategy}/${strategy}-${type}-uniform.txt"

seeds=("1207" "9213" "17" "33")

source /home/u8273333/.bashrc
conda activate cll
python /work/u8273333/format.py ${strategy}-${type} ${output_dir}
echo "Start"
cd /work/u8273333/libcll/
for seed in ${seeds[@]}; do
	echo /work/u8273333/libcll/scripts/run_all_experiments_seed.sh ${strategy} ${type} ${seed}
	/work/u8273333/libcll/scripts/run_all_experiments_seed.sh ${strategy} ${type} ${seed} &
done
wait
echo "End"
