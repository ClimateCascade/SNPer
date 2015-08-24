fixName <- function(x,spc=''){
    x <- as.character(x)
    x <- sub('.fq','',x)
    x <- toupper(x)
    x <- strsplit(x,split='')[[1]]
    x[(x %in% LETTERS | x %in% (0:9)) == FALSE] <- spc
    x <- paste(x,collapse='')
    return(x)
}
