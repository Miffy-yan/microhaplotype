## Sun Sep 19 22:13:29 2021

#Rscript a.R > .log

name="CC113_16_2"

setwd("/Users/miffy/OneDrive - KU Leuven/0_working directory/microhap_PAP-smears/find_diff_list/")

data<-read.table("micrhap.txt")
colnames(data)<-c("chr","microhap","count")
data$microhap[which(is.na(data[,"microhap"]))]<-"NA"
# delete microhaplotypes which contain N or X and output the results to files
rows_withXN<-data[grep("N|X", data[,"microhap"]),]
data<-data[grep("N|X", data[,"microhap"], invert=TRUE),]
num_line<-nrow(data)
rownames(data)<-c(1:nrow(data))

write.table(rows_withXN, file=paste(name,"_nrows_withXN.txt",sep=""),col.names = T,row.names = T,quote = F)
write.table(data, file=paste(name,"_data_only_atcg.txt",sep=""),col.names = T,row.names = T,quote = F)

microhap_split<-strsplit(data$microhap,split = "")
num_snp<-length(microhap_split[[1]])

##get diff snp position & num
num_diff<-rep(0,num_line-1)
names(num_diff)<-paste("line",2:num_line,"_num_diff",sep="")
position_diff<-list()
for (i in 2:num_line){
  ndiff=0
  position_diff[[i-1]]<-rep(0,num_snp)
  for (j in 1:num_snp){
    if (microhap_split[[i]][j]!=microhap_split[[1]][j]){
      print(paste("line",i,"snp",j,"diff"))
      position_diff[[i-1]][j]<-microhap_split[[i]][j]
      ndiff=ndiff+1
    }
  }
  print(paste("line",i,"has",ndiff,"diff snps"))
  num_diff[i-1]<-ndiff
}

position_diff_matrix<-matrix(unlist(position_diff),byrow=T,nrow=num_line-1)
rownames(position_diff_matrix)<-paste("line",2:num_line,"_pos_diff",sep="")

write.table(num_diff, file=paste(name,"_num_diff.txt",sep=""),col.names = F,quote = F)
write.table(position_diff_matrix,file=paste(name,"_position_diff.txt",sep=""),col.names = F,row.names = T, quote = F)

