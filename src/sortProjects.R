### Sorting RADseqs by project
### MKLau 7Aug2015

### Assumes that SNPer is in your home directory

args <- commandArgs(TRUE)

## 1 Enter project name and destination directory
library(gdata)
source('~/SNPer/src/global.R')
src.dir <- args[1]
dest.dir <- args[2]

flow <- read.xls('~/SNPer/docs/RADseq_flowcell_072815_barcode-masterlist.xlsx')
proj <- read.csv('~/SNPer/docs/Data_allocation_mastersheet_01-26-15.csv')

if (args[3] == 'n'){
    colnames(proj)
}else{
    proj.name <- colnames(proj)[as.numeric(args[3]]
)

## 2 Get list of sample labels

flow <- apply(flow,2,as.character)
flow. <- toupper(flow)
flow. <- sub(' ','',flow.)
flow. <- sub('-','',flow.)
flow. <- sub('_','',flow.);flow. <- sub('_','',flow.);flow. <- sub('_','',flow.)

ids <- paste(proj$Site,proj$Collection_no,sep='')
ids <- toupper(ids)
ids <- sub(' ','',ids)
ids <- sub('-','',ids)
ids <- sub('_','',ids);ids <- sub('_','',ids);ids <- sub('_','',ids)

samples <- getProj(proj.name,flow,proj)[,c(11:13,15)]

## 3 Get list of matching seq names
samples <- data.frame(samples,path=getFileNames(proj.name,flow,proj))

## 4 copy seqs to destination directory


## 5 Make new barcode file?
