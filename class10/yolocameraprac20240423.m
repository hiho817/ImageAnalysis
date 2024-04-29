close all
clear 

name = 'tiny-yolov4-coco';
% name = 'csp-darknet53-coco';
webcamname = 'USB2.0 HD UVC WebCam';

% videofilename = '20210913tennis.mp4';
% videofilename = 'RBC20240304.wmv';
% videofilename = '2022ichostreet.mp4';

% v = VideoReader(videofilename);

camera = webcam(webcamname);
detector = yolov4ObjectDetector(name);

while true
%     frame = readFrame(v);
    frame = camera.snapshot;
    tic;
    [bboxes scores labels] = detect(detector, frame, 'threshold', 0.5)
    elaspedtime = toc;
    annotedframe = insertObjectAnnotation(frame, 'rectangle', bboxes, labels);

%     subplot(1,3,1)
    imshow(annotedframe)

%     subplot(1,3,[2 3])
%     hist(labels)
    title(['Elasped time = ' num2str(elaspedtime) 'sec']);
    drawnow
end
