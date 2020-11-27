function T_hat = GetT_hat(img,airlight)
%GETT_HAT Get T'
%   �˴���ʾ��ϸ˵��
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
        for m = i-1:i+1
            for n = j-1:j+1
                if and(and(m>=1,m<=M),and(n>=1,n<=N))
                    minNum = min(minNum,minRGB(m,n));
                end
            end
        end
        T_hat(i,j) = minNum;
    end
end
T_hat = 1 - omega * T_hat;

end

