%% This function is used to compute the ray to sphere intersection
% please build INTERSECTSPHERE first
% run: mex INTERSECTSPHERE.cpp

function [flag, Hitpoint, NN, idx] = IntersectSphereC(ray, spheres)
orig = ray.s;
dir = ray.d./norm(ray.d);
[fnums,~] = size(spheres);

%% compute the hit point for th ray and every triangle
[isect, tNear] = INTERSECTSPHERE(orig, dir, spheres(:,1),spheres(:,2),spheres(:,3),spheres(:,4),[fnums]);

%% find the hitpoint from the intersection
flag = 0;
idx = 0;
Hitpoint = [nan;nan;nan];
NN = [nan;nan;nan];
A = find(isect == 1);
if ~isempty(A)
    flag = 1;
    tNear_p = tNear(A);
    [t,id1] = min(tNear_p);
    idx = A(id1);
    Hitpoint = orig + t.*dir;
    NN = Hitpoint - spheres(A(id1),1:3)';
    NN = NN./norm(NN);
end