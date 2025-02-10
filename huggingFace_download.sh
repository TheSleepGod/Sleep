#!/bin/bash
export HF_ENDPOINT="https://hf-mirror.com"
export HF_HUB_ENABLE_HF_TRANSFER=4
if [ $# -eq 0 ]; then
    echo "错误：请提供模型名称，例如 'username/model-name'"
    exit 1
fi

MODEL_NAME=$1
OUTPUT_DIR="${MODEL_NAME#*/}"

if ! command -v huggingface-cli &> /dev/null; then
    echo "huggingface-cli未安装，正在尝试安装..."
    pip install -U huggingface_hub || {
        echo "安装失败，请手动执行：pip install huggingface_hub"
        exit 1
    }
fi

echo "正在加速下载模型：$MODEL_NAME"
huggingface-cli download $MODEL_NAME \
    --resume-download \
    --local-dir "$OUTPUT_DIR" \
    --local-dir-use-symlinks False \
    --cache-dir ./hf-cache \
    --num-proc 4

echo "下载完成！模型保存在：$OUTPUT_DIR"
