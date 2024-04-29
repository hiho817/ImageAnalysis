close all
clear 

name = 'tiny-yolov4-coco';

videofilename = 'test_yolo.mp4';

v = VideoReader(videofilename);

detector = yolov4ObjectDetector(name);

threshold = [0.1,0.5,0.9];

outfile = 'HW05_109611112';
out_suffix = ['a','b','c'];
out_ext = '.mp4';


for i = 1:3
    v.CurrentTime = 0;
    outfilename = [outfile out_suffix(i) out_ext];
    out = VideoWriter(outfilename, "MPEG-4");
    open(out);
    while hasFrame(v)
        frame = readFrame(v);
        tic;
    
        [bboxes, scores, labels] = detect(detector, frame, 'threshold', threshold(i));
        elaspedtime = toc;
        annotedframe = insertObjectAnnotation(frame, 'rectangle', bboxes, labels);
    
        imshow(annotedframe)
        
        title(['Elasped time = ' num2str(elaspedtime) ' sec , threshold = ' num2str(threshold(i)) ]);
        drawnow
        
        f = getframe(gcf);
        [FF, junk] = frame2im(f);
        writeVideo(out, FF);
    end
    close(out);
end