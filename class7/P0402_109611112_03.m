close all
clear all

%parameter
videofilename = 'bouncing_ball.mp4';
outfilename = 'P0402_109611112_03.mp4';
n = 0;
x = 0;
y = 0;

max = [0,0];
min = [1000,1000];

%readfile
v = VideoReader(videofilename);

%writefile
o = VideoWriter(outfilename, "MPEG-4");
open(o);

%print image frame by frame
while hasFrame(v)
    n = n + 1;
    I = readFrame(v);
    gray = rgb2gray(I);
    bw = imbinarize(gray,"global"); % Otsu's method
    bw = ~bw;
    state = regionprops(bw, 'Area', 'Centroid','Circularity');
    
    circle = state([state.Circularity] >= 0.8);
    x(n) = circle.Centroid(1);
    y(n) = circle.Centroid(2);
    Area = circle.Area;
    
    %%% cool stuff
    % min(1) = min(1)+5;
    % min(2) = min(2)+5;
    % max(1) = max(1)-5;
    % max(2) = max(2)-5;

    %find circle boundary
    radius = sqrt(Area/pi);
    if( x(n) + radius > max(1))
        max(1) = x(n) + radius;
    end
    if( y(n) + radius > max(2))
        max(2) = y(n) + radius;
    end
    if( x(n) - radius < min(1))
        min(1) = x(n) - radius;
    end
    if( y(n) - radius < min(2))
        min(2) = y(n) - radius;
    end
       

    imshow(I);
    hold on;
    %text(x(n), y(n),num2str(circle.Area), 'Color', 'red','FontSize',20);
    plot(x(1:n), y(1:n), 'Color','black', 'LineWidth',3);
    rectangle('Position',[min(1) min(2) max(1)-min(1) max(2)-min(2)],'LineWidth',2,EdgeColor='b');
    drawnow;
    hold off;

    f = getframe(gcf);
    [FF, junk] = frame2im(f);
    writeVideo(o, FF); % write gcf(get current figure) to a frame
end

close(o);