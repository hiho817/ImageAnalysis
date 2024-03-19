close all
clear all

filename = 'RBC20240304.wmv';
frame_num = 0;

v = VideoReader(filename);

while hasFrame(v)
    frame = readFrame(v);
    frame_num = frame_num + 1;
    imshow(frame)
end

