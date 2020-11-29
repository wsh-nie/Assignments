function [] = RemoveHaze(file,filename)
%REMOVEHAZE 此处显示有关此函数的摘要
%   此处显示详细说明

img = imread(file);
figure;
subplot(321);imshow(img);title("Haze image");axis on;
%imwrite(img,['output\img\',filename]);

dark = GetDark(img);
darkimg = uint8(dark);
subplot(322);imshow(darkimg);title("Dark Channel");axis on;
%imwrite(darkimg,['output\darkimg\',filename]);

airlightimg = GetAirlight(img,dark);
subplot(323);imshow(airlightimg);title("Air Light");axis on;
%imwrite(airlightimg,['output\airlightimg\',filename]);

t_hat = GetT_hat(img,airlightimg);
subplot(324);imshow(t_hat);title("T hat");axis on;
%imwrite(t_hat,['output\t_hat\',filename]);

t = GuideFilter(t_hat,3,0.01);
subplot(325);imshow(t);title("T");axis on;
%imwrite(t,['output\t\',filename]);

imgRemovalHaze = GetImg(img,airlightimg,t);
subplot(326);imshow(imgRemovalHaze);title("Remove Haze");axis on;
%imwrite(imgRemovalHaze,['output\removehazeimg\',filename]);

end

