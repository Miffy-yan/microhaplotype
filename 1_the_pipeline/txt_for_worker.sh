raw_dir="/staging/leuven/stg_00019/margot_research/220614_Microhaps_CC112_June22"

echo SAMPLE>microhap.txt
ls $raw_dir|grep ".R"|awk -F ".R" '{print $1}'|uniq>>microhap.txt

echo SAMPLE>merge.txt
cat microhap.txt|grep -v SAMPLE|awk -F . '{print $1}'|uniq>>merge.txt


# get label.txt for microhaplot

cat change_name.txt|grep -v SAMPLE|awk -F ',' '{print $2".sam\t.\t"$2}'

# remove extra spaces 