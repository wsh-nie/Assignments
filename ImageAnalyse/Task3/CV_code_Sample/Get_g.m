function g = Get_g(I)
%GET_G g = 1 / (1 + (G * I)^2)
%   此处显示详细说明

G = fspecial('gaussian');
G = imfilter(I,G,'replicate');
g = 1.0 ./ (1 + G .^2);

end

