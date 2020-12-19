function delta_phi = Delta_phi(f)
%DELTA_PHI 此处显示有关此函数的摘要
%   此处显示详细说明
[f_fx,f_fy]=forward_gradient(f);
[f_bx,f_by]=backward_gradient(f);

mag1=sqrt(f_fx.^2+f_fy.^2+1e-10);
n1x=f_fx./mag1;
n1y=f_fy./mag1;

mag2=sqrt(f_bx.^2+f_fy.^2+1e-10);
n2x=f_bx./mag2;
n2y=f_fy./mag2;

mag3=sqrt(f_fx.^2+f_by.^2+1e-10);
n3x=f_fx./mag3;
n3y=f_by./mag3;

mag4=sqrt(f_bx.^2+f_by.^2+1e-10);
n4x=f_bx./mag4;
n4y=f_by./mag4;

nx=n1x+n2x+n3x+n4x; % fx
ny=n1y+n2y+n3y+n4y; % fy

magn=sqrt(nx.^2+ny.^2);% magn = |Df|

nx=nx./(magn+1e-10);% fx / |Df|
ny=ny./(magn+1e-10);% fy / |Df|

nx = nx .*(magn -1 + 1e-10);
ny = ny .*(magn -1 + 1e-10);

[nxx,nxy]=gradient(nx);
[nyx,nyy]=gradient(ny);

delta_phi = nxx + nyy;
end

