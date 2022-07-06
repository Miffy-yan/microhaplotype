cd *** CC11*

for i in `ls -d *_batch?`
do 
for sample in `ls $i/*range*`
do
echo $sample"\t"$i 
cat $sample|awk '{print}'
done
done>CC120_results.txt