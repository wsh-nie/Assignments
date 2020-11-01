clear;clc;
%{
fig2 = imread("Fig2.tif");
fig_g = im2bw(fig2,0.53);

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
[fig_ed,fig_t_hat] = T_hat(fig2,E);
fig_ed = uint8(fig_ed);
fig_t_hat = uint8(fig_t_hat);
fig_g2 = im2bw(fig_t_hat,0.2);
figure;
subplot(221); imshow(fig2); title('原图'); axis on;
subplot(222); imshow(fig_g); title('二值图像'); axis on;
subplot(234); imshow(fig_ed); title('开操作图像'); axis on;
subplot(235); imshow(fig_t_hat); title('顶帽图像'); axis on;
subplot(236); imshow(fig_g2); title('减开操作之后的二值图像'); axis on;

fig3 = imread("Fig3.tif");
[fig_5,fig_10,fig_20,fig_25,fig_30,y] = Detect(fig3);
figure;
subplot(231); imshow(fig3); title('图像'); axis on
subplot(232); imshow(fig_5); title('5图像'); axis on
subplot(233); imshow(fig_10); title('10图像'); axis on
subplot(234); imshow(fig_20); title('20图像'); axis on
subplot(235); imshow(fig_25); title('25图像'); axis on
subplot(236); imshow(fig_30); title('30图像'); axis on
figure;
x=1:1:35;%x轴上的数据，第一个值代表数据开始，第二个值代表间隔，第三个值代表终止
plot(x,y,'-*b'); %线性，颜色，标记
ylabel('表面区域差')  %x轴坐标描述
xlabel('圆盘半径') %y轴坐标描述

%}
fig4 = imread("Fig4.tif");
[fig4_ed,fig4_deed,fig_side] = Gradiant(fig4);
figure;
subplot(221); imshow(fig4); title('图像'); axis on
subplot(222); imshow(fig4_ed); title('大斑点图像'); axis on
subplot(223); imshow(fig4_deed); title('边界图像'); axis on
subplot(224); imshow(fig_side); title('边界+原图像'); axis on
