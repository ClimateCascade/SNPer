### Sorting RADseqs by project
### MKLau 7Aug2015

### Assumes that SNPer is in your home directory

args <- commandArgs(TRUE)
### args <- c('3','~/mklau/ddRADs','~/mklau/ddRADs/projects')

master <- read.csv('../docs/Data_allocation_mastersheet_01-26-15.csv')
seqs <- read.csv('../docs/RADseq_flowcell_072815_barcode-masterlist.csv')

seqs
master
