%   Matlad code implementing Chan-Vese model in the paper 'Active Contours Without Edges'
%   This method works well for bimodal images, for example the image 'three.bmp'


clear;
close all;
clc;

%Img=imread('three.bmp');      % example that CV model works well
%Img=imread('vessel.bmp');    % Warning: example image that CV model does NOT work well
Img=imread('twoCells.bmp');   % Warning: example image that CV model does NOT work well
U=Img(:,:,1);% 获得一个分量的值

% get the size
[nrow,ncol] =size(U);
%{范围太小
ic=nrow/2;
jc=ncol/2;
r=20;
phi_0 = sdf2circle(nrow,ncol,ic,jc,r); %初始化一个常量二维矩阵，sqrt((X-ic)^2 + (Y-jc)^2) -r
%}
initialLSF=  2 * ones(size(U));
initialLSF(5:nrow-5, 5:ncol-5)=-2;  
phi_0=initialLSF;

figure; mesh(phi_0); title('Signed Distance Function')

delta_t = 5;
lambda_1=1;
lambda_2=1;
nu=1.5;
h = 1;
epsilon=1.5;
mu = 0.04;

I=double(U);
% iteration should begin from here
phi=phi_0;
figure(2);
subplot(1,2,1); mesh(phi);
subplot(1,2,2); imagesc(uint8(I));colormap(gray)
hold on;
plotLevelSet(phi,0,'r');

numIter = 1;
for k=1:400,
    phi = evolution_cv(I, phi, mu, nu, lambda_1, lambda_2, delta_t, epsilon, numIter);   % update level set function
    if mod(k,10)==0
        pause(0.05);
        figure(2); clc; axis equal; 
        title(sprintf('Itertion times: %d', k));
        subplot(1,2,1); mesh(phi);
        subplot(1,2,2); imagesc(uint8(I));colormap(gray)
        hold on; plotLevelSet(phi,0,'r');
    end    
end;
