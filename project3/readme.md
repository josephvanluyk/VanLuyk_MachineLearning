project3.py uses the files in the labeled-documents directory to classify files in the unlabeled-documents directory.

It looks at each file in the labeled-documents directory, generates a list of the five most common words
and their synonyms used within the file, and uses that to classify the unlabeled files as either "computing," "diabetes," or
unrelated. Wordnet was used to determine if anything in a file was a word as well as the synonyms of each word.

The file will be classified as whichever subject it had more words related to. However, if .01% of words are not 
related to diabetes or computing in the unlabeled file, it will not be given a classification. This threshold was chosen to
be so low because it is common for a file that actually is computing or diabetes to not have too many related words. The actual 
classfications of each file are placed in the file "Classifications" in the format "fileName	Actual Classification". It uses these
to calculate the accuracy, precision, and recall of the classifications (under the assumption that "computing" is a "positive" result).
