#! /usr/bin/env python
'''
CatalogID       Cnt     F       01B_trimmed_filtered    02B_trimmed_filtered    04C_trimmed_filtered    05B_trimmed_filtered    05D_trimmed_filtered    07A_trimmed_filtered    07B_trimmed_filtered    08A_trimmed_filtered    08D_trimmed_filtered    09A_trimmed_filtered    10B_trimmed_filtered    10C_trimmed_filtered    11A_trimmed_filtered    11C_trimmed_filtered    13A_trimmed_filtered    13B_trimmed_filtered    13C_trimmed_filtered    13D_trimmed_filtered    15A_trimmed_filtered    15D_trimmed_filtered    16A_trimmed_filtered    16B_trimmed_filtered    17A_trimmed_filtered    17B_trimmed_filtered    19A_trimmed_filtered    20A_trimmed_filtered    20C_trimmed_filtered    20D_trimmed_filtered    21A_trimmed_filtered    21B_trimmed_filtered    21C_trimmed_filtered    22B_trimmed_filtered    22C_trimmed_filtered    23A_trimmed_filtered    25A_trimmed_filtered    25D_trimmed_filtered    26A_trimmed_filtered    26D_trimmed_filtered    26E_trimmed_filtered    27A_trimmed_filtered    27B_trimmed_filtered    28B_trimmed_filtered
1       39      0       T       N       T       T       T       N       T       T       T       G       T       T       T       T       T       T       T       T       T       T       T       T       T       T       T       T       T       T       T       T       T       T       T       T       T       T       T       T       T       T       N       T
2       37      0       C       N       C       C       N       C       C       C       C       N       Y       C       C       C       C       C       C       C       C       C       C       C       C       C       C       C       C       C       C       C       C       C  
'''
import sys

BatchFileName = sys.argv[1]
BatchFile = open(BatchFileName, 'r')

OutFileName = "%s.snp" % BatchFileName[:-4]
OutFile = open(OutFileName, 'w')
LineCounter = 0
SampleDict= {}
SampleList = []
for line in BatchFile:
	if LineCounter == 0:
		line = line.strip().split()
		for item in line[3:]:
			SampleList.append(item)
			SampleDict[item] = ""
	else:
		Bases = []
		line = line.strip().split()
		if len(line[3]) ==0:
			print "problem"
#		if len(line[3]) ==1:
#			for item in line[3:]:
#				if item in ["A","G","C","T"] and item not in Bases:
#					Bases.append(item)
#			print Bases
		else:
			BaseCounter = 0
			for base in line[3]:
				Bases = []
				for group in line[3:]:
					#print BaseCounter, group[BaseCounter]
					if group[BaseCounter] == "Y" and "G" not in Bases and "A" not in Bases:
						Bases = ["C","T"]
					elif group[BaseCounter] == "R" and "C" not in Bases and "T" not in Bases:
						Bases = ["A","G"]
					elif group[BaseCounter] == "W" and "G" not in Bases and "C" not in Bases:
						Bases = ["A","T"]
					elif group[BaseCounter] == "S" and "A" not in Bases and "T" not in Bases:
						Bases = ["G","C"]
					elif group[BaseCounter] == "K" and "A" not in Bases and "C" not in Bases:
						Bases = ["T","G"]
					elif group[BaseCounter] == "M" and "G" not in Bases and "T" not in Bases:
						Bases = ["A","C"]
					elif group[BaseCounter] in ["A","G","C","T"] and group[BaseCounter] not in Bases:
						Bases.append(group[BaseCounter])
			PlaceCounter = 0
			for base in line[3]:
				SampleCounter = 0
				for group in line[3:]:
					if len(Bases) == 2:
						Score = ""
						if group[PlaceCounter] in ["Y","R","W","S","K","M"]:
							Score = "1"
						elif group[PlaceCounter] == "N":
							Score = "-"
						elif group[PlaceCounter] == Bases[0]:
							Score = "0"
						elif group[PlaceCounter] == Bases[1]:
							Score = "2"
						else:
							Score = "-"
							print LineCounter, line[0], Bases, group[PlaceCounter]
						SampleDict[SampleList[SampleCounter]] += Score
					SampleCounter +=1
				#print len(line[3]), Bases
				BaseCounter +=1
	LineCounter += 1
	
OutFile.write(">>>> begin comments <<<<\n")
OutFile.write("SNP data for %s samples\n" % BatchFileName[:-4])
OutFile.write(">>>> end comments <<<<\n")
for sample in SampleDict.keys():
	print sample, len(SampleDict[sample])
	OutFile.write("> " + sample + "\n")
	OutFile.write(SampleDict[sample] + "\n")
#print SampleDict
#print SampleList
