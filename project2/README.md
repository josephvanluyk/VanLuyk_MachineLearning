The project creates an array called evaluations which looks at each fruit in the testSet and keeps track of how many truePositives and falsePositives occurred. It then uses this data to calculate the Micro and Macro average, displaying both to the screen.

The Macro average is calculated by first calculating the individual precision scores of each fruit and averaging those with equal weight.

The Micro average is calculated by summing the total truePositives and dividing by truePositives + falsePositives.
