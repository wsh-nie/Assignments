function [] = RemoveHaze(file)
%REMOVEHAZE 此处显示有关此函数的摘要
%   此处显示详细说明

img = imread(file);
figure;
subplot(321);imshow(img);title("Haze image");axis on;

dark = GetDark(img);
subplot(322);imshow(dark);title("Dark Channel");axis on;

airlightimg = GetAirlight(img,dark);
subplot(323);imshow(airlightimg);title("Air Light");axis on;

t_hat = GetT_hat(img,airlightimg);
subplot(324);imshow(t_hat);title("T hat");axis on;

t = GuideFilter(t_hat,t_hat,3,0.01);
subplot(325);imshow(t);title("T");axis on;

imgRemovalHaze = GetImg(img,airlightimg,t);
subplot(326);imshow(imgRemovalHaze);title("Remove Haze");axis on;

end

