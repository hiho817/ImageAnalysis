close all
clear all

%% parameters
videofilename = 'RBC20240304.wmv';

fn = 0;
smallremoval = 600;

%% load the video
v = VideoReader(videofilename);
load('lec20240305.mat');
%% play video with while loop
while hasFrame(v)
    frame = readFrame(v);
    fn = fn + 1; % frame counter
    
     diff = frame - backg;  % show brighter parts
%     diff = backg - frame;  % show darker parts
%    diff = (backg - frame) + (frame - backg);
    diffBW = imbinarize(rgb2gray(diff));
    diffBW = bwareaopen(diffBW, smallremoval);


    % display on the screen
    subplot(1,2,1)
    imshow(frame);
    title(['frame = ' num2str(fn)])

    subplot(1,2,2)
    imshow(diffBW);

%     pause(1)
    drawnow
end