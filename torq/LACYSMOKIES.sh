#! /bin/bash

#PBS -k o 
#PBS -l nodes=1:ppn=8,vmem=100gb,walltime=24:00:00
#PBS -M matthewklau@fas.harvard.edu
#PBS -m abe 
#PBS -N LACYSMOKIES.snps
#PBS -j oe 
#PBS -d /N/u/mklau/Mason/SNPer

bash SNPer.sh ~/mklau/ddRADs/projects/LACYSMOKIES ~/mklau/snps/LACYSMOKIES 1
