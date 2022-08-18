# cd *** CC11*

name="CC129"

for i in `ls -d *_batch?`
do 
for sample in `ls $i/*range_0.41_2.75_min_reads_60_.txt`
do
echo $sample"\t"$i 
cat $sample|awk '{print}'
done
done>$name.results.txt


for i in `ls -d *_batch?`
do 
for sample in `ls $i/*pat_matches.txt`
do
echo $sample"\t"$i 
cat $sample|awk '{print}'
done
done>$name.pat_match.txt