function airlight = GetAirlight(img,dark)
%GETAIRLIGHT Get the Air light
%   pick the top 0.1% brightest pixels in the dark channel 
%   the pixels with highest intensity in the input image is selected as the
%   atmospheric light

[M,N] = size(dark);
airlight = zeros(M,N);

end

