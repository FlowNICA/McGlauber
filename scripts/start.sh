#!/bin/bash

# Define main working directory
#SBATCH -D /mnt/pool/rhic/4/parfenovpeter/Soft/Centrality/Glauber/scripts

# Job name
#SBATCH -J glauber_run

# Partition: in which job queue are we want to put our jobs
#SBATCH -p fast

# Expected maximum runtime of the jobs (here is 1 hour)
#SBATCH --time=01:00:00

# Define SLURM outputs
#SBATCH -o /mnt/pool/rhic/4/parfenovpeter/Soft/Centrality/Glauber/scripts/SGE_OUT/slurm_%A_%a.out
#SBATCH -e /mnt/pool/rhic/4/parfenovpeter/Soft/Centrality/Glauber/scripts/SGE_OUT/slurm_%A_%a.err

#Define how many jobs are we want to submit (here is 100 jobs)
#SBATCH -a 1-200


# Define Glauber input parameters
nev=100000
sigm=26.78
snn=3.0
proj=Au3
targ=Au3

# sigmaNN for different energies:
# sNN = 200  GeV <--> sigma = 41.8
# sNN = 62.4 GeV <--> sigma = 36.0
# sNN = 39.0 GeV <--> sigma = 34.1
# sNN = 27.0 GeV <--> sigma = 33.0
# sNN = 19.6 GeV <--> sigma = 31.8
# sNN = 14.5 GeV <--> sigma = 31.4
# sNN = 11.5 GeV <--> sigma = 31.2   // 28.08 29.64 32.76 34.32
# sNN =  9.2 GeV <--> sigma = 31.0 
# sNN =  7.7 GeV <--> sigma = 29.7   // 26.73 28.215 31.185 32.67
# sNN =  5.123 GeV <--> sigma = 29.3 // 26.37 27.835 30.765 32.23
# sNN =  4 GeV     <--> sigma = 29 
# sNN =  3.32 GeV <--> sigma = 28
# sNN =  2.978 GeV <--> sigma = 26.78

# Define output directory name. Make it short and robust.
export COMMIT=Glauber_gen_${proj}${targ}_${snn}gev

export START_POSITION=$PWD
export MAIN_DIR=/mnt/pool/rhic/4/parfenovpeter/Soft/Centrality/Glauber
export JOBID=${SLURM_ARRAY_JOB_ID}
export TASK_ID=${SLURM_ARRAY_TASK_ID}

# Define output directory
export OUT_DIR=/mnt/pool/nica/6/parfenovpeter/CentralityGlauber
export OUT=$OUT_DIR/$COMMIT/$JOBID
export OUT_FILE=${OUT}/glauber_${JOBID}_${TASK_ID}.root
export LOG=${OUT}/log/JOB_${JOBID}_${TASK_ID}.log

mkdir -p $OUT
mkdir -p $OUT/log

# Define _log() as log output
_log() {

local format='+%Y/%m/%d-%H:%M:%S'
echo [`date $format`] "$@"

}

# Source ROOT support
source /mnt/pool/nica/8/parfenovpeter/Soft/ROOT/build-cxx11/bin/thisroot.sh
#ROOTSYS_cvmfs=/cvmfs/it.gsi.de/root/v6-06-06/

_log ${ROOTSYS}

# Define executable
export BIN_DIR=${MAIN_DIR}/build
export BIN_EXE=${BIN_DIR}/runGlauber

_log "Executable: ${BIN_EXE}" &>> $LOG

_log "Running executable:" &>> $LOG
echo "$BIN_EXE -nev $nev -targ $targ -proj $proj -sigmNN $sigm -o $OUT_FILE -seed $RANDOM" &>> $LOG
$BIN_EXE -nev $nev -targ $targ -proj $proj -sigmNN $sigm -o $OUT_FILE -seed $RANDOM &>> $LOG

_log "Job Done." &>> $LOG
