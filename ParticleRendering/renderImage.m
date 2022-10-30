%% This function is used to render the particle image
function [img,idx,depth] = renderImage(C, spheres)
img     = zeros(C.h,C.w,3);
idx     = zeros(C.h,C.w);
depth   = zeros(C.h,C.w);
tic;
for i = 1:C.h
    for j = 1:C.w
        % compute the ray-shpere intersection
        % get the ray equation
        ray.s = C.locs;
        ray.d = CamRay(C, i, j);
        % compute the intersection
        [flag, ~, NN, id] = IntersectSphereC(ray, spheres);
        
        if flag == 1
            img(j,i,:) = [0;1;0]*dot(ray.d, -NN);
            idx(j,i) = id;
            depth(j,i) = spheres(id,3);
        end
    end
end