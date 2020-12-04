#!/bin/bash

#i="$1"

#Cluster Path
SHARE_DIR=/Shared/MRRCdata

#Local Path
#SHARE_DIR=/Volumes/mrrcdata


BIDS_DIR=${SHARE_DIR}/Bipolar_R01/BD_R01_data
FREESURFER_DIR=${SHARE_DIR}/Bipolar_R01/derivatives/FreeSurfer



#Find all subjects in BIDS_DIR & sessions
subjects=(${BIDS_DIR}/*/)
numsubjs=${#subjects[@]}
#echo $numsubjs


#Loop through each subject
for i in `seq 0 $(($numsubjs-1))`
#for i in `seq 0 0`
do

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

echo ${i}:${subject}
fi

done #subject
