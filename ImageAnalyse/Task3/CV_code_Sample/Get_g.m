function g = Get_g(I)
%GET_G g = 1 / (1 + (G * I)^2)
%   此处显示详细说明

G = fspecial('gaussian', 15, 1.5);
G = imfilter(I,G,'replicate');
[Gx,Gy] = gradient(G);
g = 1. ./ (1 + Gx .^2 + Gy .^2);

end

