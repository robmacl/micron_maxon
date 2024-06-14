function dataT = dataTransform(data, TR)
    %data: n x 3, TR: 4 x 4
    pts = data;
    if(size(TR,1) == 4 && size(TR,2) == 4)
        pts(:,4) = 1;
    else
        %3 x 3 case
        center = mean(data);
        pts = bsxfun(@minus, data, center);
        
    end
        
    
    pts2 = pts*TR';
    
    dataT = pts2(:,1:3);

end