### Sorting RADseqs by project
### MKLau 7Aug2015

print('initiate')

source('global.R')
args <- commandArgs(TRUE)

### args[1] <- '~/mklau/ddRADs'; args[2] <- '~/mklau/test/projects'
in.dir <- args[1]
drl <- paste(in.dir,paste('ddRAD',1:9,sep=''),sep='/')
out.dir <- args[2]
seqs <- sapply(drl,dir)
seqs <- lapply(seqs,function(x) x[x != 'unknown' & grepl('ddRAD',x,ignore.case=TRUE) == FALSE])
seqs[[7]] <- seqs[[7]][seqs[[7]] != 'APHPIC32.fq']
names(seqs) <- paste('ddRAD',1:9,sep='')
dam <- read.csv('../docs/Data_allocation_mastersheet_01-26-15.csv')

project <- apply(dam[,1:10],2,as.character)
project[project == 'x'] <- TRUE
project[is.na(project)] <- ""
project[project != "TRUE"] <- FALSE
project <- apply(project,2,as.logical)
colnames(project) <- as.character(sapply(colnames(project),fixName))

pid <- sapply(paste(dam[,12],dam[,13],sep=''),fixName)
sid <- lapply(seqs,function(x) sapply(x,fixName))

pid.l <- apply(project,2,function(x,pid) pid[x],pid=pid)

out.list <- lapply(pid.l,function(pid,sid) sid[sid %in% pid],sid=unlist(sid))

## rm.list <- lapply(pid.l,function(pid,sid) pid[pid %in% sid == FALSE],sid=unlist(sid))
## ag.search <- sapply(rm.list[[1]],function(x,sid) sid[agrep(x,sid,ignore.case=T)],sid=unlist(sid))

out.list <- lapply(out.list,names)
out.ddrad <- lapply(out.list,function(x) substr(x,1,6))
out.list <- lapply(out.list,function(x) substr(x,8,nchar(x)))
in.list <- list()

for (i in 1:length(out.list)){
    in.list[[i]] <- paste(out.ddrad[[i]],'/',out.list[[i]],sep='')
}

for (i in 1:length(out.list)){
    out.list[[i]] <- paste(names(out.list)[i],'/',out.list[[i]],sep='')
}

sapply(paste(out.dir,names(out.list),sep='/'),dir.create)

for (i in 1:length(out.list)){
    print('Copying...')
    print(names(out.list)[i])
    sys.in <- paste(paste(in.dir,in.list[[i]],sep='/'),paste(out.dir,out.list[[i]],sep='/'))
    sys.in <- paste('cp',sys.in)
    print(sys.in)
    sapply(sys.in,system)
}

print('Done!')
