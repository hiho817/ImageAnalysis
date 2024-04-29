close all
clear all
%Parameters
filename = 'midterm01b.mp4';
frame_num = 0;
outfilename = 'mid_109611112_07.mp4';
x=0;
y=0;
radii_range = [30,500];
max = [0,0];
min = [1000,1000];
% Read the video
v = VideoReader(filename);

% generate or load background (bg)
bgfilename = 'background.bmp';

if exist(bgfilename)
    bg = imread(bgfilename);
else
    bg = genbg_median(filename);
    imwrite(bg, bgfilename);
end

% Create an output video and open it
out = VideoWriter(outfilename, "MPEG-4");
open(out);

while hasFrame(v)
    frame = readFrame(v);
    frame_num = frame_num + 1;
    nobg = (frame-bg)+(bg-frame);
    nobg = rgb2gray(nobg);

    [centers, radii, metric] = imfindcircles(nobg,radii_range,'Sensitivity',0.92,ObjectPolarity='bright');
    

    % Filter regions
    if (frame_num == 1)
        last_centers(frame_num,:) = centers(1,:);
        last_radii(frame_num) = radii(1);
    else
        min_dis = 1000;
        for i = 1:numel(centers)/2
            tmp = (centers(i,1)-last_centers(1))^2+(centers(i,2)-last_centers(2))^2;
            if (tmp<min_dis)
                min_dis = tmp;
                n=i;
            end
        end
        last_centers(frame_num,:) = centers(i,:);
        last_radii(frame_num) = radii(i);
    end
 

    x = last_centers(frame_num,1);
    y = last_centers(frame_num,2);
    %draw the wall
    if( x + last_radii(frame_num) > max(1))
        max(1) = x + last_radii(frame_num);
    end
    if( y + last_radii(frame_num) > max(2))
        max(2) = y + last_radii(frame_num);
    end
    if( x - last_radii(frame_num) < min(1))
        min(1) = x - last_radii(frame_num);
    end
    if( y - last_radii(frame_num) < min(2))
        min(2) = y - last_radii(frame_num);
    end

    imshow(frame)
    hold on
    rectangle('Position',[min(1) min(2) max(1)-min(1) max(2)-min(2)],'LineWidth',2,EdgeColor='b');
    plot(last_centers(:,1), last_centers(:,2), 'Color','black', 'LineWidth',3);
    hold off
    drawnow;
    f = getframe(gcf);
    [FF, junk] = frame2im(f);
    writeVideo(out, FF); % write gcf(get current figure) to a frame
end

close(out);