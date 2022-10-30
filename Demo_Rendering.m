%% This script is used to demonstrate the light field particle rendering.
% we show how to randomly generate the point cloud of particles
% and how to render the point cloud with two light field cameras.
clc;
clear;
addpath('.\ParticleRendering\');
dataPath = '.\result\';

if ~exist(dataPath,'dir')
    mkdir(dataPath);
end

%% select the partciles of current time
particle_time_id = 1;
pcName = [dataPath 'pt' num2str(particle_time_id,'%02d') '.ply'];
if ~exist(pcName,'file')
    % randomly generate the point cloud of particles for testing
    ParticleNum = 300;
    ParticleRange = [-0.05,0.05,-0.05,0.05,0.1,0.2];
    pc = RandomPointCloud(ParticleNum, ParticleRange);
    pcwrite(pc,pcName);
end
ParticleRadius     = 0.002;

%% set the parameters of light field camera
LF_Param.BaseLine  = 0.0002; % baseline between two subaperture image
LF_Param.num_s     = 11;     % angular resolution
LF_Param.num_t     = 11;     % angular resolution
LF_Param.hwf       = [400,400,400]; % camera parameter of subaperature image

%% render the particle image for the light field cameras
LF = renderParticle_LF(pcName, LF_Param, ParticleRadius);
imc = squeeze(LF(round(LF_Param.num_t/2),round(LF_Param.num_s/2),:,:,:));
imwrite(imc,[dataPath 'pt' num2str(particle_time_id,'%02d') '.png']);
LF_Size = [LF_Param.num_t, LF_Param.num_s, LF_Param.hwf(1), LF_Param.hwf(2), 3];
save([dataPath 'pt' num2str(particle_time_id,'%02d') '.mat'],'LF','LF_Param','LF_Size');

% display the light field image
figure;
for j = 1:LF_Param.num_t
    for i = 1:LF_Param.num_s
        imshow(squeeze(LF(j,i,:,:,:)));
        pause(0.02);
    end
end
