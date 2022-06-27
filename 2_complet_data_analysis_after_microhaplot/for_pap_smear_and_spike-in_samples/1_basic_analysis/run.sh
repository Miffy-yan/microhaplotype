#!/bin/sh

# ./run.sh > batch3.error.txt 2>&1  # change batch each run

# batch1;batch2;batch3
batch="batch3" # change batch each run
work_dir="/Users/miffy/OneDrive - KU Leuven/0_working directory/microhap_PAP-smears/0_rerun_microhaplot_only_diff_SNPs/7_hap_map/new_calculate_percentage/"
mat_microhap_file=`ls mat_microhap_all_$batch.txt`
pat_info_microhap_file=`ls pat_microhap_info_$batch.txt`



for raw_result_file in `ls *$batch/`
do 
Rscript data_analysis.R "$work_dir" $mat_microhap_file $pat_info_microhap_file `ls -d *$batch`/$raw_result_file `ls -d *$batch`
done