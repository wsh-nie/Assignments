function q = GuideFilter(t_hat, t_hat1, radio, eps)
%GUIDEFILTER 此处显示有关此函数的摘要
%   此处显示详细说明

[hei, wid] = size(t_hat);
N = BoxFilter(ones(hei, wid), radio); % the size of each local patch; N=(2r+1)^2 except for boundary pixels.

mean_I = BoxFilter(t_hat, radio) ./ N;
mean_p = BoxFilter(t_hat1, radio) ./ N;
mean_Ip = BoxFilter(t_hat.*t_hat1, radio) ./ N;
cov_Ip = mean_Ip - mean_I .* mean_p; % this is the covariance of (I, p) in each local patch.

mean_II = BoxFilter(t_hat.*t_hat, radio) ./ N;
var_I = mean_II - mean_I .* mean_I;

a = cov_Ip ./ (var_I + eps); % Eqn. (5) in the paper;
b = mean_p - a .* mean_I; % Eqn. (6) in the paper;

mean_a = BoxFilter(a, radio) ./ N;
mean_b = BoxFilter(b, radio) ./ N;

q = mean_a .* t_hat + mean_b; % Eqn. (8) in the paper;
end

