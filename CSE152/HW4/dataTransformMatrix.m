function [N] = dataTransformMatrix(points)
    AX = mean(points(1,:));
 
    AY = mean(points(2,:));
    VX = var(points(1,:));
    VY = var(points(2,:));
    V = sqrt(VX + VY);
    %TODO: check if V is calculated correctly
    S = sqrt(2)/(V);
    disp(S);
    N = [S, 0, -AX*S; 0, S, -AY*S; 0, 0, 1];
    
end