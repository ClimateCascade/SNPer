### Matching the barcodes to sample IDs.
### MKLau 5Aug2015

library(gdata)

flow <- read.xls('~/SNPer/docs/RADseq_flowcell_072815_barcode-masterlist.xlsx')
proj <- read.csv('~/SNPer/docs/Data_allocation_mastersheet_01-26-15.csv')

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

table(ids)[table(ids)==2]
