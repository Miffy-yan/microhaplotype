min_reads <- 50 
lower_lim<-0.4
upper_lim<-2.0
# fold range 3sd: 2.0-0.4 95.8% control sample fall within this region
wd<-"/Users/miffy/OneDrive - KU Leuven/0_working directory/microhap_PAP-smears/19_new_pap_samples/CC112/microhap_raw_resuts/CC112_batch3"
setwd(wd)
files<-list.files(path = wd,pattern = "*_fold.txt")

for(file in files){
  filepath <- file.path(wd,file)
  assign(file, read.table(filepath,sep = " ",header=T))
  name<-sub("_clean_results_expected_fold.txt","",file)
  data<-get(file)
  chrs<-unique(data$chr)
  data_select<-matrix(0,0,8)
  for (chr in chrs) {
    data_chr<-data[data$chr==chr&data$num>50,]
    data_chr_select<-data_chr[data_chr$fold<lower_lim|data_chr$fold>upper_lim,]
    data_select<-rbind(data_select,data_chr_select)
  }
  write.table(data_select,file = paste(name,"selected_according_to_fold_range.txt",sep="_"),quote = F)
}


