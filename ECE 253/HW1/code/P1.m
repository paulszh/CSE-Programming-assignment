% i
A =[3, 9, 5, 1; 4, 25, 4, 3; 63, 12, 23, 9; 6, 32, 77, 0; 12, 8, 5, 1];
B =[0, 1, 0, 1; 0, 1, 1, 1; 0, 0, 0, 1; 1, 1, 0, 1; 0, 1, 0, 0];
C = A.*B;
% ii
innerPdt = C(2,:) * C(5,:)';

% iii

[minX, minY] = find(C == min(C(:)));
[maxX, maxY] = find(C == max(C(:)));
maxC = max(C(:));
minC = min(C(:));


