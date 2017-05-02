%3.1 albedo 
albedo = load('facedata.mat','albedo');
imagesc(albedo.albedo);

%3.1 uniform_albedo
uniform_albedo = load('facedata.mat','uniform_albedo');
figure,imagesc(uniform_albedo.uniform_albedo);

heightmap = load('facedata.mat','heightmap');
%3.2 albedo 
figure,surf(heightmap.heightmap,albedo.albedo, 'EdgeColor','none');

%3.2 uniform_albedo
figure,surf(heightmap.heightmap,uniform_albedo.uniform_albedo,'EdgeColor','none');

%3.3 surface normal
f= heightmap.heightmap;

dfdx = zeros(188,126);
dfdy = zeros(188,126);
one = ones(188,126);
I1 = zeros(188,126);
I2 = zeros(188,126);
I = zeros(188,126);
UI1 = zeros(188,126);
UI2 = zeros(188,126);
UI = zeros(188,126);

%calculating the surface normal
for x = 2 : 187
    for y = 2 : 125   
        tx = -(f(x+1,y) - f(x-1,y))/2;
        ty = -(f(x,y+1) - f(x,y-1))/2;
        dfdx(x,y) = tx/sqrt(tx^2 + ty^2 + 1);
        dfdy(x,y) = ty/sqrt(tx^2 + ty^2 + 1);
        one(x,y) = 1/sqrt(tx^2 + ty^2 + 1);
    end
end

figure
quiver3(f,dfdx,dfdy,one);

%3.4 rendering images
lightsource = load('facedata.mat','lightsource');%load the light source
s1 = lightsource.lightsource(1,1:3);
s2 = lightsource.lightsource(2,1:3);
abd = albedo.albedo;
uni_abd = uniform_albedo.uniform_albedo;

for x = 1 : 188
    for y = 1 :126
        v = [dfdx(x,y),dfdy(x,y),one(x,y)]';
        a = abd(x,y);
        uni_a = uni_abd(x,y);
        %calculating the distance
        dist1 = (s1(1) - x)^2 + ... 
            (s1(2) - y)^2 + ...
            (s1(3) - f(x,y))^2;
        dist2 = (s2(1) - x)^2 + ... 
            (s2(2) - y)^2 + ...
            (s2(3) - f(x,y))^2;
        light1(1) = s1(1)-x;
        light1(2) = s1(2)-y;
        light1(3) = s1(3) - f(x,y);
        light1 = light1/norm(light1); %normalize the light direction
        
        light2(1) = s2(1)-x;
        light2(2) = s2(2)-y;
        light2(3) = s2(3)-f(x,y);
        light2 = light2/norm(light2); %normalize the light direction
        
        
        temp1 = light1 * v; 
        temp2 = light2 * v;
        
        %if the dot product of normal and light direction is 
        % less than zero, set it to zero
        if(light1 * v < 0)
            temp1 = 0;
        end
        if(light2 * v < 0)
            temp2 = 0;
        end
        
        %Pixel intensity value: albedo
        I1(x,y) = (temp1 * a)/dist1;   
        I2(x,y) = (temp2 * a)/dist2; 
        I(x,y) = I1(x,y) + I2(x,y);
        
        %Pixel intensity value: uniform albedo
        UI1(x,y) = (temp1 * uni_a)/dist1; 
        UI2(x,y) = (temp2 * uni_a)/dist2;
        UI(x,y) = UI1(x,y) + UI2(x,y);
    end
end


%plot all the images
%regular albedo on the first row
%uniform albedo on the second row
figure
subplot(2,3,1); 
imagesc(I)
title('albedo: combined Light');
subplot(2,3,2)
imagesc(I1)
title('albedo: Light1');
subplot(2,3,3)
imagesc(I2)
title('albedo: Light2');

subplot(2,3,4); 
imagesc(UI)
title('uniform albedo: combined Light');
subplot(2,3,5)
imagesc(UI1)
title('uniform albedo: Light1');
subplot(2,3,6)
imagesc(UI2)
title('uniform albedo: Light2');
colormap gray;




