Project 4 implements the k-mediods algorithm and the k-medians algorithm to create clusters of the data in locations.tsv.

The k-medians algorithm generates each cluster and assigns a centroid based on the median of each data point in the cluster. After assigning centroids, it reassigns points to each cluster based on the closest centroid. 

The k-mediods algorithm assigns a random node to be the mediod of each cluster.It then swaps non-mediod nodes with mediod nodes, calculates the sum of squares error, and keeps the swap if it results in a lower error.

The k-mediods algorithm is implemented in mediods.pde. The k-medians algorithm is implemented in medians.pde. Both algorithms are designed to handle an arbitrary number of dimensions, but they will only graph the first two. If the random colors generated for each cluster are hard to see, clicking the visualization will generate new colors.
