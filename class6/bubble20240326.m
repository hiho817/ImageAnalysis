close all
clear all

videofilename = 'mesh_0mm_resize_600frame.mp4';
textheight = 10;
Rrange = [3 100];
threshold = 0.54;
sense = 0.75;
scale = 2.38;  % micrometer per pixel
interval = 100; % ms
RealFPS = 500; % recording speed in fps
histxbins = 0:5:100;
AllRadii = 0;
time_step = 1000/RealFPS;
lookbackframe = round(interval / time_step);
n=0;

v = VideoReader(videofilename);
% v.CurrentTime = 0;
figure('WindowState','maximized')
while hasFrame(v)
%     n = round(1+v.CurrentTime*v.FrameRate);
    n=n+1;
    frame = readFrame(v);
    frame = frame(1:v.Height-textheight, :, :); % similar func -> imcrop

    gray = rgb2gray(frame);
%     threshold = graythresh(gray);  % Otsu method
    BW = imbinarize(gray, threshold);


    [centers radii] = imfindcircles(BW, Rrange, 'ObjectPolarity', 'dark', ...
        'Sensitivity', sense);
    bubblenumperframe(n) = numel(radii);

    if isempty('AllRadii')
        AllRadii = radii;
    else
        AllRadii = [AllRadii ; radii];
    end

    subplot(1,2,1)
    imshow(frame);
    viscircles(centers, radii)
    title(['frame = ' num2str(n) ' / ' num2str(v.NumFrames)]);

    subplot(1,2,2)
    if n <= lookbackframe
%         disp('not enough time')
        hist(AllRadii*scale, histxbins)
        xlabel('Bubble Radius [\mu m]')
        ylabel('Bubble Counts')
        title(['Bubble Num = ' num2str(numel(AllRadii))])
    else
        last = numel(bubblenumperframe);
        lastradii = numel(AllRadii);
        lookbacknum = sum(bubblenumperframe(last-lookbackframe:last));
        hist(AllRadii(lastradii-lookbacknum:lastradii)*scale, histxbins)
%     imshow(BW)
        xlabel('Bubble Radius [\mu m]')
        ylabel('Bubble Counts')
        title(['Bubble Num = ' num2str(numel(AllRadii(lastradii-lookbacknum:lastradii)))])
    end
    drawnow

end
