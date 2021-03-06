function Delta_h = Delta(phi, epsilon)
%   Delta(phi, epsilon) compute the smooth Dirac function
%  
%   created on 04/26/2004
%   author: Chunming Li
%   email: li_chunming@hotmail.com
%   Copyright (c) 2004-2006 by Chunming Li

%Delta_h=(epsilon/pi)./(epsilon^2+ phi.^2);
[h,w] = size(phi);
Delta_h = zeros(h,w);
for i = 1:h
    for j = 1:w
        if abs(phi(i,j)) > epsilon
            Delta_h(i,j) = 0;
        else 
            Delta_h(i,j) = 1.0 /(2 * epsilon) * (1 + cos((pi * phi(i,j))/epsilon));
        end
    end
end