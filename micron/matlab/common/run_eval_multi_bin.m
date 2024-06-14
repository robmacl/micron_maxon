%% Multi bin files analysis..for point task or arbitrary trajectory..
clear all; close all;

trace_defs;

options.scale = false; %Scale to mm from um
options.decimate = false;
options.dec_by = 10;

options.transform = false;
options.offset = false;

options.plot = true;
options.simulation = false;


[filename, pathname]=uigetfile({'*.bin';'*.dat';'*.*'},'BIN files(*.bin)', 'MultiSelect','on' );

if(iscell(filename))
    nFiles = length(filename);
else
    nFiles = 1;
    filename = {filename};
end

RMSE_All = zeros(nFiles,4);
MAX_All = zeros(nFiles,4);

for i=1:nFiles
    fprintf('%s\n', filename{i});

    file=[pathname filename{i}];
    chan = micron_position_tip;
    [tipPos offset avg] = loadTraceData(file, chan, options);
 
    chan = micron_goal_tip;
    [goalPos] = loadTraceData(file, chan, options);
    
    if(options.offset)
        nLen = length(tipPos);
        data_out = tipPos - repmat(avg,nLen,1);  %tip positon
        data_in = repmat([0 0 0], nLen, 1);      %goal position
    else
        data_in = goalPos;
        data_out = tipPos;
    end
     

    [RMSE3d, RMSE2d, RMSE_sub]= calcRMSEs(data_in, data_out);

    fprintf('RMSE 3d: %.f um, RMSE 2d: %.f\n',RMSE3d, RMSE2d);
    fprintf('RMSE, x: %.f, y: %.f, z: %.f um\n',RMSE_sub(1), RMSE_sub(2), RMSE_sub(3));

    [max3d  max2d max_sub] = calcMaxs(data_in, data_out);
    fprintf('MAX 3d: %.f um, MAX 2d: %.f\n',max3d, max2d);
    fprintf('MAX, x: %.f, y: %.f, z: %.f um\n',max_sub(1), max_sub(2), max_sub(3));

    RMSE_All(i,1:3) = RMSE_sub;
    RMSE_All(i,4) = RMSE3d;


    MAX_All(i,1:3) = max_sub;
    MAX_All(i,4) = max3d;
 
    if(options.plot)
        errPolarPlot(data_out, data_in);
        errPlot(data_out, data_in);
    end
end






