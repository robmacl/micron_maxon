function [xyz_dat offset avg Tt Ts] = loadTraceDataSub(data, ind)

    trace_defs;
    
    chan = micron_position_tip;
    
    xyz_dat = squeeze(data(ind(1):ind(2), :, chan));

    offset = xyz_dat(1,1:3);
    avg = mean(xyz_dat(:,1:3));
    
    %%
    Tt = tip_pose(data(ind(1), :, :));
    Tt = inv(Tt);



    %%
    %for accelerometer transform
    
    chan = micron_analog_data_0;
    adata = squeeze(data(ind(1):ind(2), :, chan));
    acc_data =adata(:,2:3); 

    chan = micron_analog_data_1;
    adata = squeeze(data(ind(1):ind(2), :, chan));
    acc_data(:,3) = adata(:,1); 

    %acc_offset = acc_data(1,:);
    acc_avg = mean(acc_data);
    
    TransOpts.selType = 4; %top mount: 1 (xy matching 2), side mount:3 (xy matching 4)
    TransOpts.gNormal = true; %use gravity as surface normal, otherwise either use 'surface2.bin' or load a file
    TransOpts.center = avg;
    
    Ts = getSurfTransform0(acc_avg, TransOpts);
    
    
end