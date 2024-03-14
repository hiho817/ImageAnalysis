close all
clear all

%% Parameters
filename = '20210913tennis.mp4';
outfilename = 'hw01_sol_3.mp4';
framenum = 0;
clip_start = [195 270 340];
clip_length = 30;   % length of each hitting clip in frame
clipn = 1;
slowmotionFactor = 3; % defines how many times slower 


%% Read the video
v = VideoReader(filename);

%% Open an output video
out = VideoWriter(outfilename, 'MPEG-4');
out.FrameRate = v.FrameRate;
open(out);

%% Play the video
while hasFrame(v) 
    frame = readFrame(v);
    framenum = framenum + 1;
    if framenum < clip_start(clipn)
        imshow(frame)
        writeVideo(out, frame)
        continue; % skip the rest of the loop
    end
    for slower = 1:slowmotionFactor
        imshow(frame)
        title(num2str(framenum))
        drawnow
        writeVideo(out, frame);
    end
    if framenum > clip_start(clipn)+clip_length && clipn < numel(clip_start)
        clipn = clipn + 1;
    end
end

close(out)