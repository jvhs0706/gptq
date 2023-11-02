#!/bin/bash
set -e

module load python/3.10
virtualenv --no-download ./TEMP_ENV
source ./TEMP_ENV/bin/activate
pip install --no-index --upgrade pip

module load git-lfs
git lfs install


if [ ! -d "facebook/opt-125m" ]; then
    git clone https://huggingface.co/facebook/opt-125m facebook/opt-125m
fi

module load gcc/9.3.0 arrow/11.0.0
pip install --no-index datasets
python download-data.py
deactivate

rm -rf ./TEMP_ENV
