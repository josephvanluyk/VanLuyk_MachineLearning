public class Node{
	
    public int dimensions;
    public float[] data;
    public boolean isAMediod;
    public Node (int dimensions){
    	this.dimensions = dimensions;
    	this.data = new float[dimensions];
    	isAMediod = false;
    }
    
    
}