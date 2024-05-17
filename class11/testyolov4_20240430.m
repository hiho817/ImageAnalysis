% test trained yolov4 NN

videofilename = 'mesh_0mm_resize_600frame.mp4';
th = 0.1;
n=0;

v = VideoReader(videofilename);

figure('WindowState','maximized')
while hasFrame(v)
    n=n+1;
	frame = readFrame(v);
	[bboxes, scores, labels] = detect(trainedDetector, frame, 'Threshold', th);
	detected = insertObjectAnnotation(frame, 'rectangle', bboxes, labels);
	imshow(detected, 'InitialMagnification', 'fit')
    title(num2str(n))
	drawnow
	pause(0.1)
end
