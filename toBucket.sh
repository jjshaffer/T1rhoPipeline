#!/bin/bash

prefix=$1
label=$2
labelfile=$3

3dbucket -prefix ${prefix}_BUCKET.nii.gz \
${prefix}_${label}_t.nii.gz \
${prefix}_p_FDR.nii.gz \
${prefix}_1-p_FDR.nii.gz \
${prefix}_Age_t.nii.gz \
${prefix}_Age_p.nii.gz \
${prefix}_Age_1-p.nii.gz \
${prefix}_Sex_t.nii.gz \
${prefix}_Sex_p.nii.gz \
${prefix}_Sex_1-p.nii.gz \
${prefix}_Omnibus_t.nii.gz \
${prefix}_Omnibus_p.nii.gz \
${prefix}_Omnibus_1-p.nii.gz

3drefit -relabel_all ${labelfile}  ${prefix}_BUCKET.nii.gz
