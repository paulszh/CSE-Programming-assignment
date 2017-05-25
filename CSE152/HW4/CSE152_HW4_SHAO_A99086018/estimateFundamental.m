% This function takes in two sets of points p1 and p2 and calculating the
% fundamental matrix using the DLT algorith
function [F] = estimateFundamental(p1, p2)
    % calculating normalization matrix for p1 and p2 
N1 = dataTransformMatrix(p1);
N2 = dataTransformMatrix(p2);

%p1n and p2n are sets of normalized homogenous points
%orig_p1n and orig_p2n are sets of unnormalized homogenous points
p1n = zeros(3,13);
p2n = zeros(3,13);

for i = 1 : 13
    p1n(:,i) = N1 * p1(:,i); 
    p2n(:,i) = N2 * p2(:,i);
end

disp(p1n);

x1 = p1n(1,:)';
y1 = p1n(2,:)';
z1 = p1n(3,:)';

x2 = p2n(1,:)';
y2 = p2n(2,:)';
z2 = p2n(3,:)';

%Now constructing a 13 * 9 matrix
A = [x1.* x2 y1.*x2 z1.*x2 x1.*y2 y1.*y2 z1.*y2 x1.*z2 y1.*z2 z1.*z2];

%Need to calculate f so that Af = 0, perform svd on A
[U1,S1,V1] = svd(A); 
%V is a 9 * 9 matrix, need to reshape the last column of V into 3*3 matrix
% disp(V(:,9));
f = reshape(V1(:,9),3,3)';
%perform svd on reshape_V
[U2,S2,V2] = svd(f);
%s2 is a 3 * 3, set its last row to 0, so that our f only has rank 2 
S2(3,3) = 0;
f = U2* S2 *V2';

F = N2' * f * N1; %denormalization
end