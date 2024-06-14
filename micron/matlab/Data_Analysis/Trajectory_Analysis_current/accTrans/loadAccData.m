function [acc_data, acc_offset, acc_avg] = loadAccData(file, options)
    trace_defs;
    
    chan = micron_analog_data_0;
    [data, offset, avg] = loadTraceData(file, chan, options);
    acc_data =data(:,2:3); 
    acc_offset = offset(:,2:3);
    acc_avg = avg(:,2:3);
    
    chan = micron_analog_data_1;
    [data, offset, avg] = loadTraceData(file, chan, options);
    acc_data(:,3) =data(:,1);
    acc_offset(:,3) = offset(:,1);
    acc_avg(:,3) = avg(:,1);


end