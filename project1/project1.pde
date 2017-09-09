import java.util.*;

ArrayList<Fruit> testSet;
ArrayList<Fruit> trainingSet;
Table dataset;
int rowCount;

void setup(){
  dataset = new Table("fruit_data_with_colors.txt");
  trainingSet = new ArrayList<Fruit>();
  testSet = new ArrayList<Fruit>();
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
  
  
  size(700, 700);
  
}



void draw(){

  for(int i = 0; i < trainingSet.size(); i++){
    ellipse(trainingSet.get(i).height*50, trainingSet.get(i).weight*50, 5, 5);
  }


}