#!/bin/bash
#SBATCH -N 1
#SBATCH --ntasks-per-node=40
#SBATCH --partition=batch
#SBATCH --array=1
#SBATCH -J test
#SBATCH -o test.%J.out
#SBATCH -e test.%J.err
#SBATCH --mail-user=qilin.sun@kaust.edu.sa
#SBATCH --mail-type=ALL
#SBATCH --time=4:00:00
#SBATCH --mem=256G
#SBATCH --constraint=[cpu_intel_gold_6148]

#OpenMP settings:
export OMP_NUM_THREADS=40


#run the application:
mpirun -np 40 test

module load anaconda3
source activate /home/sunq/deepoptics
#run the application:
python test.py --dataroot ../images/test/ --model test --gpu_ids -1 --learn_residual --dataset_mode single 
