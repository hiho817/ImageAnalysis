close all
clear all

%parameters
videofilename = 'RBC20240304.wmv';
fn = 0;

%load the video
v = VideoReader(videofilename);

% play video with while loop
while hasFrame(v)
    frame = readFrame(v);
    
    imshow(frame);
end