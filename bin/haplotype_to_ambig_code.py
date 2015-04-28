#! /usr/bin/env python

import sys

InFileName = sys.argv[1]
InFile = open(InFileName, 'r')
OutFileName = "%s_single.tsv" % InFileName[:-4]
OutFile = open(OutFileName, 'w')

Code = {"AC":"M", "CA":"M","CT":"Y","TC":"Y","AG":"R","GA":"R","AT":"W","TA":"W","GC":"S","CG":"S","TG":"K","GT":"K"} 
LineCounter = 0
for line in InFile:
	if LineCounter == 0:
		OutFile.write(line)
		LineCounter += 1
	elif "consensus" in line:
		LineCounter += 1
	else: 
		LineCounter += 1
#		print LineCounter
		SNPline = line.replace("/","\t").split()
		line = line.strip().split()
		SNPs = len(max(SNPline[3:], key=len))
		if LineCounter == 30:
			print SNPline
			print SNPs
		newline = "%s\t%s\t%s" % (line[0],line[1],line[2])
		for Item in line[3:]:
			if Item == "-":
				Single = ""
				for X in range(0,SNPs):
					Single += "N"
				newline += "\t%s" % Single
			elif "/" in Item:
				Item = Item.split("/")
				NewHaplotype = ""
				for SNP in range(len(Item[0])):
					NewString = ""
					for Haplotype in range(len(Item)):
						NewString += Item[Haplotype][SNP]
					NewString = ''.join(set(NewString))
					if len(NewString) > 2:
						NewString = "N"
					elif len(NewString) > 1:
						NewString = Code[NewString]
					NewHaplotype += NewString
				newline += "\t%s" % NewHaplotype
			else:
				newline += "\t%s" % Item
		newline += "\n"
		OutFile.write(newline)
InFile.close()
OutFile.close()
