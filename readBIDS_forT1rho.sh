#!/bin/bash

i="$1"

#Cluster Path
SHARE_DIR=/Shared/MRRCdata

#Local Path
#SHARE_DIR=/Volumes/mrrcdata

ATLAS_NAME=mni_icbm152_t1_tal_nlin_asym_09c.nii

DATA_DIR=${SHARE_DIR}/BD_TMS_TIMING
BIDS_DIR=${SHARE_DIR}/BD_TMS_TIMING/BD_TMS_data
FREESURFER_DIR=${SHARE_DIR}/BD_TMS_TIMING/derivatives/FreeSurfer


#Find all subjects in BIDS_DIR & sessions
subjects=(${BIDS_DIR}/*/)
numsubjs=${#subjects[@]}
#echo $numsubjs


#Loop through each subject
#for i in `seq 0 $(($numsubjs-1))`
#for i in `seq 0 0`
#do

#echo ${subjects[$i]}
subject=${subjects[$i]}

#Trim / at end
subject=${subject%*/}
#echo $subject

#Trim base file path
subject=${subject##*/}
#echo $subject

if [[ $subject != "sourcedata" ]]; then

#Trim everything preceding -
subject=${subject#*-}

echo $subject

#Loop through each imaging session
sessions=(${subjects[$i]}*/)
numses=${#sessions[@]}
#echo $numses


T1=()
T1m=()
T2=()
ses=()

TSLa=10
TSLb=50

for x in `seq 0 $(($numses-1))`
do
T1[$x]="None"
T1m[$x]="None"
T2[$x]="None"

ses[$x]=0
done

T13T=""
T17T31P=""

for j in `seq 0 $(($numses-1))`
do
#echo ${sessions[$j]}

T1r10="None"
T1r50="None"
session=${sessions[$j]}

#Trim / at end
session=${session%*/}



#Trim everything preceding -
session=${session##*-}
echo $session
ses[$j]=$session

#Get list of files in the anatomy folder
files=(${sessions[$j]}anat/*)
numfiles=${#files[@]}
#echo $numfiles

#Loop through each anatomy file
for k in `seq 0 $(($numfiles-1))`
do

filepath=${files[$k]}
file=$(basename $filepath)
#echo $file

if [[ $file == *"For31P_T1w.nii.gz" ]]
then

    T1m[$j]=$filepath

elif [[ $file == *"T1w.nii.gz" ]]
then
    #echo $filepath
    T1[$j]=$filepath

elif [[ $file == *"T2w.nii.gz" ]]
then
    #echo $filepath
    T2[$j]=$filepath
elif [[ $file == *"acq-SL10_T1rho.nii.gz" ]]
then
    T1r10=$filepath
elif [[ $file == *"acq-SL50_T1rho.nii.gz" ]]
then
    T1r50=$filepath



fi

done #files






#if [[ ${session} == *3T ]]
#then

echo $session
#echo $T1r10
#echo $T1r50

if [[ ${T1r10} != "None" && ${T1r50} != "None" ]]
    then
        echo $T1r10
        echo $T1r50

    OUT_DIR=${DATA_DIR}/derivatives/T1rho/sub-${subject}/ses-${session}
    mkdir -p $OUT_DIR

bash processT1rho.sh ${FREESURFER_DIR}/sub-${subject}_ses-${session}/SUMA $T1r10 $TSLa $T1r50 $TSLb $OUT_DIR sub-${subject}_ses-${session} $ATLAS_NAME ${DATA_DIR}/scripts/T1rho
    else

    echo "Missing Images:"
    echo $T1r10
    echo $T1r50
    fi
#fi

done #session



fi

#done #subject