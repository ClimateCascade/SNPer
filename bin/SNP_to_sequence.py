#! /usr/bin/env python
'''
Sara Helms Cahan
8/15/13
A script to take ambiguous code SNP calls from STACKS batch_1.haplotypes.tsv data processed with haplotype_to_ambig_code.py (N for missing data, one tag ID column and two count columns; need to edit Name of tag ID column to remove space) and convert them to a fasta file with sample name and a pseudosequence of ordered SNPs.
Optional to use a list of RAD_IDs to select only a subset of SNPs for the sequences.
'''
import sys

InFileName = sys.argv[1]
OutFileName = sys.argv[2]
InFile = open(InFileName, 'r')
LineCounter = 0
SampleDict = {}
SampleList = []
#this is the optional filtering step - comment out if not needed
'''
InFile2Name = sys.argv[2]
InFile2 = open(InFile2Name, 'r')
IDList = []
for line in InFile2:
	line=line.strip()
	IDList.append(line)
'''
for Line in InFile:
	LineCounter +=1
#	Line = Line.strip().split()
#	if len(Line) != 38:
#		print LineCounter, len(Line), Line
#	print LineCounter
	if LineCounter ==1:
		Line = Line.strip().split()
		for Name in Line:
			SampleList.append(Name)
		for Item in Line[3:]:
			SampleDict[Item] = ""
#		print len(SampleList)
#		print SampleDict, len(SampleDict), SampleList, len(SampleList)
#	elif LineCounter ==2:
#		Line = Line.strip().split()
#		for Number in range(1,len(Line)):
#			print Number, Line[Number], len(Line)
	else:
		Line = Line.strip().split()
		print len(Line)
		for Number in range(3,len(Line)):
			SampleDict[SampleList[Number]]+=Line[Number]
#more stuff if you want to filter
	'''
		for Name in IDList:
			if Name in Line:
				Line = Line.strip().split()
				for Number in range(1,len(Line)):
					SampleDict[SampleList[Number]]+=Line[Number]
					if len(Line[Number]) > 1:
						print LineCounter
						'''
#print SampleDict[SampleList[Number]]
InFile.close()

OutFile = open(OutFileName, 'w')
for Sample in SampleDict.keys():
	print Sample, len(SampleDict[Sample])
	OutFile.write(">"+Sample+"\n")
	OutFile.write(SampleDict[Sample]+"\n")
OutFile.close()

