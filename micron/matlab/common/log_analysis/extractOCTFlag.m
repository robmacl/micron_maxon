function res = extractOCTFlag(flag_data, timeStamp)

    val = unique(flag_data);
    if(size(val,1) > 1 && val(2) == 1)
       shift = zeros(length(flag_data),1,'int32');
       shift(2:length(flag_data),1) = flag_data(1:length(flag_data)-1);
       detect = flag_data - shift;
       time = find(detect~=0);
       
       res = zeros(length(time)/2,4);
       
       for i =1:floor(length(time)/2)
           %ToI = [timeStamp(time(2*i-1)) timeStamp(time(2*i))];
           ind = [time(2*i-1), time(2*i)];
           %Inds(i,:) = ind;
           ToI =  [timeStamp(ind(1)) timeStamp(ind(2))];
           
           res(i,:) = [ToI, ind];
           
       end
    else
        res = [];
    end



end