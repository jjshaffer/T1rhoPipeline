#!/bin/bash

#Set the name of the job. This will be the first part of the error/output filename.

#$ -N BD_T1rho

#Set the shell that should be used to run the job.
#$ -S /bin/bash

#Set the current working directory as the location for the error and output files.
#(Will show up as .e and .o files)
#$ -cwd

#Select the queue to run in
#$ -q PINC

#Select the number of slots the job will use
#$ -pe smp 2

#Print informationn from the job into the output file
#/bin/echo Here I am: `hostname`. Sleeping now at: `date`
#/bin/echo Running on host: `hostname`.
#/bin/echo In directory: `pwd`
#/bin/echo Starting on: `date`

#Send e-mail at beginning/end/suspension of job
#$ -m n

#E-mail address to send to
#$ -M joseph-shaffer@uiowa.edu

#Run as Array Job
#$ -t 1:1:1

#Do Stuff

module load matlab/2018a

#cd /Shared/MRRCdata/BD_TMS_TIMING/scripts/BIDS

#bash runIterative_generateBIDSstructure.sh $(($SGE_TASK_ID+6))
#bash runIterative_generateBIDSstructure.sh $(($SGE_TASK_ID+7))

#matlab -nodesktop -nosplash -r "createScanTSV;quit;"



cd /Shared/MRRCdata/Bipolar_R01/scripts/T1rhoPipeline/RegressionAnalysis
#bash readBIDS_forRestingState.sh $(($SGE_TASK_ID-1))
#matlab -nodesktop -nosplash -r "T1rhoAnalysis($SGE_TASK_ID);quit;"

#matlab -nodesktop -nosplash -r "combineSlices('BD_R01_T1rho_Group' ,193);quit;"
#matlab -nodesktop -nosplash -r "combineSlices('BD_R01_T1rho_MADRS' ,193);quit;"
#matlab -nodesktop -nosplash -r "combineSlices('BD_R01_T1rho_YMRS' ,193);quit;"
#matlab -nodesktop -nosplash -r "combineSlices('BD_R01_T1rho_Suicide' ,193);quit;"

#matlab -nodesktop -nosplash -r "makeImages('BD_R01_T1rho_Group_results.mat', 'names.txt', 'MNI_aligned_T1.nii.gz', 'BD_R01_T1rho_Group');quit;"
#matlab -nodesktop -nosplash -r "makeImages('BD_R01_T1rho_MADRS_results.mat', 'names2.txt', 'MNI_aligned_T1.nii.gz', 'BD_R01_T1rho_MADRS');quit;"
#matlab -nodesktop -nosplash -r "makeImages('BD_R01_T1rho_YMRS_results.mat', 'names3.txt', 'MNI_aligned_T1.nii.gz', 'BD_R01_T1rho_YMRS');quit;"
#matlab -nodesktop -nosplash -r "makeImages('BD_R01_T1rho_Suicide_results.mat', 'names4.txt', 'MNI_aligned_T1.nii.gz', 'BD_R01_T1rho_Suicide');quit;"

#matlab -nodesktop -nosplash -r "runFDRCorrection('BD_R01_T1rho_Group_results.mat', 'BD_0.95mask.mat', 'BD_R01_T1rho_Group');quit;"
#matlab -nodesktop -nosplash -r "runFDRCorrection('BD_R01_T1rho_MADRS_results.mat', 'BD_0.95mask.mat', 'BD_R01_T1rho_MADRS');quit;"
#matlab -nodesktop -nosplash -r "runFDRCorrection('BD_R01_T1rho_YMRS_results.mat', 'BD_0.95mask.mat', 'BD_R01_T1rho_YMRS');quit;"
#matlab -nodesktop -nosplash -r "runFDRCorrection('BD_R01_T1rho_Suicide_results.mat', 'BD_0.95mask.mat', 'BD_R01_T1rho_Suicide');quit;"

bash toBucket.sh BD_R01_T1rho_Group Group labels1.txt
bash toBucket.sh BD_R01_T1rho_MADRS MADRS labels2.txt
bash toBucket.sh BD_R01_T1rho_YMRS YMRS labels3.txt
bash toBucket.sh BD_R01_T1rho_Suicide Suicide labels4.txt