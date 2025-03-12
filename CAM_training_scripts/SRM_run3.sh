#!/bin/bash
#SBATCH -o SRM_run3.out
#SBATCH --partition=C032M0128G
#SBATCH --qos=low
#SBATCH -J CAM_SRM_run3
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=32
#SBATCH --time=10:00:00

module load intel/2018.0
module load netcdf/4.4.1-intel-2018.0

ulimit
ulimit -s unlimited
export MPSTKZ=40000000
export I_MPI_COMPATIBILITY=4

mpirun -np 32 /gpfs/share/home/1800011374/CAM3_SOM_low_res/cam < /gpfs/share/home/1800011374/CAM3_SOM_low_res/namelist_SRM3