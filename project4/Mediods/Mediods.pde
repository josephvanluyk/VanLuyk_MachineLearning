import java.util.ArrayList;
import java.util.Random;
import java.awt.Color;
import java.util.Arrays;

ArrayList<Node> nodes;
ArrayList<Color> colors;
int dimensions;
ArrayList<Cluster> clusters;
int numberOfClusters;
boolean redraw;
void setup(){
    redraw = false;
    Random rnd = new Random();
	Table t = new Table("locations.tsv");
	int n = t.getRowCount();
	nodes = new ArrayList<Node>();
	Node node;
	dimensions = 2;
	numberOfClusters = 3;
	for(int i = 0; i < n; i++){
    	node = new Node(dimensions);
		for(int j = 0; j < dimensions; j++){
			node.data[j] = t.getFloat(i, j + 1);
		}
		nodes.add(node);
	}
	
	clusters = new ArrayList<Cluster>();
	for(int i = 0; i < numberOfClusters; i++){
		int j = rnd.nextInt(nodes.size());
		if(nodes.get(j).isAMediod){
			i--;
		}else{
    		nodes.get(j).isAMediod = true;
    		clusters.add(new Cluster(nodes.get(j)));	
		}
	}

	for(int i = 0; i < nodes.size(); i++){
    	if(!nodes.get(i).isAMediod){
			classifyNode(nodes.get(i), clusters);
    	}
	}

	

	colors = new ArrayList<Color>();
	for(int i = 0; i < numberOfClusters; i++){
		colors.add(new Color(rnd.nextInt(255), rnd.nextInt(255), rnd.nextInt(255)));
	}
	
	
	
	size(750, 750);



    
}


public void classifyNode(Node node, ArrayList<Cluster> clusters){
	float min = 0;
	int index = 0;
	float dist;
    for(int j = 0; j < clusters.size(); j++){
        if(j == 0){
            min = distance(node, clusters.get(j).mediod);
            index = j;
        }else{
            dist = distance(node, clusters.get(j).mediod);
            if(dist < min){
                min = dist;
                index = j;
            }
        }
    }
    clusters.get(index).nodes.add(node);
}

public float distance(Node n, Node c){
	float sum = 0;
	for(int i = 0; i < n.dimensions; i++){
		sum += (n.data[i] - c.data[i])*(n.data[i] - c.data[i]);
	}
	return sum;
}

void draw(){
    Node n;
    if(frameCount % 300 == 1 || frameCount == 0 || redraw){
        redraw = false;
        clear();
        Color c;
        Cluster cluster;
    	for(int i = 0; i < clusters.size(); i++){
    		c = colors.get(i);
    		cluster = clusters.get(i);
    		fill(c.getRed(), c.getBlue(), c.getGreen());
    		rect(cluster.mediod.data[0], cluster.mediod.data[1], 20, 20);
    		for(int j = 0; j < cluster.nodes.size(); j++){
    			n = cluster.nodes.get(j);
    
    			if(n.data[0] == cluster.mediod.data[0] &&  n.data[1] == cluster.mediod.data[1]){
        			System.out.println(n.isAMediod);
    			}
    			rect(n.data[0], n.data[1], 10, 10);
    		}
    	}
    }
	
	if(frameCount % 300 == 0){
		float SSE = 0;
		float tempSSE = 0;
		Node oldMediod;
		for(int i = 0; i < clusters.size(); i++){
    		SSE += clusters.get(i).calculateSSE();
		}
		for(int i = 0; i < clusters.size(); i++){
    		for(int j = 0; j < nodes.size(); j++){
    			if(!nodes.get(j).isAMediod){
        			tempSSE = 0;
        			oldMediod = clusters.get(i).mediod;
        			n = nodes.get(j);
        			oldMediod.isAMediod = false;
        			n.isAMediod = true;
        			clusters.get(i).mediod = n;
        			
        			//Readjust clusters
        			for(int k = 0; k < clusters.size(); k++){
            			clusters.get(k).nodes.clear();
        			}
        			for(int k = 0; k < nodes.size(); k++){
        				if(!nodes.get(k).isAMediod){
        					classifyNode(nodes.get(k), clusters);
    					}
        			}
        			for(int k = 0; k < clusters.size(); k++){
            			tempSSE += clusters.get(k).calculateSSE();
        			}
        			if(tempSSE < SSE){
            			SSE = tempSSE;
        			}else{
            			clusters.get(i).mediod.isAMediod = false;
            			clusters.get(i).mediod = oldMediod;
            			oldMediod.isAMediod = true;
            			for(int k = 0; k < clusters.size(); k++){
                			clusters.get(k).nodes.clear();
            			}
            			for(int k = 0; k < nodes.size(); k++){
                			if(!nodes.get(k).isAMediod){
                    			classifyNode(nodes.get(k), clusters);
                			}
            			}
        			}
        		}	
        	}
    	}  
	}		
}


void mousePressed(){
    redraw = true;
    Random rnd = new Random();
    colors.clear();
	for(int i = 0; i < numberOfClusters; i++){
        colors.add(new Color(rnd.nextInt(255), rnd.nextInt(255), rnd.nextInt(255)));
    }
}