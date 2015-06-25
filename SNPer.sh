#! /bin/bash

####################################################
### WARNING: please make sure you are working in the 
### correct location on the server.
####################################################

##############################
### Setup
##############################

#################################################################
### Assume you are working locally (./) with an unzipped file ###
#################################################################

outdir=snps1238 #output directory
demultiplex=false
demultmove=false
snp=false
rdata=false
pydata=true

barcodes=~/scahan/Aphaenogaster_RADfiles/ddRAD1.txt #formatted: GCATG<tab>03A
rads=/N/u/mklau/Mason/mklau/ads/SNPer/ddRAD1238  #unzipped file path
demultfiles=/N/u/mklau/Mason/mklau/ads/SNPer/ddRAD1238
=======
#Assume you are working locally (./) with an unzipped file 
outdir=ddRAD1 #output directory
demultiplex=true
snp=false
rdata=false
barcodes=~/scahan/Aphaenogaster_RADfiles/ddRAD1.txt #formatted: GCATG<tab>03A
rads=/N/u/mklau/Mason/scahan/ddRAD1/scahan_VGN_20140730_2014_ddRad1_R1.fastq #unzipped file path
refmap=~/indexes #~/indexes
batchid=2 #the batch id used in stacks ref_map.pl and genotype.lp
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

if [ $demultiplex = "true" ]
then
    mkdir $outdir
    cd $outdir
    sabre se -m 1 -f $rads -b $barcodes -u unknown
    cd ..
elif [ $demultiplex = "false" ] && [ $demultmove = "true" ]
then
    mkdir $outdir
    cd $outdir
    cp $demultfiles/* .
    cd ..
fi ## end demultiplex

cd $outdir

if [ $snp = "true" ]; then 
    fqs=$(ls)
    mkdir trimmed original
    for X in $fqs;
    do 
	echo $X
	$FASTX -Q33 -f 5 -l 95 -i $X -o ./trimmed/$X;
	mv $X original/$X;
    done
    mkdir filtered
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
<<<<<<< HEAD
    genotypes -b $batchid -P ./output -r $minprog -m $minstack -t GEN -s -c
=======
genotypes -b $batchid -P ./output -r $minprog -m $minstack -t GEN -s -c
>>>>>>> 65b128c3fc803e620c44b52e0e44504abde077c7
fi #end snp

################################
### SNP Filtering and Output
################################
if [ $rdata == "true" ]; then
    INPUT=./output/batch_$batchid.haplotypes_$minprog.tsv
    OUTPUT=./output/batch_$batchid.haplotypes_$minprog.gen
    Rscript ../bin/haplotype_to_genepop/haplotype_to_genepop.R $INPUT $OUTPUT radtags
fi

if [ $pydata == "true" ]; then
    INPUT=./output/batch_$batchid.haplotypes_$minprog.tsv
    sed -i 's/atalog\ /atalog/g' $INPUT
    python ../bin/make_genotype_file_for_adegenet.py $INPUT
fi

=======
    mkdir rdata
    INPUT=./output/batch_$batchid.haplotypes_$minprog.tsv
    OUTPUT=./rdata/batch_$batchid.haplotypes_$minprog.gen
    Rscript ../bin/haplotype_to_genepop/haplotype_to_genepop.R $INPUT $OUTPUT radtags
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
# python ../SNP_to_sequence.py $AMBIG "wasDDR2.fasta"
