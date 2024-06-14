%% %Single bin file analysis..for point task or arbitrary trajectory..
%%
clear all; close all;

trace_defs;

options.scale = false; %Scale to mm from um
options.decimate = false;
options.dec_by = 10;

options.accTrans = false; %regarding gravity vector as surface normal..
options.transform = false; %w.r.t tip coordinate..
options.offset = false;

options.plot = true;
options.simulation = false;

TransOpts.selType = 4; %top mount: 1 (xy matching 2), side mount:3 (xy matching 4)
TransOpts.gNormal = true; %use gravity as surface normal, otherwise either use 'surface2.bin' or load a file

if(options.accTrans) %enforce the options.transform  to be false
    options.transform = false;
end

[filename, pathname]=uigetfile({'*.bin';'*.dat';'*.*'},'BIN files(*.bin)');

fprintf('%s\n', filename);

file=[pathname filename];
chan = micron_position_tip;
[tipPos offset avg] = loadTraceData(file, chan, options);
chan = micron_goal_tip;
[goalPos] = loadTraceData(file, chan, options);

if(options.accTrans)
    TransOpts.center = avg;
    [Ts, accZn, accZn0] = getSurfTransform(file, options, TransOpts);
    tipPos = dataTransform(tipPos, Ts);
    goalPos = dataTransform(goalPos, Ts);
end


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


if(options.plot)
    errPolarPlot(data_out, data_in);
    errPlot(data_out, data_in);
end

%Run simulation..
if(options.simulation)
    if(~options.decimate)
        dec_by = 10;
        for i = 1:3
            data_out_d(:,i) = decimate(data_out(:,i), dec_by)';
            data_in_d(:,i) = decimate(data_in(:,i), dec_by)';
        end
        timing = dec_by/micron_Fs;
    else   
        data_out_d = data_out; data_in_d = data_in;
        timing = options.dec_by/micron_Fs;
    end

    simTrajectory(data_out_d, data_in_d, timing);
end