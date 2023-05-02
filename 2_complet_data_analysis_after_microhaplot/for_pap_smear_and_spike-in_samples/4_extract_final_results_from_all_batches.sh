# cd *** CC11*

name="CC119"

for i in `ls -d *_batch?`
do 
for sample in `ls $i/*range_0.3_3.5_real_num_ratio_lim_9.55e-05_.txt`
do
echo $sample"\t"$i 
cat $sample|awk '{print}'
done
done>$name.range_0.3_3.5_real_num_ratio_lim_9.55e-05.results.txt


for i in `ls -d *_batch?`
do 
for sample in `ls $i/*pat_matches.txt`
do
echo $sample"\t"$i 
cat $sample|awk '{print}'
done
done>$name.pat_match.txt