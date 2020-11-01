fig = imread("Fig2.tif");
fig_g = im2bw(fig,0.5);

%% 顶帽变换
%生成结构元素
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
[fig_ed,fig_t_hat] = T_hat(fig,E);
fig_ed = uint8(fig_ed);
fig_t_hat = uint8(fig_t_hat);
fig_g2 = im2bw(fig_t_hat,0.2);
figure;
subplot(221); imshow(fig); title('原图'); axis on;
subplot(222); imshow(fig_g); title('阈值图像'); axis on;
subplot(234); imshow(fig_ed); title('开操作图像'); axis on;
subplot(235); imshow(fig_t_hat); title('顶帽图像'); axis on;
subplot(236); imshow(fig_g2); title('阈值图像'); axis on;
