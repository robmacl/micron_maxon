function [xyz_dat offset avg T] = loadTraceData(file, chan, options)

    
    
    if(options.decimate)
        data = read_bin_trace(file,options.dec_by);
    else
        data = read_bin_trace(file, 1);
    end
  
    xyz_dat = squeeze(data(:, :, chan));
    xyz_dat(:,4,:) = 1;
    
    %plot3_data(dat, chan, 0, Inf, 0);
    %plot3_data(dat, chan, 1, Inf, 0);
    if(nargin>3)
        
    else
    end

    T = tip_pose(data(1, :, :));
    T = inv(T);
    if (options.transform)
     
      xyz_dat = xyz_dat * T';
    end
    
    xyz_dat = xyz_dat(:,1:3);
    
    offset = xyz_dat(1,1:3);
    avg = mean(xyz_dat(:,1:3));

end