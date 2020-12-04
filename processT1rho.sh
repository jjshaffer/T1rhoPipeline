#!/bin/bash

#This script is used for calculating the T1rho values from a pair of T1rho images using different spin-lock times (TSL).
# This pipeline uses anatomical images that have been processed and segmented using Freesurfer in order to 1) align T1rho
# Images to each session's T1w image. 2) Calculate the T1rho from the 2 different TSLs 3) Generate a binary brain mask using
# Freesurfer results 4) Apply brain mask to exclude skull, outside of the head, etc 4) Apply ventricle mask from Freesurfer
# Script relies on Output from Freesurfer and functions from AFNI
# Author: Joe Shaffer
# Date: March, 2019


FS_DIR=$1 #Freesurfer directory for session - for anatomical T1 and image masks
SL1=$2 #First T1rho SL image
TSL1=$3 #TSL of first T1rho image
SL2=$4 #Second T1rho SL image
TSL2=$5 #TSL of second T1rho image
OUT_DIR=$6 #Directory path for output
OUT_NAME=$7 #Name prefix for outputs- for BIDS format, should just be sub-#_ses-#
ATLAS_NAME=$8
STD_DIR=$9


#Determine which TSL is longer & set to TSLa/ image SLa, set shorter to TSLb/ image SLb
if [[ $TSL1 > $TSL2 ]]
then
    TSLa=$TSL1
    SLa=$SL1
    TSLb=$TSL2
    SLb=$SL2
else
    TSLa=$TSL2
    SLa=$SL2
    TSLb=$TSL1
    SLb=$SL1
fi

#echo $SLa
#echo $SLb

#Convert 1st spin lock image to T1 space
3dAllineate -base $FS_DIR/T1.nii -input $SLa -prefix ${OUT_DIR}/${OUT_NAME}_acq-SL${TSLa}_T1aligned.nii.gz -1Dmatrix_save ${OUT_DIR}/${OUT_NAME}_acq-SL${TSLa}_toT1transform.1D

#Convert 2nd spin lock image to T1 space
3dAllineate -base $FS_DIR/T1.nii -input $SLb -prefix ${OUT_DIR}/${OUT_NAME}_acq-SL${TSLb}_T1aligned.nii.gz -1Dmatrix_save ${OUT_DIR}/${OUT_NAME}_acq-SL${TSLb}_toT1transform.1D


#Calculate T1rho using aligned images
3dcalc -a ${OUT_DIR}/${OUT_NAME}_acq-SL${TSLa}_T1aligned.nii.gz -b ${OUT_DIR}/${OUT_NAME}_acq-SL${TSLb}_T1aligned.nii.gz  -expr "(-($TSLa-$TSLb))/log(a/b)" -prefix ${OUT_DIR}/${OUT_NAME}_acq-SLa${TSLa}SLb${TSLb}Unmasked_T1rho.nii.gz


#Mask images to retain brain, exclude ventricles

#Make binary brain mask from Freesurfer segmentation
3dcalc -a ${FS_DIR}/brain.nii -expr 'ispositive(a)' -prefix ${OUT_DIR}/binaryBrainMask.nii.gz
3dmask_tool -input ${OUT_DIR}/binaryBrainMask.nii.gz -prefix ${OUT_DIR}/binaryBrainMask.filled.nii.gz -fill_holes

#Mask to brain only
3dcalc -a ${OUT_DIR}/${OUT_NAME}_acq-SLa${TSLa}SLb${TSLb}Unmasked_T1rho.nii.gz -b ${OUT_DIR}/binaryBrainMask.filled.nii.gz -expr "a*b" -prefix ${OUT_DIR}/${OUT_NAME}_acq-SLa${TSLa}SLb${TSLb}BrainMasked_T1rho.nii.gz


#Mask Ventricles out - note FS ventricle mask sets ventricles to 1, other to 0, so we need to "flip" this in expression
3dcalc -a ${OUT_DIR}/${OUT_NAME}_acq-SLa${TSLa}SLb${TSLb}BrainMasked_T1rho.nii.gz -b ${FS_DIR}/${OUT_NAME}_vent.nii -expr "a*abs(b-1)" -prefix ${OUT_DIR}/${OUT_NAME}_acq-SLa${TSLa}SLb${TSLb}BrainVentMasked_T1rho.nii.gz


#Convert masked and unmasked files to standard atlas space.

3dAllineate -base $ATLAS_NAME -input $FS_DIR/T1.nii -prefix ${OUT_DIR}/MNI_aligned_T1.nii.gz -1Dmatrix_save ${OUT_DIR}/${OUT_NAME}_toSTANDARD.1D


3dAllineate -base $ATLAS_NAME -input ${OUT_DIR}/${OUT_NAME}_acq-SLa${TSLa}SLb${TSLb}Unmasked_T1rho.nii.gz -prefix ${OUT_DIR}/${OUT_NAME}_acq-SLa${TSLa}SLb${TSLb}Unmasked_STANDARD_T1rho.nii.gz -1Dmatrix_apply ${OUT_DIR}/${OUT_NAME}_toSTANDARD.1D
3dAllineate -base $ATLAS_NAME -input ${OUT_DIR}/${OUT_NAME}_acq-SLa${TSLa}SLb${TSLb}BrainMasked_T1rho.nii.gz -prefix ${OUT_DIR}/${OUT_NAME}_acq-SLa${TSLa}SLb${TSLb}BrainMasked_STANDARD_T1rho.nii.gz -1Dmatrix_apply ${OUT_DIR}/${OUT_NAME}_toSTANDARD.1D
3dAllineate -base $ATLAS_NAME -input ${OUT_DIR}/${OUT_NAME}_acq-SLa${TSLa}SLb${TSLb}BrainVentMasked_T1rho.nii.gz -prefix ${OUT_DIR}/${OUT_NAME}_acq-SLa${TSLa}SLb${TSLb}BrainVentMasked_STANDARD_T1rho.nii.gz -1Dmatrix_apply ${OUT_DIR}/${OUT_NAME}_toSTANDARD.1D

cp ${OUT_DIR}/${OUT_NAME}_acq-SLa${TSLa}SLb${TSLb}BrainVentMasked_STANDARD_T1rho.nii.gz /Volumes/mrrcdata/BD_TMS_TIMING/derivatives/T1rho/MNI/