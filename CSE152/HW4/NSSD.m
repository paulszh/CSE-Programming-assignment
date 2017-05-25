function [square_sum] = NSSD(m1,m2,n)
    sum1 = 0;
    sum2 = 0;
    for x = 1 : n
        for y = 1 : n
            sum1 = sum1 + m1(x,y);
            sum2 = sum2 + m2(x,y);
        end
    end
    aver1 = sum1/(n*n);
    aver2 = sum2/(n*n);    
    stand1 = 0;
    stand2 = 0;
    for x = 1 : n
        for y = 1 : n
            stand1 = stand1 + (m1(x,y)-aver1)^2;
            stand2 = stand2 + (m2(x,y)-aver2)^2;
        end
    end
    
    std_1 = sqrt(stand1/(n*n));
    std_2 = sqrt(stand2/(n*n));
    
%     aver1 = mean2(m1);
%     std_1 = std2(m1);
%     aver2 = mean2(m2);
%     std_2 = std2(m2);
    
%     if(std_1 ~= stand1)
%        disp(std_1);
%        disp(stand2);
%     end

    square_sum = 0;
    for x = 1 : n
        for y = 1 : n
            diff = (((m1(x,y)-aver1)/std_1) - ((m2(x,y)-aver2)/std_2))^2;
            square_sum = square_sum + diff;
        end
    end
end