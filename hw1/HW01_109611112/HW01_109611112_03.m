filename = '20210913tennis.mp4';
output_filename = 'HW01_109611112_03';
hit_frame = [90 165 225 290];
SlowMoRate = 3;
SlowMoRange = 15;
start=1;
v = VideoReader(filename);
num = v.NumFrames;

output_video = VideoWriter(output_filename,'MPEG-4');
open(output_video);
for i = hit_frame
    hit = i;
    tmp = read(v,[start hit-SlowMoRange]);
    writeVideo(output_video,tmp);
    for n = hit-SlowMoRange:hit+SlowMoRange
        tmp = read(v,n);
        for i = 1:SlowMoRate
            writeVideo(output_video,tmp);
        end
        start = hit+SlowMoRange;
    end
end
tmp = read(v,[start num]);
writeVideo(output_video,tmp);
close(output_video);