# CSE 166: Image Processing, Fall 2016 – Assignment 2

##Textbook problems
###Problem 3.1
**Give a single intensity transformation function for spreading the intensities of an image so the lowest intensity is 0 and the highest is L - 1.**

    
Assume the original image is **f** with intensity spread from [f_min, f_max] and we also have a output image **g**. 
\\[
    g = \frac{f - f_\min}{f_\max - f_\min} * (L - 1)
\\]    

In the above equation, both f_min and f_max are both constants for a given image, and here the assumption is f_max is always large than f_min. Therefore, the fraction will always less or equal than 1 and all the pixels in g will resides in the range [0,L-1]. 

###Problem 3.5
1. **What effect would setting to zero the lower-order bit planes have on the histogram of an image in general?**

    The picture will have less contrast, because the number of pixels have different intensity values will decrease. Assume we zero the least 2 significant bits, and then, for example, 11001010(202 in decimal) and 11001010 and 11001000 will be reduced to 11001000(200 in decmial). Since the number of total pixels in the image remains the same, the frequency of some pixel intensities in the histogram tends to increase, which finally reduce the contrast. 

2. **What would be the effect on the histogram if we set to zero the higher-order bit planes instead?**
    The original image will become dark since setting the highest i bit plane to zero will reduce the gray levels from 2^8 to 2^8-i. The pixel value which is less than 2^8-i - 1 , will remain the same while the intensity value greater than 2^8-i - 1 will all be clipped to 2^8-i - 1.

###Problem 3.7
**Suppose that a digital image is subjected to histogram equalization. Show that second pass of histogram equalization (on the histogram-equalized image) will produce exactly the same result as the first pass.**


The second histogram equalization will generate the same image as the one produced by the first histogram equalization. 

Let n denotes the number of total pixels in the original image and $n_k$ represents the pixel with gray level $r_k$. 

Then, we have a PDF function:

*Note: n_k refers to the number of pixels with gray level k*
\\[Pr(n_k) = \frac{n_k}{n}\\] \\[ k = 0, 1, 2...... (L-1)\\] 

And a CDF function 
Note: s_k refers to the number of pixels in modified image with gray level k

\\[s_k = Round[(L-1)\sum_{r=0}^{k}Pr(n_k)]= Round[{\frac{L-1}{n}\sum_{r=0}^{k}n_k]} \\]

Since every pixel with gray level k in the original image is mapped to the $s_k$ in the enhanced image. 

### Problem 3.10
**(a)Show that the discrete transformation function given in Eq. (3.3-8) for histogram equalization satisfies conditions (a) and (b) in Section 3.3.1.
(b)Show that the inverse discrete transformation in Eq. (3.3-9) satisfies conditions (a') and (b) in Section 3.3.1 only if none of the intensity levels $r_k$, k = 0, 1, ... , L - 1, are missing.**
a)
Because $p_r$($r_j$)is positive, so for the summation, T($r_k$), will monotonically increase. Also, the sum of all $p_r$($r_j$) equals to 1, which means the $s_k$ $\in$ (0, L-1).
b)
Because only if 


### Problem 3.16
**(a) Suppose that you filter an image, f(x, y), with a spatial filter mask, w(x, y), using convolution, as defined in Eq. (3.4-2), where the mask is smaller than the image in both spatial directions. Show the important property that, if the coefficients of the mask sum to zero, then the sum of all the elements in the resulting convolution array (filtered image) will be zero also (you may ig- nore computational inaccuracies). Also, you may assume that the border of the image has been padded with the appropriate number of zeros.(b) Would the result to (a) be the same if the filtering is implemented using correlation, as defined in Eq. (3.4-1)?**
### Problem 3.21
**The three images shown were blurred using square averaging masks of sizes n = 23, 25, and 45, respectively. The vertical bars on the left lower part of (a) and (c) are blurred, but a clear separation exists between them. However, the bars have merged in image (b), in spite of the fact that the mask that produced this image is significantly smaller than the mask that produced image (c). Ex- plain the reason for this.**
### Problem 3.23
**In a given application an averaging mask is applied to input images to reduce noise, and then a Laplacian mask is applied to enhance small details. Would the result be the same if the order of these operations were reversed?**






