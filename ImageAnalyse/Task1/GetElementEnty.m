function E = GetElementEnty(R)
%GETELEMENTENTY 此处显示有关此函数的摘要
%   此处显示详细说明
E = zeros(R,R);
for i = -R:1:R
    for j= -R:1:R
        if(i^2 + j^2 <= R^2)
            E(i+R+1,j+R+1) = 1;
        else
            E(i+R+1,j+R+1) = 0;
        end
    end
end
end

