%Parameters
filename = 'video.avi';
framenum = 0;
% Read the video
v = VideoReader(filename);

% Track the object in the video
while hasFrame(v)
    frame = readFrame(v);
    framenum = framenum + 1;
    imshow(frame);
end