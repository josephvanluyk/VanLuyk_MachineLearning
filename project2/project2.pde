import java.util.ArrayList;
import java.math.*;
import java.awt.Color;
ArrayList<TestFruit> testSet;
ArrayList<Fruit> trainingSet;
Table dataset;
int rowCount;
int[] colors;
/*
  Used for k-nearest-neighbors algorithm.
  With k = 1, a fruit is classified as the same thing as the fruit that is closest to it.
*/
final int k = 1;
void setup(){
  dataset = new Table("fruit_data_with_colors.txt");
  trainingSet = new ArrayList<Fruit>();  //Will hold all of the fruit used for training the algorithm
  testSet = new ArrayList<TestFruit>();  //Will hold all of the fruit used for testing the algorithm
  rowCount = dataset.getRowCount();
  int fruitID;
  float height;
  float width;
  for(int i = 1; i < rowCount; i++){
    fruitID = dataset.getInt(i, 0);
    height = dataset.getFloat(i, 5);
    width = dataset.getFloat(i, 4);
    
    //Every fourth fruit is in the testing set. All others are in the training set
    if(i % 4 == 0){
      testSet.add(new TestFruit(fruitID, height, width));
    }else{
      trainingSet.add(new Fruit(fruitID, height, width));
    }
  
  
  }
  //Iterate through each fruit in the testing set and classify it using the k-nn algorithm.
  for(int i = 0; i < testSet.size(); i++){
    classify(testSet.get(i), k);
  }
  
  
  int correct = 0;
  int wrong = 0;
  TestFruit currentFruit;
  
  //Count the number of correct classifications and incorrect classifications
  for(int i = 0; i < testSet.size(); i++){
    currentFruit = testSet.get(i);
    if(currentFruit.fruitID == currentFruit.guessedFruitID){
    	correct++;
    }else{
    	wrong++;
    }

  }
  
  print("Correct:\t" + correct + "\n");
  print("Wrong:\t" + wrong + "\n");
  String accuracy = nf(100.0*correct/(correct + wrong), 2, 2);
  print("Accuracy:\t" + accuracy + "%\n");
  colors = new int[5];
  colors[0] = #00FF00;
  colors[1] = #00FFFF;
  colors[2] = #FF00FF;
  colors[3] = #FFFF00;
  size(700, 700);
  
  /*
  evaluations_i contains a pair (x, y).
  x contains the count of true positives for the fruit with fruitID of (i - 1).
  y contains the false positives for the fruit with fruitID (i - 1);
  */
  Pair[] evaluations =  new Pair[4];
  for(int i = 0; i < evaluations.length; i++){
  	evaluations[i] = new Pair(0, 0);
  }
  
  for(int i = 0; i < testSet.size(); i++){
  	if(testSet.get(i).fruitID == testSet.get(i).guessedFruitID){
  		evaluations[testSet.get(i).guessedFruitID - 1].x++;
  	}else{
  		evaluations[testSet.get(i).guessedFruitID - 1].y++;
  	}
  }
  
  float[] precisionScores = new float[4];
  for(int i = 0; i < evaluations.length; i++){
  	precisionScores[i] = ((float)evaluations[i].x/(evaluations[i].x + evaluations[i].y));
  }
  
  float Average_macro;
  float Average_micro;
  float sum = 0;
  for(int i = 0; i < precisionScores.length; i++){
  	sum += precisionScores[i];
  }
  Average_macro = sum/precisionScores.length;
  
  int truePositives = 0;
  int falsePositives = 0;
  for(int i = 0; i < evaluations.length; i++){
  	truePositives += evaluations[i].x;
  	falsePositives += evaluations[i].y;
  }
  
  Average_micro = ((float)truePositives/(truePositives + falsePositives));
  
  
  /*
  	Because the micro and macro average are so close, the k-nn algorithm has similar effectiveness for both the largest and smallest classes.
  */
  String out = nf(100*Average_micro, 2, 2);
  print("Micro Average:\t" + out + "%\n");
  out = nf(100*Average_macro, 2, 2);
  print("Macro Average:\t" + out + "%\n");
  
  
  
  
  
  
}


/*
  Given two fruit as input, calculates the euclidean distance between the two.
*/
float distance(Fruit fruitOne, Fruit fruitTwo){
  float dHeight;
  float dWeight;
  dHeight = fruitOne.height - fruitTwo.height;
  dWeight = fruitOne.width - fruitTwo.width;
  
  return (float)Math.sqrt(dHeight*dHeight + dWeight*dWeight);
}



