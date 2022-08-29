# 4sd range 0.3-3.5
lower_lim<-0.3
upper_lim<-3.5

real_num_ratio_lim<-9.55e-05

wd<-"/Users/miffy/OneDrive - KU Leuven/0_working directory/microhap_PAP-smears/1_data_for_manuscript/10_CC129/microhaplot/CC129_batch3"
setwd(wd)
files<-list.files(path = wd,pattern = "*_ratio_real_expected_&_real_num_ratio.txt")

for(file in files){
  filepath <- file.path(wd,file)
  assign(file, read.table(filepath,sep = " ",header=T))
  name<-sub("_clean_results_ratio_real_expected_&_real_num_ratio.txt","",file)
  data<-get(file)
  chrs<-unique(data$chr)
  data_select<-matrix(0,0,10)
  for (chr in chrs) {
    data_chr<-data[data$chr==chr & data$real_num_ratio>real_num_ratio_lim,]
    data_chr_select<-data_chr[data_chr$ratio_real_expected<lower_lim|data_chr$ratio_real_expected>upper_lim,]
    if (nrow(data_chr_select)!=0){
      data_chr_select$real_num_ratio<-formatC(data_chr_select$real_num_ratio, format = "e", digits = 2)
      data_chr_select$ratio_real_expected<-round(data_chr_select$ratio_real_expected,digits=2)
    }
    data_select<-rbind(data_select,data_chr_select)
  }
  write.table(data_select,file = paste(name,"selected_according_to_fold_range",lower_lim,upper_lim,"real_num_ratio_lim",real_num_ratio_lim,".txt",sep="_"),quote = F,row.names = F)
}


