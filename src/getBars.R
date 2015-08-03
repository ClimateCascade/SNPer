### isolate ddRAD barcodes

library(gdata)
bars <- lapply(3:7,function(i,xls) read.xls(xls=xls,sheet=i),xls='../docs/RADseq_flowcell_072815_barcode-masterlist.xlsx')
names(bars) <- paste('ddRAD',c(4,5,6,7,9),sep='')

## for (i in 1:length(bars)){bars[[i]][,2] <- paste(names(bars)[i],bars[[i]][,2],sep='')}

lapply(1:length(bars),function(i,bars) write.table(bars[[names(bars)[i]]],file=paste('../docs/',names(bars)[i],'.barcodes',sep=''),sep='\t',row.names=FALSE,quote=FALSE),bars=bars)
