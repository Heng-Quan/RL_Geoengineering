#!/bin/bash
#SBATCH -o SRM_RL_run.out
#SBATCH --partition=C032M0128G
#SBATCH --qos=low
#SBATCH -J CAM_SRM_RL_low_res7
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=32

module load intel/2018.1
module load matlab/R2021a
module load netcdf/4.4.1-intel-2018.0

ulimit
ulimit -s unlimited
export MPSTKZ=40000000
export I_MPI_COMPATIBILITY=4

matlab -nodesktop -nosplash -nodisplay -r train_CAM_ACAgent

echo 'now sbatch myself'


