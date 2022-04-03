#devtools::install_github("ngthomas/microhaplot", build_vignettes = TRUE)
#microhaplot::mvShinyHaplot("~/Shiny") # provide a directory path to host the microhaplot app
#browseVignettes("microhaplot")
#Once it is installed, the Shiny app is run like this:
#app.path <- file.path("~/Shiny", "microhaplot")
#microhaplot::runShinyHaplot(app.path)

library(microhaplot)

wkdir="/lustre1/project/stg_00019/research/yan/microhap/microhap13_cfDNA"

setwd(paste(wkdir,"/step6_run_microhaplot",sep=""))

mvShinyHaplot("./")
app.path <- file.path("./", "microhaplot")

haplo.read.tbl <- prepHaplotFiles(run.label = "all_SNP",
                                  sam.path = paste(wkdir,"/step5_BWA_umicollapse",sep=""),
                                  out.path = "microhaplot/",
                                  label.path = "./label.txt",
                                  vcf.path =  "./chr16_1_7amplicons.vcf",
                                  app.path = app.path)