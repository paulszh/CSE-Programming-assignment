%This function calculuates the overlap between two boxes
function [rate] = overlap_rate( x11,x12,y11,y12,x21,x22,y21,y22 )

xv_1 = [x11 x12 x12 x11];
yv_1 = [y11 y11 y12 y12];
xv_2 = [x21 x22 x22 x21];
yv_2 = [y21 y21 y22 y22];

min_x = round(min(x11,x21));
min_y = round(min(y11,y21));
max_x = round(max(x12,x22));
max_y = round(max(y12,y22));

xq1 = repmat(min_x:max_x,max_y-min_y+1, 1);
xq2 = repmat(min_y:max_y,max_x-min_x+1, 1);
xq1 = xq1(:);
xq2 = xq2(:);

area1 = inpolygon(xq1,xq2,xv_1,yv_1);
area2 = inpolygon(xq1,xq2,xv_2,yv_2);
overlap = area1+area2;
rate = sum(overlap==2)/sum(overlap>0);
end

