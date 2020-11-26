function imgRemovalHaze = GetImg(img,airlight,t)
%GETIMG 此处显示有关此函数的摘要
%   此处显示详细说明
img = double(img);
airlight = double(airlight);
newt(:,:,1) = t;
newt(:,:,2) = t;
newt(:,:,3) = t;
newt = max(newt(:,:,:),0.1);

imgRemovalHaze = (img - airlight) ./newt + airlight;
imgRemovalHaze = uint8(imgRemovalHaze);
end

