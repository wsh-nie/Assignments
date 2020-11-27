function dark = GetDark(img)
%GETDARK Get Dark Channel
%   �˴���ʾ��ϸ˵��
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
        for m = i-1:i+1
            for n = j-1:j+1
                if and(and(m>=1,m<=M),and(n>=1,n<=N))
                    minNum = min(minNum,minRGB(m,n));
                end
            end
        end
        dark(i,j) = minNum;
    end
end
dark = uint8(dark);
end

