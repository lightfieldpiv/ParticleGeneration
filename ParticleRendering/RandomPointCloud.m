%% This function is used to generate a random point cloud in the space
function pc = RandomPointCloud(num, range)
rng(0,'twister');
x = (range(2)-range(1)).*rand(num,1) + range(1);
y = (range(4)-range(3)).*rand(num,1) + range(3);
z = (range(6)-range(5)).*rand(num,1) + range(5);
xyz = [x,y,z];
pc = pointCloud(xyz);
% figure; pcshow(pc,'MarkerSize',200);
% xlabel('x');ylabel('y');zlabel('z');grid on;