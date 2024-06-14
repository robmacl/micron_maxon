% path = cd(cd('..'));
% path = [path '\common\'];
% addpath(genpath(path));
addpath('acc_transform');

clear all; close all; clc
trace_defs;

options.scale = false; %Scale to mm from um
options.decimate = false;
options.dec_by = 10;
options.transform = false;
options.offset = false;
options.errPlot = false;
options.simulation = false;

TransOpts.selType = 4; %top mount: 1 (xy matching 2), side mount:3 (xy matching 4)
TransOpts.gNormal = true; %use gravity as surface normal, otherwise either use 'surface2.bin' or load a file

[filename, pathname]=uigetfile({'*.bin';'*.dat';'*.*'},'Tip BIN files(*.bin)', 'MultiSelect','on' );

if(iscell(filename))
    nFiles = length(filename);
else
    nFiles = 1;
    filename = {filename};
end
chan = micron_position_tip;

data = cell(nFiles,3); %ASAP, Tip, Surface.. 
tipTrans = cell(nFiles,1);
surfTrans = cell(nFiles,1);

for i=1:nFiles
     file = [pathname filename{i}];
     [xyz_data, offset, avg, Tt] = loadTraceData(file, chan, options);
     data{i,1} = xyz_data;
     
     tipTrans{i} = Tt;
     dataTp = dataTransform(xyz_data, Tt);
     data{i,2} = dataTp;
     
     TransOpts.center = avg;
     [Ts, accZn, accZn0] = getSurfTransform(file, options, TransOpts);
     surfTrans{i} = Ts;
     dataTs = dataTransform(xyz_data, Ts);
     data{i,3} = dataTs;
     
     
end

%Data processing...
for i=1:nFiles
    %load data..
    dataA = data{i,1};
    dataA = bsxfun(@minus, dataA, mean(dataA));
         
    dataTp = data{i,2};
    dataTp = bsxfun(@minus, dataTp, mean(dataTp));
    
    dataTs = data{i,3};
    
    RMSE_z= norm(dataTs(:,3))/sqrt(length(dataTs(:,3)));
    MAX_z = max(abs(dataTs(:,3)));
    task = strtok(filename{i},'.');
    
    fprintf('%s\tRMSE_z: %.f\tMAX_z: %.f um\n', task, RMSE_z, MAX_z);
end
%%
%plot data
for i=1:nFiles
    %load data..
    dataA = data{i,1};
    dataA = bsxfun(@minus, dataA, mean(dataA));
         
    dataTp = data{i,2};
    dataTp = bsxfun(@minus, dataTp, mean(dataTp));
    
    dataTs = data{i,3};
    
    %plot data...
     figure(i); daspect([1 1 1]); hold on;

     %h(1) = plot3(dataA(:,1), dataA(:,2), dataA(:,3),'r');
     %%match figures;
     Ra = AxisAngle2Rot([0 0 1 -pi/2]);
     dataA2 = dataTransform( data{i,1}, Ra);
     h(1) = plot3(dataA2(:,1), dataA2(:,2), dataA2(:,3),'r');
     
     %h(2) = plot3(dataTp(:,1), dataTp(:,2), dataTp(:,3),'g');
     h(2) = plot3(dataTp(:,2), +dataTp(:,1), -dataTp(:,3),'g');
     
     h(3) = plot3(dataTs(:,1), dataTs(:,2), dataTs(:,3),'b');
     
     %set(h(1),'LineStyle','none')
     %set(h(2),'LineStyle','none')
     %set(h(2),'LineStyle','-')
    
     legend(h,{'ASAP', 'Tip', 'Surface'});
     grid on; hold off; view(3);
     xlabel('x (\mum)'); ylabel('y (\mum)'); zlabel('z (\mum)');
     title(filename{i});
     

end



