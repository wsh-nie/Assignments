function airlightimg = GetAirlight(img,dark)
%GETAIRLIGHT Get the Air light
%   pick the top 0.1% brightest pixels in the dark channel 
%   the pixels with highest intensity in the input image is selected as the
%   atmospheric light

[M,N] = size(dark);
airlight = zeros(M,N);
darkline = dark(:);
imggray = rgb2gray(img);

k = ceil(M*N * 0.001);
[~,I] = maxk(darkline,k);
highestintensity = 0;
posx = 0;
posy = 0;
for i = 1:k
    x = int32(mod(I(i),M))+1;
    y = int32((I(i)-1)/M)+1;
    if imggray(x,y) > highestintensity
        posx = x;
        posy = y;
    end
end

for i = 1:M
    for j = 1:N
        airlight(i,j) = imggray(posx,posy);
    end
end

airlightimg(:,:,1) = airlight;
airlightimg(:,:,2) = airlight;
airlightimg(:,:,3) = airlight;
airlightimg = uint8(airlightimg);

end

