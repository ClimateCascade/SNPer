### Sorting RADseqs by project
### MKLau 7Aug2015

print('initiate')

source('global.R')
args <- commandArgs(TRUE)

### args[1] <- '~/mklau/ddRADs'
### args[2] <- '~/mklau/test/projects'

in.dir <- args[1]
drl <- paste(in.dir,paste('ddRAD',1:9,sep=''),sep='/')
out.dir <- args[2]
seqs <- sapply(drl,dir)
seqs <- lapply(seqs,function(x) x[x != 'unknown' & grepl('ddRAD',x,ignore.case=TRUE) == FALSE])
seqs[[7]] <- seqs[[7]][seqs[[7]] != 'APHPIC32.fq']
names(seqs) <- paste('ddRAD',1:9,sep='')

print('duplicate check')
## check for duplicates
if (any(unlist(lapply(seqs,table)) != 1)){
    warning('Diplicate present')
    print(unlist(lapply(seqs,table))[unlist(lapply(seqs,table)) != 1])
}


print('load names')
## Get the names of files based on matching with RAD-SEQ names
master <- read.csv('../docs/RADseq_mastersheet_2014.csv')
master <- master[master[,10] != '',]
seqs <- unlist(seqs)
dam <- read.csv('../docs/Data_allocation_mastersheet_01-26-15.csv')

seqs. <- sapply(unlist(sub('.fq','',seqs)),function(x) sapply(x,fixName))
master.names <- as.character(sapply(paste(master[,2],master[,3],sep='_'),fixName))
file.names <- character(0)

for (i in 1:length(master.names)){
    if (length(seqs[master.names[i] == seqs.]) != 1){
        file.names[i] <- NA
    }else{
        file.names[i] <- paste(master[i,10],seqs[master.names[i] == seqs.],sep='/')
    }
}

## delimit to extant names
master <- master[is.na(file.names) == FALSE,]
master.names <- master.names[is.na(file.names) == FALSE]
file.names <- file.names[is.na(file.names) == FALSE]

print('match project and seq names')
## get correct project names
projects <- dam[,1:10]
projects <- apply(projects,2,as.character)
for (i in 1:ncol(projects)){
    projects[projects[,i] == 'x',i] <- fixName(colnames(projects)[i])
}

proj.id <- as.character(sapply(paste(dam[,12],dam[,13],sep=''),fixName))
master.id <- list()

## match project names to file names in master

for (i in 1:length(master.names)){
    if (sum(master.names[i] == proj.id) == 1){
        master.id[[i]] <- projects[master.names[i] == proj.id,]
    }else{master.id[[i]] <- NA}
}

master.id <- do.call(rbind,master.id)
master.id[is.na(master.id)] <- ''
project.names <- unique(as.character(master.id))
project.names <- as.character(na.omit(project.names[(project.names %in% c('')) == FALSE]))
colnames(master.id) <- apply(master.id,2,function(x) unique(x[x != ''])[1])
master.id <- master.id[,is.na(colnames(master.id)) == FALSE]


print('sorting')
## Sort by project

#1 use project.names out.dir to make output folders
out.dir <- paste(out.dir,project.names,sep='/')
names(out.dir) <- project.names
sapply(out.dir,dir.create)

#2 use out.dir, project.names, master.id and file.names
for (i in 1:length(project.names)){
    in.files <- master.id[,colnames(master.id) == project.names[i]]
    in.files <- file.names[in.files == project.names[i]]
    out.files <- master.id[,colnames(master.id) == project.names[i]]
    out.files <- master.names[out.files == project.names[i]]
    in.loc <- paste(in.dir,in.files,sep='/')
    out.loc <- paste(out.dir[names(out.dir) == project.names[i]],out.files,sep='/')
    sys.cmd <- paste('cp',in.loc,out.loc)
    print(project.names[i])
    sapply(sys.cmd,system)
}

print('checking output')
#3 check output folder contents using dir and length
out.check <- unlist(sapply(out.dir,function(x) length(dir(x)))) == apply(master.id[,colnames(master.id) %in% project.names],2,table)[2,]
if (all(out.check)){print(all(out.check))}else{print(out.check)}
