function imgRemovalHaze = GetImg(img,airlight,t)
%GETIMG �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
img = double(img);
airlight = double(airlight);
newt(:,:,1) = t;
newt(:,:,2) = t;
newt(:,:,3) = t;
newt = max(double(newt(:,:,:)),0.1);
[M,N,H] = size(img);
imgRemovalHaze = (img - airlight) ./newt +airlight;
rhgsx = img - airlight;
[B,I] = maxk((rhgsx(:)),1);

whos imgRemovalHaze;
disp(img(M,N,H));
disp(airlight(M,N,H));
disp(newt(M,N,H))
disp(imgRemovalHaze(M,N,H));disp(B + " "+ I);
imgRemovalHaze = uint8(imgRemovalHaze);
end

