function E = GetElementEnty(R)
%GETELEMENTENTY �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
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

