function T_hat = GetT_hat(img,airlight)
%GETT_HAT Get T'
%   此处显示详细说明
omega = 0.95;
imgB = double(img(:,:,1));
imgG = double(img(:,:,2));
imgR = double(img(:,:,3));

airB = double(airlight(:,:,1));
airG = double(airlight(:,:,2));
airR = double(airlight(:,:,3));


[M,N] = size(imgR);
T_hat = zeros(M,N);
minRGB = zeros(M,N);
for i = 1:M
    for j = 1:N
        minRGB(i,j) = min(min(imgR(i,j)/airR(i,j),imgG(i,j)/airG(i,j)),min(imgR(i,j)/airR(i,j),imgB(i,j)/airB(i,j)));
    end
end

% Omega(X) size is 3*3
for i = 1:M
    for j = 1:N
        minNum = minRGB(i,j);
        if and(and(1<= i-1,i-1<=M),and(1<=j-1,j-1<= N))
            minNum = min(minNum,minRGB(i-1,j-1));
        end
        if and(and(1<= i+1,i+1<=M),and(1<=j+1,j+1<= N))
            minNum = min(minNum,minRGB(i+1,j+1));
        end
        if and(and(1<= i-1,i-1<=M),and(1<=j+1,j+1<= N))
            minNum = min(minNum,minRGB(i-1,j+1));
        end
        if and(and(1<= i+1,i+1<=M),and(1<=j-1,j-1<= N))
            minNum = min(minNum,minRGB(i+1,j-1));
        end
        if and(1<= i+1,i+1<=M)
            minNum = min(minNum,minRGB(i+1,j));
        end
        if and(1<= i-1,i-1<=M)
            minNum = min(minNum,minRGB(i-1,j));
        end
        if and(1<= j+1,j+1<=N)
            minNum = min(minNum,minRGB(i,j+1));
        end
        if and(1<= j-1,j-1<=N)
            minNum = min(minNum,minRGB(i,j-1));
        end
        T_hat(i,j) = minNum;
    end
end
T_hat = 1 - omega * T_hat;

end

