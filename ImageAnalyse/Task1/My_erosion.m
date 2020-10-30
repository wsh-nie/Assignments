function my_e = My_erosion(fig,E)
%MY_ELAPTION 腐蚀函数
%   fig是二值矩阵，E是结构元素

%% 获得图像尺寸
[H,W] = size(fig); %918 * 2018
%fig_f = double(fig);

%% 获得结构元素的尺寸
[h,w] = size(E);

%% 图像腐蚀
my_e = zeros(H,W);
for i = 1:H-h+1
    for j = 1:W
        fig_sub = fig(i:i+h-1,j:j+w-1);
        C = fig_sub .* E + (1-E);
        my_e(i,j) = min(C(:));
    end
end

