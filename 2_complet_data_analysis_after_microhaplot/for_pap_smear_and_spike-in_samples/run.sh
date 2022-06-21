#!/bin/sh

#./run.sh > chr16_3_error.txt 2>&1  

batch1="chr16_1_7amplicons"
batch2="chr16_2_chr17_delete_3X"
batch3="chr16_3"

batch=$batch3
work_dir="/Users/miffy/Documents/GitHub/microhaplotype/data_analysis/"
mat_microhap_file="mat_microhap_$batch.txt"
pat_info_microhap_file="pat_microhap_$batch.txt"



for raw_result_file in `ls "$batch/"`
do 
Rscript data_analysis.R $work_dir $mat_microhap_file $pat_info_microhap_file $batch/$raw_result_file $batch
done