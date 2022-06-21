library(dplyr)
# setwd("/Users/miffy/OneDrive - KU Leuven/0_working directory/microhap_PAP-smears/0_rerun_microhaplot_only_diff_SNPs/7_hap_map/new_calculate_percentage/")
args <- commandArgs(trailingOnly = TRUE)
setwd(args[1])
# read in parental microhap info
# all for mat & only informative ones for pat
# get informative chrs
# mat_microhap<-read.table("mat_microhap_all_batch1.txt")
mat_microhap<-read.table(args[2])
colnames(mat_microhap)<-c("chr","microhap")
# pat_info_microhap<-read.table("pat_microhap_info_batch1.txt")
pat_info_microhap<-read.table(args[3])
colnames(pat_info_microhap)<-c("chr","microhap")
info_chrs<-unique(mat_microhap$chr)

# read in raw data and select useful columns & rows
# raw<-read.table("/Users/miffy/OneDrive - KU Leuven/0_working directory/microhap_PAP-smears/0_rerun_microhaplot_only_diff_SNPs/7_hap_map/new_calculate_percentage/hapmap_batch1/selected_SNP_hapmap_ATGGCCAC-ACTGCATA_0.05_1.summary")
raw<-read.table(args[4])
colnames(raw)[1:5]<-c("sample","barcode","chr","microhap","num")
raw$microhap[is.na(raw$microhap)]<-"NA" # change NA to string "NA"
raw_data<-raw %>% select(1:5) %>% filter(chr %in% info_chrs)
sample<-raw_data[1,1]

# delete all rows with N or X, get clean data
clean_data<-raw_data[grep("N|X", raw_data[,"microhap"], invert=TRUE),]
# 1. sort the clean data by num per chr; 
# 2. sort the data by chr
num_sorted_data<-clean_data %>% group_by(chr) %>% arrange(desc(num),.by_group=T)
chr_sorted_data<-num_sorted_data %>% arrange(chr)

# add to column to chr_sorted_data diff_H1(diff_homo), diff_H2
chr_sorted_data$"diff_H1(diff_homo)"<-""
chr_sorted_data$"diff_H2"<-""

# compare with maternal microhap get num diff
for (i in info_chrs){
  sub_data<-chr_sorted_data %>% filter(chr==i)
  if (sum(mat_microhap$chr==i)==1){
    mat="homo"
    print(paste("chr",i,"mat is homo"))
    microhap_mat<-strsplit(mat_microhap[mat_microhap$chr==i,"microhap"],split="")[[1]]
  }else if(sum(mat_microhap$chr==i)==2){
    mat="het"
    print(paste("chr",i,"mat is het"))
    microhaps_mat<-mat_microhap[mat_microhap$chr==i,"microhap"]
    microhap_mat_1<-strsplit(microhaps_mat[1],split="")[[1]]
    microhap_mat_2<-strsplit(microhaps_mat[2],split="")[[1]]
  }
  if (mat=="homo"){
    for (row in 1:nrow(sub_data)){
      microhap<-strsplit(sub_data[row,"microhap"][[1]],split="")[[1]]
      ndiff=0
      for (char in 1:length(microhap)){
        if (microhap[char]!=microhap_mat[char]){
          ndiff=ndiff+1
        }else{
          ndiff=ndiff
        }
      }
      sub_data$`diff_H1(diff_homo)`[row]<-ndiff
    }
  }else if (mat=="het"){
    for (row in 1:nrow(sub_data)){
    microhap<-strsplit(sub_data[row,"microhap"][[1]],split="")[[1]]
    ndiff_1=0
    for (char in 1:length(microhap)){
      if (microhap[char]!=microhap_mat_1[char]){
        ndiff_1=ndiff_1+1
      }else{
        ndiff_1=ndiff_1
      }
    }
    sub_data$`diff_H1(diff_homo)`[row]<-ndiff_1
    ndiff_2=0
    for (char in 1:length(microhap)){
      if (microhap[char]!=microhap_mat_2[char]){
        ndiff_2=ndiff_2+1
      }else{
        ndiff_2=ndiff_2
      }
    }
    sub_data$`diff_H2`[row]<-ndiff_2
    }
  }
  chr_sorted_data[chr_sorted_data$chr==i,"diff_H1(diff_homo)"]<-sub_data$`diff_H1(diff_homo)`
  chr_sorted_data[chr_sorted_data$chr==i,"diff_H2"]<-sub_data$diff_H2
      }
  
# compare with paternal informative microhap get num diff & num 
pat_matches<-data.frame(matrix(nrow=0,ncol=9))
colnames(pat_matches)<-c(colnames(chr_sorted_data),"total_num","percentage")

for (i in info_chrs){
  sub<-chr_sorted_data %>% filter(chr==i)
  sum_microhap<-sum(sub$num)
  ls_microhap<-pat_info_microhap %>% filter(chr==i)
  for (j in ls_microhap$microhap){
    if(j %in% sub$microhap){
      match<-sub %>% filter(microhap==j)
      match$total_num<-sum_microhap
      match$percentage<-match$num/sum_microhap
      pat_matches<-rbind(pat_matches,match)
    }else{
      print(paste("on chr",i,"pat informative microhap",j,"not in",sample))
    }
  }
}
  

out_dir<-paste(args[5])
write.table(pat_matches, file=paste(out_dir,"/",sample,"_pat_matches.txt",sep=""),quote=F)
write.table(chr_sorted_data, file=paste(out_dir,"/",sample,"_clean_results.txt",sep=""),quote=F)

  
      
        

        

