#ANBE script
#created 20130910
#This script will take pogo rad tag data and pick out a certain number of taxa that are present per tag
# and then also extract only those that have a certain number of SNPs
# try to vary 3, 6 ,12, 24 SNPs

#modified
#20130911 I ran 3SNP 28 taxa criteria
#20130911 I ran 6SNP 28 taxa criteria
#20130911 12SNP 28 taxa criteria ; 24 SNP 28 taxa
#20130913 1 SNP 28 taxa 

#20130918 5SNP 28 taxa criteia

import sys
import re

InFileName = sys.argv[1]
InFile = open(InFileName, 'r')
OutFileName = "%s_filter.tsv" % InFileName[:-4]
OutFile = open(OutFileName, 'w')

LineCounter = 0

for line in InFile:
	if LineCounter == 0:
		OutFile.write(line)
		LineCounter += 1
	elif "consensus" in line:
		LineCounter += 1
	else: 
		LineCounter += 1
		if re.search("\w\/\w+\/",line):
			print ">2 haplotypes"
		else:
			SNPline = line.replace("/","\t").split()
			diff = line.strip().split()
			print diff
			SNPs = len(max(SNPline[2:], key=len))
#			print SNPs
			if SNPs <= 5 and int(diff[1]) >=28: #changing SNP and taxa criteria here
#				print SNPs
				OutFile.write(line)
InFile.close()
OutFile.close()
