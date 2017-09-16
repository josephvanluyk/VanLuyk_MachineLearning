This projects takes in a text file with data related to 4 kinds of fruit and attempts to classify the various fruits.

It takes one forth of this data as test data, and three fourths as training data. This information
is stored in two model classes: Fruit and TestFruit. TestFruit is a subclass of Fruit that adds a guessedFruitID
in order to keep tack of the actual fruit and the guessed fruit. This guess occurs in a function called classify(fruit, k) which
takes in the test fruit and uses the k-nn algorithm.

Once the fruit has been classified, the program counts the correct and incorrect classifications, reports the accuracy, and then creates a graph that colors
each fruit based either on the correct fruit type or the guessed fruit type.
