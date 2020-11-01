function fig_e = Erosion(fig,E)
%MY_ELAPTION 腐蚀函数
%   fig是二值矩阵，E是结构元素

%% 获得图像尺寸
[H,W] = size(fig); %918 * 2018

%% 获得结构元素的尺寸
[h,w] = size(E);
h_2 = floor((h+1)/2);
w_2 = floor((w+1)/2);
E = double(E);

%% 图像padding
fig = [fig(:,w-1:-1:1),fig,fig(:,W:-1:W-w+2)];
fig = [fig(h-1:-1:1,:);fig;fig(H:-1:H-h+2,:)];
fig = double(fig);
%% 图像腐蚀
fig_e = zeros(H,W,'uint8');
for i = 1:H
    for j = 1:W
        fig_sub = fig(i+h_2-1:i+h_2+h-2,j+w_2-1:j+w_2+w-2);
        C = fig_sub.*E + 255*(1-E);
        fig_e(i,j) = min(C(:));
    end
    %disp(im_e)
end

