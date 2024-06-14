function [max3d  max2d max_sub] = calcMaxs(data_in, data_out)

    [nLen(1) nDim(1)] = size(data_in);
    [nLen(2) nDim(2)] = size(data_out);
    
    if(nLen(1)==nLen(2) &&  nDim(1)==nDim(2) )
        
        
        resid = data_out - data_in;
        sq = resid(:,1:nDim(1)).^2;
        dataNorm3d = sqrt(sum(sq,2));
        dataNorm2d = sqrt(sum(sq(:,1:2),2));

        max3d = max(dataNorm3d);
        max2d = max(dataNorm2d);
        max_sub = max(abs(resid),[],1);
        
        
    else
        disp('Length of data is not consisent!');
        max3d = -1; max2d = -1; max_sub = [-1 - 1 -1];
    end
    
    
end