### Sorting RADseqs by project
### MKLau 7Aug2015

### Assumes that SNPer is in your home directory

args <- commandArgs(TRUE)
### args <- c('3','~/mklau/ddRADs','~/mklau/ddRADs/projects')
## 1 Enter project name and destination directory
source('~/SNPer/src/global.R')

proj <- read.csv('~/SNPer/docs/Data_allocation_mastersheet_01-26-15.csv')

if (args[1] == 'n'){
    colnames(proj)
}else{
    library(gdata)
    flow <- read.xls('~/SNPer/docs/RADseq_flowcell_072815_barcode-masterlist.xlsx')
    src.dir <- args[2]
    dest.dir <- args[3]
    if (any(strsplit(args[1],split='')[[1]] %in% as.character(0:9))){
        proj.name <- colnames(proj)[as.numeric(args[1])]    
    }else{proj.name <- args[1]}

## 2 Get list of sample labels

samples <- getProj(proj.name,flow,proj)[,c(11:13,15)]

## 3 Get list of matching seq names
samples <- data.frame(samples,path=getFileNames(proj.name,flow,proj))
print(samples)

## 4 copy seqs to destination directory
for (i in 1:length(samples$path)){
    src.file <- paste(src.dir,samples$path[i],sep='/')
    sam <- strsplit(as.character(samples$path[i]),split='\\/')[[1]][2]
    dest.file <- paste(dest.dir,sam,sep='/')
    sys.cmd <- paste('cp',src.file,dest.file)
    system(sys.cmd)
}


system(paste('ls',dest.dir))
print('Done!')
Sys.time()
## 5 Make new barcode file?

}
