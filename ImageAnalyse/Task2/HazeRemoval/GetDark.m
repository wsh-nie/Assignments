function dark = GetDark(img)
%GETDARK Get Dark Channel
%   此处显示详细说明

B = double(img(:,:,1)) ./255.0;
G = double(img(:,:,2)) ./255.0;
R = double(img(:,:,3)) ./255.0;
[M,N] = size(R);
dark = double(zeros(M,N));
for i = 1:M
    for j = 1:N
        dark(i,j) = min(min(R(i,j),G(i,j)),min(R(i,j),B(i,j)));
    end
end

end

