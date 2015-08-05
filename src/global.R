noNum <- function(x){
    x <- strsplit(x,split='')[[1]]
    paste(x[x %in% 0:9 == FALSE],collapse='')
}
