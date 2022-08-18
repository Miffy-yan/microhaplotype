library(dplyr)
# setwd("/Users/miffy/Documents/GitHub/microhaplotype/data_analysis/")
args <- commandArgs(trailingOnly = TRUE)
setwd(args[1])
# read in raw data and select useful columns & rows
raw<-read.table(args[2])
colnames(raw)[1:5]<-c("sample","barcode","chr","microhap","num")
raw_data<-raw %>% select(1:5)
sample<-raw_data[1,1]

# delete all rows with N or X, get clean data
clean_data<-raw_data[grep("N|X", raw_data[,"microhap"], invert=TRUE),]
# 1. sort the clean data by num per chr;
# 2. sort the data by chr
num_sorted_data<-clean_data %>% group_by(chr) %>% arrange(desc(num),bygroup=T)
chr_sorted_data<-num_sorted_data %>% arrange(chr)
#chr_sorted_data_top3<-chr_sorted_data %>% group_by(chr) %>% filter(row_number()<=3)

out_dir<-paste(args[3],"/",sep="")
write.table(chr_sorted_data, file=paste(out_dir,"/",sample,"_sorted_clean_data.txt",sep=""),quote=F)
# write.table(chr_sorted_data_top3, file=paste(out_dir,"/",sample,"_sorted_clean_data_top3.txt",sep=""),quote=F)

  
      
        

        

