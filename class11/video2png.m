close all
clear all


videofilename = 'mesh_0mm_resize_600frame.mp4';
n = 0;

[Dir, name, ext] = fileparts(videofilename);

if ~exist(name, 'dir')
    mkdir(name);
end

v = VideoReader(videofilename);

while hasFrame(v)
    n=n+1;
    frame = readFrame(v);
    outputname = sprintf([name '/' name '_%04d.png'], n);
    imwrite(frame, outputname)
end
