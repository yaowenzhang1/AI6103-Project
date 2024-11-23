## Environment Setup
```bash
conda env create -f environment.yml
```
or refer to the [ViP-LLaVA-README.md](https://github.com/ssbhxlj/AI6103-Project/blob/main/ViP-LLaVA-README.md) to install manually.

## Download 
### Model Weights 
Download [vip-llava-7b](https://huggingface.co/mucai/vip-llava-7b) to `./checkpoints/vip-llava-7b`.

### POPE
Download [COCOVAL2014](http://images.cocodataset.org/zips/val2014.zip), [GQA](https://downloads.cs.stanford.edu/nlp/data/gqa/images.zip), and [POPE annotation](https://github.com/RUCAIBox/POPE) to `./data`. 
```
├── POPE
|    ├── aokvqa
|    |    ├── aokvqa_pope_adversarial.json
|    |    ├── aokvqa_pope_popular.json
|    |    └── aokvqa_pope_random.json
|    ├── coco
|    │   ├── coco_pope_adversarial.json
|    │   ├── coco_pope_popular.json
|    │   └── coco_pope_random.json
|    └── gqa
|        ├── gqa_pope_adversarial.json
|        ├── gqa_pope_popular.json
|        └── gqa_pope_random.json
├── coco
│   └── val2014
└── gqa
    └── images
```
### ViP-Bench
Download [ViP-Bench](https://huggingface.co/datasets/mucai/ViP-Bench/tree/main) to root directory.

## Evaluation
### POPE
Firstly, choose corresponding text prompt in `./eval/object_hallucination_vqa_llava.py`
```python
# used on POPE
conv.append_message(conv.roles[0], qs + " Please answer this question with one word.")
# used on ViP-Bench
conv.append_message(conv.roles[0], qs + " Please answer this question with a word, number or phrase")
# regular
conv.append_message(conv.roles[0], qs)
```

then, specify dataset(coco/gqa/aokvqa) and type(random/popular/adversarial) in `cd_scripts/llava1.5_pope.bash`. If you don't want to use VCD, delete or comment
```bash
--use_cd --cd_alpha $cd_alpha --cd_beta $cd_beta --noise_step $noise_step --seed ${seed} \
```

then, run 
```bash
bash cd_scripts/llava1.5_pope.bash
```

### ViP-Bench
Firstly, choose corresponding text prompt in `./eval/object_hallucination_vqa_llava.py`

then specify split(bbox/human), method(vcd/regular) in `cd_scripts/vcd_vipbench.bash`

then run
```bash
bash cd_scripts/vcd_vipbench.bash
```

After running, there are folers `answers` and `results` in `output/ViP-Bench`. Move/copy `results` to  `ViP-Bench` that was downloaded before. Then, specify split, method, <b>absolute path</b> of `ViP-Bench` and openai key in `cd_scripts/vip-bench_evaluator.py`.
```python
openai.api_key = "your api_key"
openai.api_base = "your api_base"
openai.api_type = "azure"
openai.api_version = "2024-10-01-preview" 
```

Finally, run
```shell
python cd_scripts/vip-bench_evaluator.py
```
<b>🔔 Note: </b>The [hugginface evaluator](https://huggingface.co/spaces/mucai/ViP-Bench_Evaluator) provided by the author of ViP-LLaVA is no longer usable. Please use your own openai key in [local evaluator](https://github.com/ssbhxlj/AI6103-Project/blob/main/cd_scripts/vip-bench_evaluator.py) if you wanna get the result.