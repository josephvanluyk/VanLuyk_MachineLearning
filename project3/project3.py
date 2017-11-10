import os
import sys
import math
import nltk
from os import listdir
from os.path import isfile, join
from nltk.corpus import wordnet
from nltk.corpus import stopwords
from nltk.corpus import wordnet


class WordObject  :
	def __init__(self, countParam,wordParam) :
		self.wordCount = countParam
		self.word = wordParam

class Document:
	def __init__(self, fileName):
		self.fileName = fileName
		self.words = []
		self.guessedClassification = None;
		self.actualClassification = None;
	def __str__(self):
		return self.fileName
	def loadWords(self):
		if(len(self.words) == 0):
			with open(self.fileName, "r") as file:
				for line in file:
					split = line.split(" ")
					for word in split:
						if wordnet.synsets(word) and word not in stopwords.words("english"):
							self.words.append(word)
		else:
			raise Exception("Words already loaded")
	#Returns the frequency of words in "words" list that are also in wordSet
	def calculateFrequency(self, wordSet):
		if len(self.words) == 0:
			raise Exception("Words not loaded")
		count = 0
		for word in self.words:
			if word in wordSet:
				count += 1
		return count/len(self.words)


# This script inputs the labelled documents and outputs
# the highest frequent words, the input paramater for the
# script shows how many words to output


# Object Labeled files
labeledDirectory = sys.argv[1]
labeledFiles = [ f for f in listdir(labeledDirectory) if isfile(join(labeledDirectory, f))]

# Obtain unlabeled files
unlabeledDirectory = sys.argv[2]
unlabeledFiles = [ f for f in listdir(unlabeledDirectory) if isfile(join(unlabeledDirectory, f))]


# GET THE BAG OF WORDS IN THE LABELED FILE AND PUT THEM IN THE BAG OF WORDS MAP
wordsInFileMap = { }

for fileName in labeledFiles :
	file = open(labeledDirectory + "/" + fileName,"r")
	wordSet = []
	wordsInFileMap[fileName] = wordSet
	#implement a word tokenizer within the loop
	for line in file:

		# Filter stop words either from the nltk set , or your own user defined set

		# Get onley the word, make sure it ia a word.
		# If it is a word and not a stop word then add it to the list
		# temp.append(line.split())
		splitWords = line.split()
		for word in splitWords :
			if ( wordnet.synsets(word) and (word not in stopwords.words('english'))) :

				# realWord = wordnet.synsets(word)[0].lemma_names()[0]
				wordSet.append(word)
	file.close()
# ITERATE OVER EACH SET OF LIST OF SELECTEDWORDSMAP[FILENAME], INCREMEMENT WORD COUNT FOR EACH WORD,
# EACH WORD REPRESENTS A KEY FROM THE DICTIONARY WORDMAP, EACH WORDLIST HAS A WORDMAP DICTIONARY

wordList = []
labeledListMap = {}




for fileName in labeledFiles :
	# WORD MAP WILL COMPOSE OF THE WORD COUNT FOR EVERY DICTIONARY LOOK UP
	wordMap = {}
	wordList.append(wordMap)
	wordSetFromFile = wordsInFileMap[fileName]
	for word in wordSetFromFile :
		keys = wordMap.keys()

		if word in keys :
			wordMap[word] += 1
		else :
			wordMap[word] = 1

#	for wordKey, wordValue in wordMap.items() :
#		print("\n" + fileName + " + " + wordKey + " " + str(wordValue) + "\n")

	finalList = []
	fullLabeledSet = set()
	labeledListMap[fileName] = fullLabeledSet
	for i in range(5) :
		highestCount = 0
		selectedKey = -1
		for wordKey, wordCount in wordMap.items() :
			if wordCount > highestCount :
				highestCount = wordCount
				selectedKey = wordKey

		wordObject = WordObject(highestCount, selectedKey)

		# REMOVE FROM WORDMAP
		del wordMap[selectedKey]

		finalList.append(wordObject)


	for word in finalList :
		for wordSetInst in wordnet.synsets(word.word) :
			for newWords in wordSetInst.lemma_names() :
				fullLabeledSet.add(newWords)
		#print(fileName + " " + str(object.wordCount) + " " + object.word)

	#for word in fullLabeledSet :
	#	print(fileName + " " + word)

		# put this wordValue in the finalSet with its synonyms , remove the selectedKey entry from the dictionary



diabetesWords = labeledListMap["labeled-1.rtf"]
computingWords = labeledListMap["labeled-2.rtf"]
unlabeledDocuments = []
for fileName in unlabeledFiles:
	unlabeledDocuments.append(Document(unlabeledDirectory + "/" + fileName))

with open("Classifications", "r") as file:
		for line in file:
			for doc in unlabeledDocuments:
				split = line.split("	")
				if split[0].strip() == str(doc):
					doc.actualClassification = split[1].strip()
print("{0:35}\t{1:20}\t{2:20}\t{3:20}\t{4:20}".format("FileName", "Diabetes Frequency", "Computing Frequency", "Guessed Classification", "Actual Classification"))
for doc in unlabeledDocuments:
		doc.loadWords();
		dFrequency = doc.calculateFrequency(diabetesWords);
		cFrequency = doc.calculateFrequency(computingWords);
		if(dFrequency > cFrequency):
			doc.guessedClassification = "Diabetes"
		else:
			doc.guessedClassification = "Computing"

		if(dFrequency < .0001 and cFrequency < .0001):
			doc.guessedClassification = None

		print("%-35s\t%-20.6f\t%-20.6f\t%-20s\t%-20s" % (str(doc), dFrequency, cFrequency, doc.guessedClassification, doc.actualClassification))

#Assuming Computing is the "Positive" reuslt.
truePositives = 0;
falsePositives = 0;
trueNegatives = 0;
falseNegatives = 0;

for doc in unlabeledDocuments:
	if(doc.guessedClassification == "Computing"):
		if(doc.actualClassification == "Computing"):
			truePositives += 1
		else:
			falsePositives += 1
	else:
		if doc.actualClassification == "Computing":
			falseNegatives += 1
		else:
			trueNegatives += 1
print("")
print("%10s\t%.5f" % ("Recall:", truePositives/(truePositives + falseNegatives)))
print("%10s\t%.5f" % ("Precision:", truePositives/(truePositives + falsePositives)))

correct = 0;
count = 0;
for doc in unlabeledDocuments:
	if doc.guessedClassification == doc.actualClassification:
		correct += 1
	count += 1

print("%10s\t%.5f" % ("Accuracy:", correct/count))
