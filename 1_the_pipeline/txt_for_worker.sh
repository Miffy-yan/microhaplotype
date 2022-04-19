raw_dir="/staging/leuven/stg_00019/margot_research/220322_Microhaps_CC115_Mar22"

echo SAMPLE>microhap.txt
ls $raw_dir|grep ".R"|awk -F ".R" '{print $1}'|uniq>>microhap.txt

echo SAMPLE>merge.txt
cat microhap.txt|grep -v SAMPLE|awk -F . '{print $1}'|uniq>>merge.txt
