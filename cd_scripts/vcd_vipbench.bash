seed=${1:-55}
# dataset_name=${2:-"coco"}
# type=${3:-"popular"}
model_path=${2:-"./checkpoints/vip-llava-7b"}
cd_alpha=${3:-1}
cd_beta=${4:-0.2}
noise_step=${5:-500}
split=${6:-"bbox"}
model_name=vip-llava-7b
folder=ViP-Bench
# method=${6:-"baseline"}
# if [[ $dataset_name == 'coco' || $dataset_name == 'aokvqa' ]]; then
#   image_folder=./data/coco/val2014
# else
#   image_folder=./data/gqa/images
# fi

export export HF_HOME="/root/autodl-tmp/huggingface"

python ./eval/object_hallucination_vqa_llava.py \
--model-path ${model_path} \
--question-file ViP-Bench/$split/questions.jsonl \
--image-folder ViP-Bench/$split/images \
--answers-file ./output/$folder/answers/vcd-$model_name-$split-new.jsonl \
--seed ${seed} \
--use_cd --cd_alpha $cd_alpha --cd_beta $cd_beta --noise_step $noise_step --seed ${seed} \


mkdir -p ./output/results

python scripts/convert_vipbench_for_eval.py \
    --src ./output/$folder/answers/baseline-$model_name-$split.jsonl \
    --dst ./output/$folder/results/baseline-$model_name-$split.json \


# mkdir -p ./playground/data/eval/$folder/answers
# python -m llava.eval.model_vqa \
#     --model-path $model_path \
#     --question-file ./playground/data/eval/$folder/$split/questions.jsonl \
#     --image-folder ./playground/data/eval/$folder/$split/images \
#     --answers-file ./playground/data/eval/$folder/answers/$model_name-$split.jsonl \
#     --temperature 0 

# mkdir -p ./playground/data/eval/$folder/results

# python scripts/convert_vipbench_for_eval.py \
#     --src ./playground/data/eval/$folder/answers/$model_name-$split.jsonl \
#     --dst ./playground/data/eval/$folder/results/$model_name-$split.json