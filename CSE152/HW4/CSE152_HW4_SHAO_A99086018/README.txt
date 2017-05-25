Problem2.m

A matlab file that find the Sparse Stereo Correspondences by evaluating the NSSD. It perform the feature matching using two blurred image with sigma value 5. 


NSSD.m 

A matlab function that calucate and return the NSSD of two 9 * 9 image patches.

main. m 

A matlab file that evoke a bunch of other matlab help functions wrote for this assignment

gussian_smooth.m 

A matlab function which takes in a image and blurs it using gussian filter. The level of blurring is affected by the value of sigma

estimateFundamental.m 

A matlab function that takes in two set of points in two different images and return a calculated fundamental matrix. 

dataTransformMatrix.m 

A matlab function that normalized the a set of homogenous points during the fudemental matrix calculation. 

corner_detection.m 

A matlab function that detects and plots top n corners given the x,y gradients, blurred image and corner numbers. 

check_neighbor.m 

A matlab function that compare it's current lamda value with all its neighbor. It returns 1 if the lamda value of current position is the local maximum. Otherwise, it returns false. 

calculate_gradient.m 

A matlab function that calculate both x and y gradients. 