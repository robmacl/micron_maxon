function [RMSE_3d, RMSE_2d, RMSE_sub]=my_RMSE(data_in, data_out)

    [nLen(1) nDim(1)] = size(data_in);
    [nLen(2) nDim(2)] = size(data_out);
    if(nLen(1)==nLen(2) &&  nDim(1)==nDim(2) )
        
        
        resid = data_out - data_in;
        sq = resid(:,1:nDim(1)).^2;

        RMSE_sub = sqrt(sum(sq,1)/nLen(1));
        RMSE_3d = sqrt(sum(sum(sq,2))/nLen(1));
        RMSE_2d = sqrt(sum(sum(sq(:,1:2),2))/nLen(1));
        
        
    else
        disp('Length of data is not consisent!');
        res = -1;
    end

end