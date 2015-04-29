### Make a tree for ddRAD2
### MKLau 28Apr2015

library(adegenet)
library(txtplot)
if (any(ls()=='y')){}else{y <- read.genepop('../SNPs/rdata/batch_2.haplotypes_3.gen')}
x <- y$tab;rownames(x) <- y$ind.names

### quality checks
sample.qc <- apply(x,1,sum,na.rm=TRUE)/ncol(x) * 100
locus.qc <- apply(x,2,sum,na.rm=TRUE)/nrow(x) * 100
txtplot(locus.qc[seq(1,length(locus.qc),500)])
## remove loci that are present in less than 10% of samples
x <- x[,locus.qc > 10]
locus.qc <- apply(x,2,sum,na.rm=TRUE)/nrow(x) * 100
txtplot(locus.qc[seq(1,length(locus.qc),500)])

### repack into genind
x <- genind(x);rownames(x$tab) <- x$ind.names
rownames(y$tab) <- y$ind.names

### Tree
pdf('tree.pdf',width=13)
par(mfrow=c(1,2));plot(hclust(dist(y)),main='All');plot(hclust(dist(x)),main='> 10%')
dev.off();system('scp tree.pdf matthewklau@fas.harvard.edu:public_html; rm tree.pdf')

pdf('dcor.pdf')
par(mfrow=c(1,1));plot(dist(x)~dist(y))
dev.off();system('scp dcor.pdf matthewklau@fas.harvard.edu:public_html; rm dcor.pdf')

pdf('nacor.pdf')
nap.y <- apply(y$tab,1,function(x) length(x[is.na(x)]))
par(mfrow=c(1,1));plot(dist(y)~dist(matrix(nap.y,ncol=1)))
dev.off();system('scp nacor.pdf matthewklau@fas.harvard.edu:public_html; rm nacor.pdf')

