public class Node{
	
    public int dimensions;
    public float[] data;
    public Centroid associatedCentroid;
    
    public Node (int dimensions){
    	this.dimensions = dimensions;
    	this.data = new float[dimensions];
    }
    
}