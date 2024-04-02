close all
clear all

%parameter
videofilename = 'bouncing_ball.mp4';
n=0;

%readfile
v = VideoReader(videofilename);

%print image frame by frame
while hasFrame(v)
    n = n + 1;
    I = readFrame(v);
    imshow(I);
end