x_1 = [-1;-0.5;2;1];
x_2 = [1;-0.5;2;1];
x_3 = [1;0.5;2;1];
x_4 = [-1;0.5;2;1];


X = [x_1, x_2, x_3, x_4];
Z = [0,0,0];

%No rigid body transformation
R1 = [1,0,0;0,1,0;0,0,1];
T1 = [0;0;0];
F = 1; %focal length
K1 = [F,0,0,;0,F,0,;0,0,1];
E1 = [R1,T1]; %extrinsic matrix

result = K1 * E1 * X;
plotsquare(result);

%Translation 
R2 = [1,0,0;0,1,0;0,0,1];
T2 = [0;0;2];
K2 = K1;
E2 = [R2,T2]; %extrinsic matrix
result = K2 * E2 * X;
figure,plotsquare(result);

%Translation and rotation
z_angle = pi/3;
Rz = [cos(z_angle),-sin(z_angle),0;
    sin(z_angle),cos(z_angle),0; 
    0, 0, 1];
x_angle = pi/4;
Rx = [1,0,0;
    0,cos(x_angle),-sin(x_angle); 
    0, sin(x_angle),cos(x_angle)];
R3 = Rx * Rz;
T3 = [0;0;2];
E3 = [R3,T3]; %extrinsic matrix
K3 = K1;
result = K3 * E3 * X;
figure,plotsquare(result);

%Translation and rotation, long distance
T4 = [0;0;15];
R4 = R3;
E4 = [R4,T4]; %extrinsic matrix, R is the same as the part(3)
F = 5;
K4 = [F,0,0;0,F,0;0,0,1]; %modify the camera matrix
result = K4 * E4 * X;
figure,plotsquare(result);


