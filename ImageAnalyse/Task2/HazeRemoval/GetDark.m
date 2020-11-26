function dark = GetDark(img)
%GETDARK Get Dark Channel
%   此处显示详细说明
B = img(:,:,1);
G = img(:,:,2);
R = img(:,:,3);
[M,N] = size(R);
minRGB = zeros(M,N);
dark = zeros(M,N);
for i = 1:M
    for j = 1:N
        minRGB(i,j) = min(min(R(i,j),G(i,j)),min(R(i,j),B(i,j)));
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
        dark(i,j) = minNum;
    end
end
dark = uint8(dark);
end

