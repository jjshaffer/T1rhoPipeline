#!/bin/bash




#3dAllineate -base anatomical2_MNI.nii.gz \
#-input anatomical2.nii.gz -float \
#-prefix anatomical_MNI.nii.gz \
#-1Dmatrix_save MNI_Transform.1D



#prefix1=${CONTRAST}_${CONTRAST}_t
#echo $prefix1

#3dAllineate -base anatomical2_MNI.nii.gz \
#-input ${prefix1}.nii.gz -float \
#-prefix ${prefix1}_MNI.nii.gz \
#-1Dmatrix_apply MNI_Transform.1D

3dbucket -prefix BD_qT1rho_BUCKET_FDR.nii.gz \
GroupxSession_t.nii.gz \
GroupxSession_p.nii.gz \
GroupxSession_1-p.nii.gz \
GroupxSession_pImage_FDR.nii.gz \
GroupxSession_1-pImage_FDR.nii.gz \
Group_t.nii.gz \
Group_p.nii.gz \
Group_1-p.nii.gz \
Session_t.nii.gz \
Session_p.nii.gz \
Session_1-p.nii.gz \
Age_t.nii.gz \
Age_p.nii.gz \
Age_1-p.nii.gz \
Sex_t.nii.gz \
Sex_p.nii.gz \
Sex_1-p.nii.gz \
Omnibus_t.nii.gz \
Omnibus_p.nii.gz \
Omnibus_1-p.nii.gz


3drefit -relabel_all 'labels1.txt'  BD_qT1rho_BUCKET_FDR.nii.gz

3drefit -space MNI BD_qT1rho_BUCKET_FDR.nii.gz

