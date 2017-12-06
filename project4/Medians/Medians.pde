import java.util.ArrayList;
import java.util.Random;
import java.awt.Color;
import java.util.Arrays;

ArrayList<Node> nodes;
ArrayList<Centroid> centroids;
int numberOfCentroids;
ArrayList<Color> colors;
int dimensions;

void setup(){
	Table t = new Table("locations.tsv");
	int n = t.getRowCount();
	nodes = new ArrayList<Node>();
	Node node;
	dimensions = 2;
	numberOfCentroids = 3;
	for(int i = 0; i < n; i++){
    	node = new Node(dimensions);
		for(int j = 0; j < dimensions; j++){
			node.data[j] = t.getFloat(i, j + 1);
		}
		nodes.add(node);
	}

	float max = 0;
	float min = 0;
	float[] maxValues = new float[dimensions];
	float[] minValues = new float[dimensions];

	for(int i = 0; i < dimensions; i++){
		for(int j = 0; j < nodes.size(); j++){
    		if(j == 0){
				max = nodes.get(0).data[i];
				min = nodes.get(0).data[i];
			}else{
    			max = maxf(max, nodes.get(j).data[i]);
    			min = minf(min, nodes.get(j).data[i]);
			}
		}
		maxValues[i] = max;
		minValues[i] = min;
	}


	centroids = new ArrayList<Centroid>();
	for(int i = 0; i < numberOfCentroids; i++){
		centroids.add(generateRandomCentroid(dimensions, minValues, maxValues));
	}

	for(int i = 0; i < nodes.size(); i++){
		updateAssociatedCentroid(nodes.get(i), centroids);
	}
	
	Random rnd = new Random();
	colors = new ArrayList<Color>();
	for(int i = 0; i < numberOfCentroids; i++){
		colors.add(new Color(rnd.nextInt(255), rnd.nextInt(255), rnd.nextInt(255)));
	}
	
	
	
	size(750, 750);



    
}


public float distance(Node n, Centroid c){
	float sum = 0;
	for(int i = 0; i < n.dimensions; i++){
		sum += (n.data[i] - c.data[i])*(n.data[i] - c.data[i]);
	}
	return sum;
}
public Centroid updateAssociatedCentroid(Node n, ArrayList<Centroid> centroids){
	float minDistance = distance(n, centroids.get(0));
	n.associatedCentroid = centroids.get(0);
	for(int i = 1; i < centroids.size(); i++){
    	if(distance(n, centroids.get(i)) < minDistance){
    		minDistance = distance(n, centroids.get(i));
    		n.associatedCentroid = centroids.get(i);
    	}
	}
	return n.associatedCentroid;
}

public float maxf(float a, float b){
	return a > b ? a : b;
}

public float minf(float a, float b){
	return a > b ? b : a;
}

public Centroid generateRandomCentroid(int dimensions, float[] minValues, float[] maxValues){
	Random rnd = new Random();
	Centroid retCentroid = new Centroid(dimensions);
	for(int i = 0; i < dimensions; i++){
		retCentroid.data[i] = rnd.nextFloat()*(maxValues[i] - minValues[i]) + minValues[i];
	}
	return retCentroid;

}
void draw(){
    clear();
    Color col;
    Centroid c;
    Node n;
    for(int i = 0; i < centroids.size(); i++){
        c = centroids.get(i);
        col = colors.get(i);
    	fill(col.getRed(), col.getBlue(), col.getGreen());
    	rect(c.data[0], c.data[1], 15, 15);
    }
    
    for(int i = 0; i < centroids.size(); i++){
    	for(int j = 0; j < nodes.size(); j++){
    		if(nodes.get(j).associatedCentroid == centroids.get(i)){
        		n = nodes.get(j);
        		col = colors.get(i);
        		fill(col.getRed(), col.getBlue(), col.getGreen());
        		rect(n.data[0], n.data[1], 10, 10);
    		}
    	}
    }
    if(frameCount % 150 == 0){

		ArrayList<Node> data  = new ArrayList<Node>();
		float[] data2;
        for(int i = 0; i < centroids.size(); i++){
            for(int j = 0; j < dimensions; j++){
                //find median
                data = new ArrayList<Node>();
            	for(int k = 0; k < nodes.size(); k++){
            		
            		if(nodes.get(k).associatedCentroid == centroids.get(i)){
            			data.add(nodes.get(k));
            		}
            		
            	}
            	data2 = new float[data.size()];
            	for(int k = 0; k < data.size(); k++){
            		data2[k] = data.get(k).data[j];
            	}
            	Arrays.sort(data2);
            	centroids.get(i).data[j] = data2[data2.length/2];
            	
            }
    	}
    
    	for(int i = 0; i < nodes.size(); i++){
    		updateAssociatedCentroid(nodes.get(i), centroids);
    	}
    }

}



void mousePressed(){
    Random rnd = new Random();
    colors.clear();
	for(int i = 0; i < numberOfCentroids; i++){
        colors.add(new Color(rnd.nextInt(255), rnd.nextInt(255), rnd.nextInt(255)));
    }
}