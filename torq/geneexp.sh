#! /bin/bash

#PBS -k o 
#PBS -l nodes=1:ppn=8,vmem=10gb,walltime=05:00:00
#PBS -M matthewklau@fas.harvard.edu
#PBS -m abe 
#PBS -N genexp.snps
#PBS -j oe 

sh ~/SNPer/SNPer.sh ~/ddRADs/projects/GENEEXPRESSIONPHYTOTRON ~/mklau/snps/geneexp 
