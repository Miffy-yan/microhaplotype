for i in `ls *batch*.txt|sed 's/.txt//g'`
do 
cat vcfheader.txt $i.txt>$i.vcf
done