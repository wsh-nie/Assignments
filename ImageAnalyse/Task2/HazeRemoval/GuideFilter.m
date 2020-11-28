function q = GuideFilter(t_hat, radio, eps)
%GUIDEFILTER 此处显示有关此函数的摘要
%   此处显示详细说明

p = t_hat;
[hei, wid] = size(t_hat);
%local patch size N=(2r+1)^2 
N = BoxFilter(ones(hei, wid), radio); 
% step 1
mean_I = BoxFilter(t_hat, radio) ./ N;
mean_p = BoxFilter(p, radio) ./ N;
mean_Ip = BoxFilter(t_hat.*p, radio) ./ N;
cov_Ip = mean_Ip - mean_I .* mean_p; 
% step 2
mean_II = BoxFilter(t_hat.*t_hat, radio) ./ N;
var_I = mean_II - mean_I .* mean_I;
% step 3
a = cov_Ip ./ (var_I + eps); 
b = mean_p - a .* mean_I; 
% step 4
mean_a = BoxFilter(a, radio) ./ N;
mean_b = BoxFilter(b, radio) ./ N;
% step 5
q = mean_a .* t_hat + mean_b; 
end

