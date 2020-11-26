function T_hat = GetT_hat(img,airlight)
%GETT_HAT 此处显示有关此函数的摘要
%   此处显示详细说明
omega = 0.95;
imgB = double(img(:,:,1)) ./255.0;
imgG = double(img(:,:,2)) ./255.0;
imgR = double(img(:,:,3)) ./255.0;

airB = double(airlight(:,:,1)) ./255.0;
airG = double(airlight(:,:,2)) ./255.0;
airR = double(airlight(:,:,3)) ./255.0;


[M,N] = size(imgR);
T_hat = zeros(M,N);
for i = 1:M
    for j = 1:N
        T_hat(i,j) = 1 - omega * min(min(imgR(i,j)/airR(i,j),imgG(i,j)/airG(i,j)),min(imgR(i,j)/airR(i,j),imgB(i,j)/airB(i,j)));
    end
end

end

