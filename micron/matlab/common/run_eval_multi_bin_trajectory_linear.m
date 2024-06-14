%% Multi bin files analysis..for circle trajectory..

clear all; close all;

trace_defs;

options.scale = false; %Scale to mm from um
options.decimate = true;
options.dec_by = 10;
options.transform = true;
options.offset = true;
options.errPlot = false;
options.simulation = false;

[filename, pathname]=uigetfile({'*.bin';'*.dat';'*.*'},'BIN files(*.bin)', 'MultiSelect','on' );

if(iscell(filename))
    nFiles = length(filename);
else
    nFiles = 1;
    filename = {filename};
end


for i=1:nFiles
    
    file=[pathname filename{i}];
    fprintf('%s\n', filename{i});
    
    chan = micron_position_tip;
    [tipPos offset avg] = loadTraceData(file, chan, options);
    
    if(i==1)
        nLen = length(tipPos);
        tipPosAll = zeros(nLen,3,nFiles);
        goalPosAll = zeros(nLen,3,nFiles);
    end
    chan = micron_goal_tip;
    [goalPos, offset2, avg2, T0] = loadTraceData(file, chan, options);
    
    if(options.transform)
        center = avg2;
        tipPosT0 = bsxfun(@minus,tipPos,center);
        goalPosT0 = bsxfun(@minus,goalPos,center);
        
    else
        T0(1:3,4) = -T0(1:3,1:3)*avg2';
        tipPosTmp = [tipPos ones(length(tipPos),1)];
        tipPosTmp = tipPosTmp*T0';
        tipPosT0 = tipPosTmp(:,1:3);
        
        goalPosTmp = [goalPos ones(length(goalPos),1)];
        goalPosTmp = goalPosTmp*T0';
        goalPosT0 = goalPosTmp(:,1:3);
    end
    goalPosC = avg2;
    tmpPos = bsxfun(@minus, goalPos,goalPosC);
    [normal, ~,  T]  = find_plane(tmpPos);
    
    
    tipPosT = bsxfun(@minus,tipPos,goalPosC);
    goalPosT = bsxfun(@minus,goalPos,goalPosC);
    tipPosT = tipPosT * T';
    goalPosT = goalPosT * T';
    
    
    %%
    th0 = atan2(goalPosT(1,2), goalPosT(1,1));
    T2 = eye(3);
    T2(1:2,1:2) = [cos(-th0) -sin(-th0);sin(-th0) cos(-th0)];
    
    goalPosT2 = goalPosT * T2';
    tipPosT2 = tipPosT * T2';
    
    thetaTest = atan2(goalPosT2(2,2), goalPosT2(2,1));
    
    if(thetaTest <0) %swap x &y vectors..
        
        goalPosT2 = goalPosT2(:,[2 1 3]);
        tipPosT2 = tipPosT2(:,[2 1 3]);
        
        th0 = atan2(goalPosT2(1,2), goalPosT2(1,1));
        T2 = eye(3);
        T2(1:2,1:2) = [cos(-th0) -sin(-th0);sin(-th0) cos(-th0)];
        
        goalPosT2 = goalPosT2 * T2';
        tipPosT2 = tipPosT2 * T2';
        
    end
    
    errPolarPlot(tipPosT0, goalPosT0);
%%
    tipPosAll(:,:,i) = tipPosT0;
    goalPosAll(:,:,i) = goalPosT0;
end

%% average
tipSum = zeros(nLen,3);
goalSum = zeros(nLen,3);
RMSEs= zeros(nFiles,5);
for i=1:nFiles
   tipSum = tipSum + tipPosAll(:,:,i);
   goalSum = goalSum + goalPosAll(:,:,i);
   [RMSE_3d, RMSE_2d, RMSE_sub]= my_RMSE(goalPosAll(:,:,i), tipPosAll(:,:,i));
   RMSEs(i,:) = [RMSE_3d  RMSE_2d RMSE_sub];
   
end
STD3d = std(RMSEs(:,1));
RMSE3d = mean(RMSEs(:,1));
fprintf('mean RMSE 3d: %.f, std RMSE 3d: %.f um\n',RMSE3d, STD3d);

tipAvg = tipSum/nFiles;
goalAvg = goalSum/nFiles;

data_in = goalAvg;
data_out = tipAvg;

errPolarPlot(data_out, data_in);
errPlot(data_out, data_in);

%%
theta = (atan2(data_in(:,2), data_in(:,1)))*180/pi;
idx = find(theta<0);
theta(idx) = 360+theta(idx);
error = sqrt(sum((data_in(:,1:2)-data_out(:,1:2)).^2,2));

step = 10;
thBin = floor(theta/step);
nBins = max(thBin(:))+1;
bins = 0:step:(nBins-1)*step; 
binVal = zeros(1,nBins);
for i=1:nBins
    val = (i-1);
    idx = find(thBin==val);
    binVal(i) = sum(error(idx));
end
figure;
bar(bins+step/2,binVal,1);
xlim([0 360]);


%%
[RMSE_3d, RMSE_2d, RMSE_sub]= my_RMSE(data_in, data_out);
fprintf('RMSE 3d: %.f um, RMSE 2d: %.f um\n',RMSE_3d, RMSE_2d);
fprintf('RMSE, x: %.f, y: %.f, z: %.f um\n',RMSE_sub(1,1:3));


