public class Cluster{
 	public Node mediod;
 	public ArrayList<Node> nodes;
    
    
    public Cluster(Node n){
 		this.mediod = n;
 		nodes = new ArrayList<Node>();
 	}
 
 	public float calculateSSE(){
 		float sum = 0;
 		Node n;
 		for(int i = 0; i < nodes.size(); i++){
 			for(int j = 0; j < mediod.dimensions; j++){
 				n = nodes.get(i);
 				sum += (n.data[j] - mediod.data[j])*(n.data[j] - mediod.data[j]);
 			}	
 		}
 		return sum;
 	}
 
}