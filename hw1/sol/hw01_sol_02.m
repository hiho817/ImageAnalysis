close all
clear all

%% Parameters
filename = '20210913tennis.mp4';
outfilename = 'hw01_sol_2.mp4';
framenum = 0;
clip_start = [195 270 340];
clip_length = 30;   % length of each hitting clip in frame
clipn = 1;



%% Read the video
v = VideoReader(filename);

%% Open an output video
out = VideoWriter(outfilename, 'MPEG-4');
out.FrameRate = v.FrameRate;
open(out);

%% Play the video
while hasFrame(v) && clipn <= numel(clip_start)
    frame = readFrame(v);
    framenum = framenum + 1;
    if framenum < clip_start(clipn)
        continue; % skip the rest of the loop
    end
    imshow(frame)
    title(num2str(framenum))
%     pause(0.1)
    drawnow
    writeVideo(out, frame);
    if framenum > clip_start(clipn)+clip_length
        clipn = clipn + 1;
    end
end

close(out)