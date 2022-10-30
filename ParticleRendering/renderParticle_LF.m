%% render the particle Light Field image based on ray-tracing.
function LF = renderParticle_LF(pcName, LF_Param, radius)

%% read the point cloud of particles
if exist(pcName,'file')
    ptCloud = pcread(pcName);
else
    disp('can not find the point cloud to rendering...');
    return;
end
num_pt = ptCloud.Count;

%% create the sphere with the point cloud
spheres = zeros(num_pt,4);
for i = 1:num_pt
    spheres(i,1:3)  = ptCloud.Location(i,:);
    spheres(i,4)    = radius;
end

%% set LF parameters
baseline    = LF_Param.BaseLine;
num_s       = LF_Param.num_s;
num_t       = LF_Param.num_t;
C.h         = LF_Param.hwf(1);
C.w         = LF_Param.hwf(2);
C.f         = LF_Param.hwf(3);
C.K         = [C.f,0,C.w/2;0,C.f,C.h/2;0,0,1];
C.iK        = inv(C.K);

%% reshape the light field camera parameters
Cams = cell(1,num_s*num_t);
count = 1;
for tt = 1:num_t
    for ss = 1:num_s
        C.locs = [(ss-round(num_s/2))*baseline;(tt-round(num_t/2))*baseline;0];
        Cams{count} = C;
        count = count + 1;
    end
end

%% rendering the light field images
LF = zeros(num_t*num_s,C.h,C.w,3);
disp('Rendering the light field particle image...');
tic;
parfor kk = 1:num_t*num_s
    disp(kk);
    LF(kk,:,:,:) = renderImage(Cams{kk}, spheres);
end
toc;
disp('Done...')

LF = reshape(LF,[num_t, num_s, C.h, C.w, 3]);
LF = permute(LF,[2 1 3 4 5]);
