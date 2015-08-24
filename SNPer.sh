#! /bin/bash

####################################################
### WARNING: please make sure you are working in the 
### correct location on the server.
####################################################

##############################
### Setup
##############################

## Assumes SNPer is in your home directory (~)

snp=true # get snps
rdata=true # convert to an rdata file

#Starts with demultiplexed files in the following directory:
seqdir=$1
outdir=$2 #output directory
batchid=$3 #the batch id used in stacks ref_map.pl and genotype.pl

refmap=~/indexes #~/indexes
nmismatch=3 #ref_map.pl -n = number of mismatches
mindepth=5 #ref_map.pl -m = minimum depth of coverage to report a stack
nthreads=8 #ref_map.pl -T = number of threads
minprog=1 #genotype.pl -r = minimum number of progeny to keep read
minstack=5 #genotype.pl -m = minimum stack depth for exporting a locus
maptype=GEN #genotype.pl -t = map type ('CP', 'DH', 'F2', 'BC1', and 'GEN')

#Load modules and alieses
module load stacks
module load bowtie
FASTX=/N/soft/mason/galaxy-apps/fastx_toolkit_0.0.13/fastx_trimmer
FASTQ=/N/soft/mason/galaxy-apps/fastx_toolkit_0.0.13/fastq_quality_filter

#################################
### Demultiplex, trim and filter
#################################

mkdir $outdir
cd $outdir

if [ $snp = "true" ]; then 

fqs=$(ls $seqdir)

mkdir trimmed filtered

for X in $fqs;
do 
    echo $seqdir/$X
    $FASTX -Q33 -f 5 -l 95 -i $seqdir/$X -o ./trimmed/$X;
#    mv $X original/$X;
done

fqs=$(ls ./trimmed)

for X in $fqs;
do 
    echo $X
    $FASTQ -Q33 -q 10 -p 100  -i ./trimmed/$X -o ./filtered/$X;
done

### Filtered reads are used from here on

#################################
###Identifying SNPs
#################################

### map to "reference" genome
ln -s $refmap ./indexes
mkdir sam
for X in $fqs; 
do 
    bowtie AphaenogasterRAD ./filtered/$X -S ./sam/$X.sam; 
done

# ###Build the following as a bash script that will then be called as sh sam_map.sh
echo "#! /bin/bash" | tee "sam_map.sh"
echo "ref_map.pl \\" | tee -a "sam_map.sh"
for X in $fqs;
do 
    if [ $X == "unknown" ]; then
	echo "Skipping unknown";
    else 
	echo "-s ./sam/$X.sam \\" | tee -a "sam_map.sh";
    fi
done
echo "-o ./output -n $nmismatch -m $mindepth -T $nthreads -b $batchid -S" | tee -a "sam_map.sh"
mkdir output
sh sam_map.sh

###############
### Genotyping
###############
# genotypes -b $batchid -P ./output -r $minprog -m $minstack -t GEN -s
genotypes -b $batchid -P ./output -r $minprog -m $minstack -t GEN -s -c
fi #end snp

################################
### SNP Filtering and Output
################################
if [ $rdata == "true" ]; then
    cd $outdir
    INPUT=./output/batch_$batchid.haplotypes_$minprog.tsv
    OUTPUT=./output/batch_$batchid.haplotypes_$minprog.gen
    Rscript ~/SNPer/bin/haplotype_to_genepop/haplotype_to_genepop.R $INPUT $OUTPUT radtags
fi

# INPUT=./output/batch_$batchid.haplotypes_$minprog.tsv
# VAR=./output/batch_$batchid.haplotypes_variable.tsv
# DIP=./output/batch_$batchid.haplotypes_variable$minstack.tsv
# AMBIG=./output/batch_$batchid.haplotypes_variable$minstack_single.tsv

# ### Fix CatalogID 
# sed -i "s|Catalog ID|CatalogID|g" $INPUT

# #### add input variables
# #### add correct input file
# ### python ../Filtering_taxaNUM_SNPnum.py input???

# grep -v "consensus" $INPUT > $VAR
# grep -v "\w*/\w*/" $VAR > $DIP
# python ../haplotype_to_ambig_code.py $DIP
# # python ../SNP_to_sequence.py $AMBIG "wasDDR2.fasta"
