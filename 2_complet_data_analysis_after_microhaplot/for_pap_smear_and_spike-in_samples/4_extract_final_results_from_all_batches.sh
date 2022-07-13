cd *** CC11*

for i in `ls -d *_batch?`
do 
for sample in `ls $i/*range_0.4_2.2_min_reads_40_.txt`
do
echo $sample"\t"$i 
cat $sample|awk '{print}'
done
done>CC125_results.txt


for i in `ls -d *_batch?`
do 
for sample in `ls $i/*pat_matches.txt`
do
echo $sample"\t"$i 
cat $sample|awk '{print}'
done
done>CC125_pat_match.txt