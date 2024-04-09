close all

filename = 'midterm01a.mp4';
frame_num = 0;

v = VideoReader(filename);

while hasFrame(v)
    frame = readFrame(v);
    frame_num = frame_num + 1;
   
    imshow(frame)
    hold on
    title(['frame=',num2str(frame_num)]);
    hold off
    drawnow;
end

