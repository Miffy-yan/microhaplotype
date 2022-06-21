# read in two args[1] microhap and args[2] ref_microhap
# args <- commandArgs(trailingOnly = TRUE)
# This takes any arguments we specify and assigns them to ‘args’. 
args <- commandArgs(trailingOnly = TRUE)
microhap <- as.character(args[1])  
ref_microhap <- as.character(args[2]) 

# get the number of nucleotides in each microhap
num_snp<-nchar(ref_microhap)
num_snp_test<-nchar(microhap)

# check whether the two microhaps are of the same length
# stop and give an error if not equal
if(num_snp!=num_snp_test) 
  stop("Error: length of test microhap does not equal to ref_microhap!!")

# convert the micrhaps to string vectors
microhap<-strsplit(split="", microhap)[[1]]
ref_microhap<-strsplit(split="", ref_microhap)[[1]]

#get position_diff
position_diff<-vector(mode="character",length=num_snp)

ndiff<-0
for (j in 1:num_snp){
  if (microhap[j]!=ref_microhap[j]){
    print(paste("snp",j,"diff"))
    position_diff[j]<-paste(microhap[j],"\tref",ref_microhap[j])
    ndiff=ndiff+1
  }else{
    position_diff[j]<-paste(microhap[j])
   }
 }
print(paste("microhap","has",ndiff,"diff snps"))
print(position_diff)

write.table(position_diff, file="position_diff.txt",quote = F,col.names = F)



