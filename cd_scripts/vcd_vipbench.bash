seed=${1:-55}
model_path=${2:-"./checkpoints/vip-llava-7b"}
cd_alpha=${3:-1}
cd_beta=${4:-0.2}
noise_step=${5:-500}
split=${6:-"bbox"}
model_name=vip-llava-7b
folder=ViP-Bench
method=vcd

export export HF_HOME="/root/autodl-tmp/huggingface"

python ./eval/object_hallucination_vqa_llava.py \
--model-path ${model_path} \
--question-file ViP-Bench/$split/questions.jsonl \
--image-folder ViP-Bench/$split/images \
--answers-file ./output/$folder/answers/$method-$model_name-$split-new.jsonl \
--seed ${seed} \
--use_cd --cd_alpha $cd_alpha --cd_beta $cd_beta --noise_step $noise_step --seed ${seed} \


mkdir -p ./output/results

python scripts/convert_vipbench_for_eval.py \
    --src ./output/$folder/answers/$method-$model_name-$split.jsonl \
    --dst ./output/$folder/results/$method-$model_name-$split.json \