/*
  Takes fruit as input and changes its guessedFruitID value to
   the value predicted using the k-nearest neighbors algorithm.
*/
void classify(TestFruit fruit, int k){
   //Allocate an array to hold the k closest fruits found to the fruit we're classifying.
   Fruit[] closestFruit = new Fruit[k];
   
   /*
   		Variable used to hold the distance of the fruit that is the farthest away but *still* in the closest fruit array.
   		This variable is used to determine when a new fruit is close enough to be considered by the k-nn algorithm.
   */
   float maxDistance = 0;
   float distance;
   float newMaxDistance = 0;
   for(int i = 0; i < trainingSet.size(); i++){
     distance = distance(fruit, trainingSet.get(i));
     
     /*
     	For i < k, ensures the fruit is added to the closestFruit array (because we have seen less than k fruit, there is room to fill).
     	It also updates the distance of the fruit that is farthest away from the training fruit but still in the array
     */
     if(i == 0){
       maxDistance = distance;
       closestFruit[i] = trainingSet.get(i);
     }else if(i < k){
       closestFruit[i] = trainingSet.get(i);
       maxDistance = max(distance, maxDistance);
     }else{
       /*
       		For i > k, the closestFruit array is full, and we have to determine if the current fruit is close enough to be considered by the k-nn algorithm.
       		This occurs when distance< maxDistance (in other words, it is closer than the farthest fruit in the closestFruit array)
       */
       if(distance < maxDistance){
         /*
         	Current fruit has been determined to be closer than the farthest fruit.
         	Replace the farthest fruit with current fruit and update the maxDistance to the new farthest fruit.
         */
         
         for(int j = 0; j < closestFruit.length; j++){
            /*
            	For j == 0, initialize the value of newMaxDistance to the distance to the current fruit.
            	For j > 0, set it to the max of the running max distance and the distance to the current fruit.
            */
           if(j == 0){
            	newMaxDistance = distance(closestFruit[j], fruit);
           }else{
            	newMaxDistance = max(newMaxDistance, distance(closestFruit[j], fruit));
           }
           if(distance(fruit, closestFruit[j]) == maxDistance){
               //We've found the farthest fruit. Replace it with the current fruit.
             closestFruit[j] = trainingSet.get(i);
           }
     	 }
     		maxDistance = newMaxDistance;
   		}
     
     }
   }
  
   
  /*
  	We've found the k closest fruits.
  	Now we have to determine the most common fruitID among them.
  */
  	
  	//A Pair is an (x, y) combination. x will represent a fruitID and y will represent the number of times it has been found.
  	//We are trying to find the mode of the collection of fruitID's
  	ArrayList<Pair> counts = new ArrayList<Pair>();
  	int fruitID;
  	Pair found = null;
  
  	/*
  		Run through each fruit in the closestFruit array and keep a count of how often each fruitID is found.
  		Store this information in an (x, y) pair where x is the fruitID and y is the number of occurrences.
  	*/
	for(int i = 0; i < closestFruit.length; i++){
		fruitID = closestFruit[i].fruitID;
		for(int j = 0; j < counts.size(); j++){
			if(counts.get(j).x == fruitID){
    			found = counts.get(j);
			}
		}
		if(found == null){
			counts.add(new Pair(fruitID, 1));
		}else{
			found.y++;
		}
	}

	/*
		maxPair holds the Pair with the highest y value seen so far.
	*/
	Pair maxPair = null;
	for(int i = 0; i < counts.size(); i++){
		if(i == 0){
			maxPair = counts.get(i);
		}else{
			if(counts.get(i).y > maxPair.y){
    			maxPair = counts.get(i);
			}
		}
	}

	fruit.guessedFruitID = (int)maxPair.x;
}



void draw(){
  //Draw a circle centered at (height, width) for each fruit in the training set
  float[] coords;
  for(int i = 0; i < trainingSet.size(); i++){
    fill(colors[trainingSet.get(i).fruitID - 1]);
   	coords = ChangeOfCoordinates(trainingSet.get(i).width, trainingSet.get(i).height);
    ellipse(coords[0], coords[1], 10, 10);
 
  }

	//Draw test data as a square to visually distinguish from training data.
  for(int i = 0; i < testSet.size(); i++){
    fill(colors[testSet.get(i).guessedFruitID - 1]);
    coords = ChangeOfCoordinates(testSet.get(i).width, testSet.get(i).height);
    rect(coords[0], coords[1], 10, 10);
  }
}



/*
	Takes in the width and height of a fruit and returns a float array with the coordinates to draw it.
	The x coordinate is located at index 0, and the y coordinate is located at index 1.
	This is used so that the output takes up a larger portion of the screen and is more easily visible.
*/
float[] ChangeOfCoordinates(float x, float y){
	float maxHeight = 11;
	float minHeight = 3;
	float maxWidth = 11;
	float minWidth = 4;

	/*
		Adjusts coordinate system so that the edge of the windows represent maxHeight, minHeight, maxWidth, and minWidth.
	*/
	float xOut = (x - minWidth)*(700/(maxWidth-minWidth));
	float yOut = (y - minHeight)*(700/(maxHeight-minHeight));
	float[] out = new float[2];
	out[0] = xOut;
	out[1] = yOut;
	return out;



}