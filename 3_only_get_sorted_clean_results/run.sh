#!/bin/sh

#./run.sh > chr16_3_error.txt 2>&1  

batch1="chr16_1_7amplicons"
batch2="chr16_2_chr17_delete_3X"
batch3="chr16_3"

batch=$batch3
work_dir="/Users/miffy/OneDrive - KU Leuven/0_working directory/microhap_PAP-smears/13_cfDNA/microhap"

echo $work_dir

for raw_result_file in `ls "$batch/"`
do 
Rscript only_sorting_data_analysis.R "$work_dir" $batch/$raw_result_file $batch
done