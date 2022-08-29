wd<-"/Users/miffy/OneDrive - KU Leuven/0_working directory/microhap_PAP-smears/1_data_for_manuscript/10_CC129/microhaplot/CC129_batch3"
setwd(wd)

filenames<-list.files(path = wd,pattern = ".*_clean_results.txt")
names<-gsub(".txt","",filenames)

samples<-grep("PAP",names,value = T)
mat<-grep("MAT",names,value = T)

for(i in names){
  filepath <- file.path(wd,paste(i,".txt",sep=""))
  assign(i, read.table(filepath,sep = " ",header=T))
}

mat_data<-get(mat)

for (sample in samples){
  sample_data<-get(sample)
  selected_sample<-sample_data[,c(1,3,4,5,6,7)]
  colnames(selected_sample)[5]<-"diff_H1"
  colnames(selected_sample)[4]<-"real_num"
  selected_sample$diff_H2[is.na(selected_sample$diff_H2)]<-99
  
  chrs<-unique(selected_sample$chr)
  selected_sample$expected_num<-99
  selected_sample$ratio_real_expected<-99
  selected_sample$sum<-99
  selected_sample$real_num_ratio<-99
  for (chr in chrs){
    chr_sample<-selected_sample[selected_sample$chr==chr,]
    chr_mat<-mat_data[mat_data$chr==chr,]
    for (i in 1:nrow(chr_sample)){
      microhap<-chr_sample$microhap[i]
      if (microhap %in% chr_mat$microhap) {
        rate_mat<-chr_mat[chr_mat$microhap==microhap,"num"]/sum(chr_mat$num)
      }else{
        rate_mat<-0
      }
      expected<-round(sum(chr_sample$real_num)*rate_mat, digits = 0)
      chr_sample$expected_num[i]<-expected
      chr_sample$ratio_real_expected[i]<-round(chr_sample$real_num[i]/expected, digits = 2)
      #chr_sample$sum<-sum(chr_sample$real_num)
      chr_sample$real_num_ratio[i]<-formatC(chr_sample$real_num[i]/sum(chr_sample$real_num), format = "e", digits = 2 )
    }
    selected_sample[selected_sample$chr==chr,"expected_num"]<-chr_sample$expected_num
    selected_sample[selected_sample$chr==chr,"ratio_real_expected"]<-chr_sample$ratio_real_expected
    selected_sample[selected_sample$chr==chr,"sum"]<-sum(chr_sample$real_num)
    selected_sample[selected_sample$chr==chr,"real_num_ratio"]<-chr_sample$real_num_ratio
  }
  
  write.table(selected_sample,file=paste(sample,"ratio_real_expected_&_real_num_ratio.txt",sep = "_"),quote = F)
}






