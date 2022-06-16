
# ----get only informative SNPs for each trio
setwd("/Users/miffy/OneDrive - KU Leuven/0_working directory/microhap_PAP-smears/0_rerun_microhaplot_only_diff_SNPs/output_diff_snp_list")
microhap <- read.table("parent_120_117_115_116_122.txt",header = T)  
chrs<-unique(microhap$chr)
dim(microhap)
parent_info<-list()
uniq_pat_list_long<-list()
uniq_pat_list_new<-list()
diff_TF_ls<-list()
for (i in seq(2,(ncol(microhap)-1),by=2)){
  name<-sub("_maternal","",colnames(microhap)[i])
  for (chr in chrs){
    mat_1<-microhap[microhap$chr==chr,i][1]
    mat_2<-microhap[microhap$chr==chr,i][2]
    pat_1<-microhap[microhap$chr==chr,i+1][1]
    pat_2<-microhap[microhap$chr==chr,i+1][2]
    
    if (pat_1==pat_2 & pat_1 %in% c(mat_1,mat_2)==F){
      uniq_pat_list_long[paste(name,chr,"pat_hom",sep="_")][1]<-pat_1
    }else if (pat_1!=pat_2 & pat_1 %in% c(mat_1,mat_2)==F) {
      uniq_pat_list_long[paste(name,chr,"pat_het_1",sep="_")]<-pat_1
    }else if (pat_1!=pat_2 & pat_2 %in% c(mat_1,mat_2)==F){
      uniq_pat_list_long[paste(name,chr,"pat_het_2",sep="_")]<-pat_2
    }   
  
    if (mat_1==mat_2) {
      print(paste(colnames(microhap)[i],"_chr_",chr," is homo",sep=""))
    } 
    if (pat_1==pat_2) {
      print(paste(colnames(microhap)[i+1],"_chr_",chr," is homo",sep=""))
    } 
    mat_1_sep<-strsplit(split="", mat_1)[[1]]
    mat_2_sep<-strsplit(split="", mat_2)[[1]]
    pat_1_sep<-strsplit(split="", pat_1)[[1]]
    pat_2_sep<-strsplit(split="", pat_2)[[1]]
    len<-length(mat_1_sep<-strsplit(split="", mat_1)[[1]])
    diff_TF<-vector()
    for (j in 1:len){
      if (mat_1_sep[j]==mat_2_sep[j]&pat_1_sep[j]==pat_2_sep[j]&mat_1_sep[j]==pat_1_sep[j]){
        diff_TF[j]=FALSE
      }else{
        diff_TF[j]=TRUE
      }
    }
    
    
    mat_1_new<-mat_1_sep[diff_TF]
    mat_2_new<-mat_2_sep[diff_TF]
    pat_1_new<-pat_1_sep[diff_TF]
    pat_2_new<-pat_2_sep[diff_TF]
    
    parent_info[[paste(name,"mat1",chr,sep="_")]]<-mat_1_new
    parent_info[[paste(name,"mat2",chr,sep="_")]]<-mat_2_new
    parent_info[[paste(name,"pat1",chr,sep="_")]]<-pat_1_new
    parent_info[[paste(name,"pat2",chr,sep="_")]]<-pat_2_new
    
    
    if (length(mat_1_new)>0) {
      mat_1_new_whol<-paste(mat_1_new,collapse = "")
      mat_2_new_whol<-paste(mat_2_new,collapse = "")
      pat_1_new_whol<-paste(pat_1_new,collapse = "")
      pat_2_new_whol<-paste(pat_2_new,collapse = "")
      if ((pat_1_new_whol==pat_2_new_whol) & pat_1_new_whol %in% c(mat_1_new_whol,mat_2_new_whol)==F){
        uniq_pat_list_new[paste(name,chr,"pat_hom",sep="_")][1]<-pat_1_new_whol
      }else if (pat_1_new_whol!=pat_2_new_whol & pat_1_new_whol %in% c(mat_1_new_whol,mat_2_new_whol)==F) {
        uniq_pat_list_new[paste(name,chr,"pat_het_1",sep="_")]<-pat_1_new_whol
      }else if (pat_1_new_whol!=pat_2_new_whol & pat_2_new_whol %in% c(mat_1_new_whol,mat_2_new_whol)==F){
        uniq_pat_list_new[paste(name,chr,"pat_het_2",sep="_")]<-pat_2_new_whol
      }  
    }
    
    diff_TF_ls[[paste(name,chr,sep="_")]] <- diff_TF
  }
}

sink(file="parental_haplotypes_only_informative.txt")
print(parent_info,quote=F)
sink()

sink(file="uniq_pat_list_long.txt")
print(uniq_pat_list_long,quote=F)
sink()

sink(file="uniq_pat_list_new.txt")
print(uniq_pat_list_new,quote=F)
sink()

batch1<-read.table("chr16_1_7amplicons.txt",header = F)
batch2<-read.table("chr16_2_chr17_delete_3X.txt",header = F)
batch3<-read.table("chr16_3.txt",header = F)

diff_snp_all<-matrix(0,0,10)
for (chr in chrs){
  if (chr %in% unique(batch1[,1])){
    batch<-batch1
  }else if (chr %in% unique(batch2[,1])){
    batch<-batch2
    chr_16<- grep("_2",chr)
  }else if (chr %in% unique(batch3[,1])){
    batch<-batch3
    chr_16<- sub("_3","",chr)
  }
  for (i in grep(paste("_",chr,"$",sep=""),names(diff_TF_ls),value = T)){
    all_snp<-batch[grep(sub("_\\d","",chr),batch[,1]),]
    diff_snp<-all_snp[diff_TF_ls[[i]],]
    if (nrow(diff_snp)>0){
      diff_snp$label<-i
      diff_snp_all<-rbind(diff_snp_all,diff_snp)
    }
}
}

samples<-unique(gsub("_\\d*","",diff_snp_all$label))
for (i in samples){
  ind_diff_snp<-diff_snp_all[grep(i,diff_snp_all$label),]
  batch1_ind<-ind_diff_snp[grep("_16_2$|_17$|_16_3$",ind_diff_snp$label,invert=T),1:9]
  batch2_ind<-ind_diff_snp[grep("_16_2$|_17$",ind_diff_snp$label),1:9]
  batch3_ind<-ind_diff_snp[grep("_16_3$",ind_diff_snp$label),1:9]
  write.table(batch1_ind,file = paste(i,"batch1.txt",sep="_"),quote = F,col.names = F,row.names = F)
  write.table(batch2_ind,file = paste(i,"batch2.txt",sep="_"),quote = F,col.names = F,row.names = F)
  write.table(batch3_ind,file = paste(i,"batch3.txt",sep="_"),quote = F,col.names = F,row.names = F)
}





