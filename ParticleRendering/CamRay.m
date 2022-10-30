%% This scirpt is used to generate the camera ray through the projection matrix
function dir = CamRay(C, u, v)

dir = C.iK*[u;v;1];
dir = dir./norm(dir);