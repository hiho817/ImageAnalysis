filename = '20210913tennis.mp4';
v = VideoReader(filename);
num = v.NumFrames;
hit_frame = [90 165 225 290];
output_video = VideoWriter('HW01_109611112_02','MPEG-4');
open(output_video);
for n = 1:4
    hit = hit_frame(n);
    tmp = read(v,[hit-20 hit+20]);
    writeVideo(output_video,tmp);
end
close(output_video);