microhap<-"TGCGGATGTGGAGGGCCTC"
ref_microhap<-"CGCGGGTGTGGAGGGCCAT"
num_snp<-nchar(ref_microhap)

microhap<-strsplit(split="", microhap)[[1]]
ref_microhap<-strsplit(split="", ref_microhap)[[1]]

position_diff<-ref_microhap

ndiff<-0

for (j in 1:num_snp){
  if (microhap[j]!=ref_microhap[j]){
    print(paste("snp",j,"diff"))
    position_diff[j]<-paste(microhap[j],"//",ref_microhap[j])
    ndiff=ndiff+1
   }
 }
print(paste("microhap","has",ndiff,"diff snps"))
print(position_diff)

