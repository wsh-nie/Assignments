clear;
clc;

% read image
img = imread("test images/1.jpg");
figure;
subplot(321);imshow(img);title("Haze image");axis on;

dark = GetDark(img);
subplot(322);imshow(dark);title("Dark Channel");axis on;

airlightimg = GetAirlight(img,dark);
subplot(323);imshow(airlightimg);title("Air Light");axis on;

t_hat = GetT_hat(img,airlightimg);
subplot(324);imshow(t_hat);title("T hat");axis on;
t = GetT(img,t_hat);
subplot(325);imshow(t);title("T");axis on;

imgRemovalHaze = GetImg(img,airlightimg,t_hat);
subplot(326);imshow(imgRemovalHaze);title("Remove Haze");axis on;