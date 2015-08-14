noNum <- function(x){
    x <- strsplit(x,split='')[[1]]
    paste(x[x %in% 0:9 == FALSE],collapse='')
}

getProj <- function(proj.id,flow,proj,ddRAD=FALSE){

proj <- proj[proj[,proj.id] == 'x',]

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

if (ddRAD==FALSE){proj[ids %in% flow.,]}else{
    sapply(ids[ids %in% flow.],
           function(x,y) colnames(flow.)[apply(flow.,2,function(z,q) any(z == q),q=x)],
           y=flow.)
}

}

getFileNames <- function(proj.id,flow,proj,ddrad=TRUE,fq=TRUE){

proj <- proj[proj[,proj.id] == 'x',]

flow <- apply(flow,2,as.character)
flow. <- toupper(flow)
flow. <- sub(' ','',flow.)
flow. <- sub('-','',flow.)
flow. <- sub('_','',flow.);flow. <- sub('_','',flow.);flow. <- sub('_','',flow.)

ids. <- paste(proj$Site,proj$Collection_no,sep='')
ids <- toupper(ids.)
ids <- sub(' ','',ids)
ids <- sub('-','',ids)
ids <- sub('_','',ids);ids <- sub('_','',ids);ids <- sub('_','',ids)

out <- flow[flow. %in% ids]

if (ddrad){
    ddrad <- sapply(ids[ids %in% flow.],
                    function(x,y) colnames(flow.)[apply(flow.,2,function(z,q) any(z == q),q=x)],
                    y=flow.)
    out <- paste(ddrad,names(ddrad),sep='/')
}
if (fq){out <- paste(out,'.fq',sep='')}
return(out)

}
