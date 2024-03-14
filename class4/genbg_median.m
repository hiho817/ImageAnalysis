function bg = genbg_median(vfile)
    n = 0;
    vv = VideoReader(vfile);
    
    AllFrames = read(vv);
    disp('Complete reading all frames!')
    [row col ch frameN] = size(AllFrames);
    for y = 1:row
        for x = 1: col
            for c = 1:ch
                bg(y,x,c) = median(AllFrames(y,x,c,:));
            end
        end
        disp(['progress ' num2str(y/row*100) '%']);
    end

%     bg = median(AllFrames);

end

