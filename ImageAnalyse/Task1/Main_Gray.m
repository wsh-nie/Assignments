fig = imread("Fig2.tif");
fig_g = im2bw(fig,0.53);
imshow(fig_g);

%% 顶帽变换
%初始化结构元素
E = zeros(40,40);
for i = -40:1:40
    for j = -40:1:40
        if(i^2+j^2<1600)
            E(i+41,j+41) = 1;
        else
            E(i+41,j+41) = 0;
        end
    end
end

fig_t_hat = T_hat(fig_g,E);
fig_t_hat = uint8(255 * mat2gray(fig_t_hat));
figure,imshow(fig_t_hat);
