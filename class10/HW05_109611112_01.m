close all
clear 

videofilename = 'test_yolo.mp4';

v = VideoReader(videofilename);

while hasFrame(v)
    frame = readFrame(v);
    imshow(frame)
end