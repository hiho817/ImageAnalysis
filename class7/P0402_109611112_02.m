close all
clear all

%parameter
videofilename = 'bouncing_ball.mp4';
outfilename = 'P0402_109611112_02.mp4';
n = 0;
x = 0;
y = 0;

%readfile
v = VideoReader(videofilename);

%writefile
o = VideoWriter(outfilename);
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
        
    imshow(I);
    hold on;
    %text(x(n), y(n),num2str(circle.Area), 'Color', 'red','FontSize',20);
    plot(x, y, 'Color','black', 'LineWidth',3);
    drawnow;
    hold off;

    f = getframe(gcf);
    [FF, junk] = frame2im(f);
    writeVideo(o, FF); % write gcf(get current figure) to a frame

end

close(o);