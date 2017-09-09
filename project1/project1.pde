import java.util.ArrayList;
import java.math.*;
ArrayList<TestFruit> testSet;
ArrayList<Fruit> trainingSet;
Table dataset;
int rowCount;
final int k = 1;

void setup(){
  dataset = new Table("fruit_data_with_colors.txt");
  trainingSet = new ArrayList<Fruit>();
  testSet = new ArrayList<TestFruit>();
  rowCount = dataset.getRowCount();
  int fruitID;
  float height;
  float weight;
  for(int i = 1; i < rowCount; i++){
    fruitID = dataset.getInt(i, 0);
    height = dataset.getFloat(i, 4);
    weight = dataset.getFloat(i, 5);
    if(i % 4 == 0){
      testSet.add(new TestFruit(fruitID, height, weight));
    }else{
      trainingSet.add(new Fruit(fruitID, height, weight));
    }
  }
  
  for(int i = 0; i < testSet.size(); i++){
    classify(testSet.get(i), k);
  }
  
  int correct = 0;
  int wrong = 0;
  TestFruit currentFruit;
  for(int i = 0; i < testSet.size(); i++){
    currentFruit = testSet.get(i);
    if(currentFruit.FruitID == currentFruit.guessedFruitID){
      correct++;
    }else{
       wrong++;
    }
  }
  print("Correct:\t" + correct + "\n");
  print("Wrong:\t" + wrong + "\n");
  
  
  size(700, 700);
  
}


/*
  Takes fruit as input and changes its guessedFruitID value to
   the value predicted using the k-nearest neighbors algorithm.
*/

float distance(Fruit fruitOne, Fruit fruitTwo){
  float dHeight;
  float dWeight;
  dHeight = fruitOne.height - fruitTwo.height;
  dWeight = fruitOne.weight - fruitTwo.weight;
  
  return (float)Math.sqrt(dHeight*dHeight + dWeight*dWeight);
}


/*
  Given two numbers, determines the smallest.
float min(float x, float y){
  if(x < y){
    return x;
  }else{
    return y;
  }
}*/

void classify(TestFruit fruit, int k){
   Fruit[] closestFruit = new Fruit[k];
   float minDistance = 0;
   float distance;
   for(int i = 0; i < trainingSet.size(); i++){
     distance = distance(fruit, trainingSet.get(i));
     if(i == 0){
       minDistance = distance;
       closestFruit[i] = trainingSet.get(i);
     }else if(i < k){
       closestFruit[i] = trainingSet.get(i);
       minDistance = min(distance, minDistance);
     }else{
       if(distance < minDistance){
         for(int j = 0; j < closestFruit.length; j++){
           if(distance(fruit, closestFruit[j]) == minDistance){
             closestFruit[j] = trainingSet.get(i);
             minDistance = distance;
           }//End innermost if
         }//End inner for (counter: j)
       }//End inner if
     }//End Else
   }//End For
   
  int[] fruitCount = new int[4];
  for(int i = 0; i < 4; i++){
    fruitCount[i] = 0;
  }
  for(int i = 0; i < closestFruit.length; i++){
    fruitCount[closestFruit[i].fruitID - 1]++;
  }
  
  int max = 0;
  int indexOfMax = 0;
  for(int i = 1; i < fruitCount.length; i++){
    if(fruitCount[i] > max){
      indexOfMax = i;
      max = fruitCount[i];
    }
  }
  
  fruit.guessedFruitID = max - 1;

}



void draw(){

  for(int i = 0; i < trainingSet.size(); i++){
    ellipse(trainingSet.get(i).height*50, trainingSet.get(i).weight*50, 5, 5);
  }


}