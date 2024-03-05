filename = '20210913tennis.mp4';
v = VideoReader(filename);
num = v.NumFrames;
for i = 1:num
    frame = read(v,i);
    imshow(frame);
    title(['frame=',num2str(i)]);
end
