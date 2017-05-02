Problem_1.m file

This matlab file reads the image 'cleese.jpg' and resizes it to size 256 * 256. It 
will generate an 512 * 512 result image named 'modified_cleese.png'.The green, red 
and blue channels of the original 'cleese.jpg' will be extracted and put at the top 
right, bottom left and bottom right corners in the 'modified_cleese.png'. The 
resized original image will be put on the top left corner as well.


Problem_2.m file

This matlab file calls the function rotate_img 4 times. At each time, it 
passes a source image as well as a rotating angle . 

rotate_img.m

Inside this file, the function 'rotate_img' is defined. It will rotate the input
image based on the input rotation angle value. A rotated image will be returned at 
the end. 