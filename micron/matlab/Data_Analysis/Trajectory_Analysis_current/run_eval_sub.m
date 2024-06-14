RMSEs= zeros(nFiles,5); %3d, 2d, x, y, z
%options = h.options;
for i=1:nFiles
    file=[pathname filename{i}];
    
    %[goalPos tipPos TR linkErr]  = loadTraceDataNew(file, options);
    [goalPos tipPos TR linkErr linkGoal] = loadTraceDataNew(file, options);

    
    
    if(i==1)
        nLen = length(tipPos.data);
        tipPosAll = zeros(nLen,3,nFiles);
        goalPosAll = zeros(nLen,3,nFiles);
        linkErrAll = zeros(nLen, 6, nFiles);
        linkGoalAll = zeros(nLen, 6, nFiles);
    end
    
    tipPosAll(:,:,i) = tipPos.data;
    goalPosAll(:,:,i) = goalPos.data;
    linkErrAll(:,:,i) = linkErr;
    linkGoalAll(:,:,i) = linkGoal;
   

    
   [RMSE_3d, RMSE_2d, RMSE_sub]= calcRMSEs(goalPosAll(:,:,i), tipPosAll(:,:,i));
   RMSEs(i,:) = [RMSE_3d  RMSE_2d RMSE_sub];
   %fprintf('%s, RMSE 3d: %.f\n', filename{i}, RMSE_3d);
   
   [max3d  max2d max_sub] = calcMaxs(goalPosAll(:,:,i), tipPosAll(:,:,i));
   %fprintf('%s, MAX 3d: %.f\n', filename{i}, max3d);  
   fprintf('%s, RMSE 3d: %f, MAX 3d: %.f\n', filename{i}, RMSE_3d, max3d);  
  
   
   
   
   if(options.holdstill)
       plotTrace(tipPos.data, goalPos.data); %..3d plot
   else
       plotPolarTrace(tipPos.data, goalPos.data); %2d polar plot
   end
end

%% average
goalAvg = mean(goalPosAll,3);
tipAvg = mean(tipPosAll,3);
linkErrAvg = mean(linkErrAll,3);
linkGoalAvg = mean(linkGoalAll,3);

%STD3d = std(RMSEs(:,1));
%RMSE3d = mean(RMSEs(:,1));

RMSEAll = mean(RMSEs,1);
STDAll = std(RMSEs,0,1);
MaxALL = max(RMSEs,[],1); %max of RMSE
MinALL = min(RMSEs,[],1); %min of RMSE

fprintf('all mean RMSE 3d: %.f, std RMSE 3d: %.f um\n',RMSEAll(1), STDAll(1));


[RMSE_3d, RMSE_2d, RMSE_sub]= calcRMSEs(goalAvg, tipAvg);
fprintf('avg RMSE 3d: %.f um, RMSE 2d: %.f um\n',RMSE_3d, RMSE_2d);
fprintf('avg RMSE, x: %.f, y: %.f, z: %.f um\n',RMSE_sub(1,1:3));

StatsAll = RMSEs;
avgStats = [RMSE_3d, RMSE_2d, RMSE_sub];
StatsAll = [StatsAll;RMSEAll;MaxALL;MinALL;STDAll;avgStats];

if(nFiles > 2)
    fName = removeTrialIndex(filename{end}, '_');
else
    fName = filename{end};
end

if(options.save)
    sFileName = [pathname fName '_Stats', '.dat'];
    
    save(sFileName, 'StatsAll', '-ascii');
    %[RMSEAll;
    %MaxALL;
    %MinALL;
    %STDAll;
    %avgStats];
end



%..2d polar plot
plotPolarTrace(tipAvg, goalAvg);
xlabel('X (\mum)'), ylabel('Y (\mum)')

if(options.save)
    sFileName = [pathname fName, '_polar' '.fig'];
    hgsave(gcf, sFileName);
end

% %..3d plot
switch options.comp
    case 'x'
        selCol = 1;
    case 'y'
        selCol = 2;
    case 'z'
        selCol = 3;
    case ''
        selCol = 1:3;
   
end


plotTrace(tipAvg(:,selCol), goalAvg(:,selCol), options);
% plotTrace(tipAvg, goalAvg);
% 
if(options.selTrace == HELIX)
    hold on;
    hh = surf(X,Y,Z);
    alpha(hh,0.1);
    hold off;
end



if(options.save)
    sFileName = [pathname fName, '.fig'];
    hgsave(gcf, sFileName);
end


%% error plot
if(options.errPlot)
    
  if(options.selTrace == 2) 
    cumulPosError(tipAvg, goalAvg);
  end
  plotLinkErr(linkGoalAvg, goalAvg, options);
  title('link goal');
  
  plotLinkErr(linkErrAvg, goalAvg, options);
  title('link error');
 
  if(options.save)
    sFileName = [pathname fName, '_linkErr' '.fig'];
    hgsave(gcf, sFileName);
   end
end 

%% simulation
if(options.simulation)
    micron_Fs = 2016.1/2;
    clear data_out data_in
    simDeci = 30;
    if(~options.decimate)
        dec_by = simDeci;
        for i = 1:3
            data_out(:,i) = decimate(tipAvg(:,i), dec_by)';
            data_in(:,i) = decimate(goalAvg(:,i), dec_by)';
        end
        timing = simDeci/micron_Fs;
    else
        if(options.dec_by < simDeci)
            dec_by = round(simDeci/options.dec_by);
            for i = 1:3
                data_out(:,i) = decimate(tipAvg(:,i), dec_by)';
                data_in(:,i) = decimate(goalAvg(:,i), dec_by)';
            end
            timing = simDeci/micron_Fs;
        else
             data_out = tipAvg; data_in = goalAvg;
             timing = options.dec_by/micron_Fs;
        end
    
    end
    timing = round(timing*1000)/1000;
    simTrajectory(data_out, data_in, timing);
    %simTrajectory(data_out, data_in, timing, 'pol');
end



