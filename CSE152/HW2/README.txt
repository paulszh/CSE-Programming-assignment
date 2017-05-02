img_formation.m 

This matlab file calculating the four vertices and plot using the supplied plotsquare.m function. 

It generates 4 plots in total with 4 different camera settings. 


img_render.m

This matlab file first reads both the albedo and uniform_albedo maps from the provided "facedata.mat" and then plot them in 2D. 

Then, it reads the heightmap data and combined the heighmap and the albedo to display the entire face in 3D. 

Next, it calcualtes the normalized surface normal vectors and displays them using the quiver3 

The final step is to render the resulting images using the general image fomation equation. 