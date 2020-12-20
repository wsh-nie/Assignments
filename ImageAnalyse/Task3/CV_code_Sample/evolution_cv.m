function phi = EVOLUTION_CV(I, phi0, mu, nu, lambda_1, lambda_2, delta_t, epsilon, numIter);
%   evolution_withoutedge(I, phi0, mu, nu, lambda_1, lambda_2, delta_t, delta_h, epsilon, numIter);
%   input: 
%       I: input image
%       phi0: level set function to be updated
%       mu: weight for length term
%       nu: weight for area term, default value 0
%       lambda_1:  weight for c1 fitting term
%       lambda_2:  weight for c2 fitting term
%       delta_t: time step
%       epsilon: parameter for computing smooth Heaviside and dirac function
%       numIter: number of iterations
%   output: 
%       phi: updated level set function
%  
%   created on 04/26/2004
%   author: Chunming Li
%   email: li_chunming@hotmail.com
%   Copyright (c) 2004-2006 by Chunming Li


I = BoundMirrorExpand(I); % ¾µÏñ±ßÔµÑÓÍØ
phi = BoundMirrorExpand(phi0);

lambda = 5;
g = Get_g(I);
[gx,gy] = gradient(g);
[phix,phiy] = gradient(phi);
temp = sqrt(phix .^2 + phiy .^2 + 1e-10);
phix = phix ./ temp;
phiy = phiy ./ temp;

for k = 1 : numIter
    phi = BoundMirrorEnsure(phi);
    delta_h = Delta(phi,epsilon);% Dirac function
    Curv = curvature(phi);% Curv = div(\frac{\nabla \phi}{|\nabla \phi|})
    Curv_g = phix .*gx + phiy .* gy + g .* Curv;% div(g * (Df/|Df|))
    % delta_phi = phixx + phiyy
    % delta_phi = Delta_phi(phi);% div((1-1/|D phi|) D phi)
    %[C1,C2] = binaryfit(phi,I,epsilon);
    
    % updating the phi function
    %phi=phi+delta_t*delta_h.*(mu*Curv-nu-lambda_1*(I-C1).^2+lambda_2*(I-C2).^2);    
    phi = phi + delta_t * (mu *(4 * del2(phi) - Curv) + lambda * delta_h .* Curv_g + nu * g .* delta_h );
    

end
phi = BoundMirrorShrink(phi); % È¥µôÑÓÍØµÄ±ßÔµ

