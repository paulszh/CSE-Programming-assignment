function [] = plot_eigenvectors(input,flip,rgb)
    if(rgb == 1)
        image = rgb2gray(input);
    else
        image = input;
    end
    image = binarization_otus(image);

    if(flip == 1)
        image = imcomplement(image);
    end

% Calculating the centriods
    x_avg = double((moment(image,1,0,1))/(moment(image,0,0,1)));
    y_avg = double((moment(image,0,1,1))/(moment(image,0,0,1)));
    
    A = [central_moment(image,2,0,1), central_moment(image,1,1,1);...
    central_moment(image,1,1,1), central_moment(image,0,2,1)];

    [V,D] = eig(A);
% scale the eigenvectors to make it visibe 
    V = V * 50; 
    figure,imshow(image);
    hold on;
    plot(y_avg,x_avg, 'r.');  
%     plot the eigenvectors with larger eigenvalue with blue error
    if(D(1,1) >  D(2,2))         
         hold on; 
         quiver(y_avg,x_avg,V(1,1),V(2,1),'b.','LineWidth',2.5);
         hold on;
         quiver(y_avg,x_avg,V(1,2),V(2,2),'r.','LineWidth',2.5);
    else
        hold on 
        quiver(y_avg,x_avg,V(1,2),V(2,2),'b.','LineWidth',2.5);
        hold on
        quiver(y_avg,x_avg,V(1,1),V(2,1),'r.','LineWidth',2.5);
    end
    hold off
    
end