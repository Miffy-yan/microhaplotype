module load SAMtools/1.9-GCC-6.4.0-2.28

#print all samples 
# ls *.bam|awk 'BEGIN{ORS=" "}{print $0}'

for i in `ls *.bam|awk 'BEGIN{ORS=" "}{print $0}'`
do 
echo $i 
samtools view -c -F 4 $i
done>count_mapped_samtools.txt

for i in `ls *.bam|awk 'BEGIN{ORS=" "}{print $0}'`
do echo $i 
	for interval in `cat samtools_chr.bed`
	do samtools view -c -F 4 $i $interval
	done
done>count_mapped_interval_samtools.txt


