function [aligned_image] = image_alignment(image)


    [h,w] = size(image);
    image = imcomplement(image);
    x_avg = double((moment(image,1,0,1))/(moment(image,0,0,1)));
    y_avg = double((moment(image,0,1,1))/(moment(image,0,0,1)));
    
    A = [central_moment(image,2,0,1), central_moment(image,1,1,1);...
    central_moment(image,1,1,1), central_moment(image,0,2,1)];

    [V,D] = eig(A);
    H = [1,0]';
%     scale
    V = V * 50;
 
    if(D(1,1) >  D(2,2))   
        nv = norm(V(:,1));
        t = acos(dot(H,V(:,1)/nv))
        vec1 = V(:,1);
        vec2 = V(:,2);
    else
        nv = norm(V(:,2));
        t = acos(dot(H,V(:,2)/nv))
        vec1 = V(:,2);
        vec2 = V(:,1);
    end
    
    new_image = false(h,w);
    T = [x_avg,y_avg]';
    R = [cos(t),-sin(t); sin(t),cos(t)];
%     rotate the eigenvectors
    vec1 = R * vec1;
    vec2 = R * vec2;
    
    
%     Mapping the old points to new image
    for x = 1 : h 
        for y = 1 : w
            new_P = R * [x-x_avg,y-y_avg]' + T;
            if(new_P(1) > 1 && new_P(2) > 1 && new_P(1) < h && new_P(2) < w)
                new_image(floor(new_P(1)),ceil(new_P(2))) = image(x,y);
                new_image(floor(new_P(1)),floor(new_P(2))) = image(x,y);
                new_image(ceil(new_P(1)),floor(new_P(2))) = image(x,y);
                new_image(ceil(new_P(1)),ceil(new_P(2))) = image(x,y);
            end
        end
    end
    figure,imshow(new_image);
    hold on;
    plot(y_avg,x_avg, 'r.'); 
    hold on;
    quiver(y_avg,x_avg,vec1(1),vec1(2),'b.','LineWidth',2.5);
    hold on 
    quiver(y_avg,x_avg,vec2(1),vec2(2),'r.','LineWidth',2.5);
    hold off
    aligned_image = new_image;

end