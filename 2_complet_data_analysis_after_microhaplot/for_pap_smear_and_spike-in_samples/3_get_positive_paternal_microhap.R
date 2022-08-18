min_reads <- 60 
#[1] "1 of the microhaplotypes with more than 60 supporting reads are in the range if + - 3sd range 0.41-2.75"
#0.41-2.75
lower_lim<-0.41
upper_lim<-2.75
# fold range mean+-3sd
wd<-"/Users/miffy/OneDrive - KU Leuven/0_working directory/microhap_PAP-smears/19_new_pap_samples/CC129/microhaplot/CC129_batch3"
setwd(wd)
files<-list.files(path = wd,pattern = "*_ratio_real_expected.txt")

for(file in files){
  filepath <- file.path(wd,file)
  assign(file, read.table(filepath,sep = " ",header=T))
  name<-sub("_clean_results_ratio_real_expected.txt","",file)
  data<-get(file)
  chrs<-unique(data$chr)
  data_select<-matrix(0,0,8)
  for (chr in chrs) {
    data_chr<-data[data$chr==chr&data$real_num>min_reads,]
    data_chr_select<-data_chr[data_chr$ratio_real_expected<lower_lim|data_chr$ratio_real_expected>upper_lim,]
    data_select<-rbind(data_select,data_chr_select)
  }
  write.table(data_select,file = paste(name,"selected_according_to_fold_range",lower_lim,upper_lim,"min_reads",min_reads,".txt",sep="_"),quote = F,row.names = F)
}


