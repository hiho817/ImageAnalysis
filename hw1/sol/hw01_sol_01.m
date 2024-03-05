close all
clear all

%% Parameters
filename = '20210913tennis.mp4';



%% Read the video
v = VideoReader(filename);


%% Play the video
while hasFrame(v)
    frame = readFrame(v);
    imshow(frame)
    drawnow
end