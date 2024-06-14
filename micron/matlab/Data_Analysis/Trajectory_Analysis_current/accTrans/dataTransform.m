function dataT = dataTransform(data, TR)
    %data: n x 3, TR: 4 x 4
%     pts = data;
%     if(size(TR,1) == 4 && size(TR,2) == 4)
%         pts(:,4) = 1;
%         pts2 = pts*TR';
%         
%         dataT = pts2(:,1:3);
%         
%     else
%         %3 x 3 case
%         center = mean(data);
%         pts = bsxfun(@minus, data, center);
%         pts2 = pts*TR';
%         dataT = bsxfun(@plus, pts2, center);
%     end
        
    if(size(TR,1) == 4 && size(TR,2) == 4)
        data(:,4) = 1;
    end
    dataT = data*TR';

    dataT = dataT(:,1:3);
    


end