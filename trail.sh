#!/bin/bash
#SBATCH --gpus=a100:1
#SBATCH --cpus-per-task=6
#SBATCH --mem=32000M
#SBATCH --time=0-00:59
#SBATCH --output=%N-%j.out
#SBATCH --account=rrg-hongyanz
#SBATCH --mail-user=haochen.sun@uwaterloo.ca
#SBATCH --mail-type=ALL

set -e  # Exit immediately if a command exits with a non-zero status

# Load necessary modules (If you are using a different cluster, you may need to change this)
module load gcc cuda/11.4 cmake protobuf cudnn python/3.10 arrow/11.0.0

virtualenv --no-download --clear $SLURM_TMPDIR/ENV && source $SLURM_TMPDIR/ENV/bin/activate

pip install --no-index torch numpy transformers datasets

# Compute full precision (FP16) results
HF_DATASETS_OFFLINE=1 CUDA_VISIBLE_DEVICES=0 python opt.py facebook/opt-125m c4
# Run RTN baseline and compute results
HF_DATASETS_OFFLINE=1 CUDA_VISIBLE_DEVICES=0 python opt.py facebook/opt-125m c4 --wbits 4 --nearest
# Run GPTQ and compute results
HF_DATASETS_OFFLINE=1 CUDA_VISIBLE_DEVICES=0 python opt.py facebook/opt-125m c4 --wbits 4 --groupsize 1024