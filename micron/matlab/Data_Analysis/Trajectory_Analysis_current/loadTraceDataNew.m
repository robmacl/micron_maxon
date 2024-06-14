function [goalPos tipPos TR error linkGoal] = loadTraceDataNew(file, options)

    addpath(genpath('accTrans'));
    TR = eye(3);
    trace_defs;
    
    %1. tipTrans, 2. eigTrans, 3. accTrans..
    Trs = [options.tipTransform, options.eigTransform, options.accTransform];
    TrType = find(Trs,true);
    
    
    if(options.decimate)
        data = read_bin_trace_offset(file,options.dec_by, [],options.iOffset);
    else
        data = read_bin_trace_offset(file, 1, [],options.iOffset );
    end
  
    chan = micron_goal_tip;
    goalPos.data = squeeze(data(:, :, chan));
    goalPos.offset = goalPos.data(1,1:3);
    goalPos.avg = mean(goalPos.data(:,1:3));

    
    chan = micron_position_tip;
    tipPos.data = squeeze(data(:, :, chan));
    tipPos.offset = tipPos.data(1,1:3);
    tipPos.avg = mean(tipPos.data(:,1:3));
    
    chan = micron_link_error_0;
    err0 = squeeze(data(:, :, chan));
    chan = micron_link_error_1;
    err1 = squeeze(data(:, :, chan));
    error = [err0 err1];
    
    chan = micron_link_goal_0;
    %chan = micron_drive_0;
    link0 = squeeze(data(:, :, chan));
    chan = micron_link_goal_1;
    %chan = micron_drive_1;
    link1 = squeeze(data(:, :, chan));
    linkGoal = [link0 link1];
    
    
    
    if(~isempty(TrType))
        switch TrType
            case 1 %w.r.t initTip
                 TR = tip_pose(data(1, :, :));
                 TR = inv(TR);

            case 2 %using eig
                tmpPos = bsxfun(@minus, goalPos.data,goalPos.avg);
                [~, ~,  TR]  = find_plane(tmpPos);
                

            case 3 %using acc..
%                 TransOpts.selType = 4; %top mount: 1 (xy matching 2), side mount:3 (xy matching 4)
%                 TransOpts.gNormal = true; %use gravity as surface normal, otherwise either use 'surface2.bin' or load a file
%                 TransOpts.center =  goalPos.avg;
%                 [Ts, accZn, accZn0] = getSurfTransform(file, options, TransOpts);

                TR = getSurfTransform(file, options);
        end
        if(options.relative)
            if(options.holdstill)
                 tipPos.data = bsxfun(@minus,tipPos.data,mean(tipPos.data(:,1:3)));
                 goalPos.data = repmat([0 0 0], length(goalPos.data),1);
            else
                 tipPos.data = bsxfun(@minus,tipPos.data,goalPos.avg);
                 goalPos.data = bsxfun(@minus,goalPos.data,goalPos.avg);
            end
           
        
            TR = TR(1:3,1:3);
        end
                 
        goalPos.data = dataTransform(goalPos.data, TR);
        tipPos.data = dataTransform(tipPos.data, TR);
        
        
        if(TrType == 2)
            [tipPos.data, goalPos.data] =...
                alignEigCoord(tipPos.data, goalPos.data);
        end
        
        if(options.holdstill)
            tipPos.data = bsxfun(@minus,tipPos.data,mean(tipPos.data(:,1:3)));
            goalPos.data = repmat([0 0 0], length(goalPos.data),1);
        end
        
        goalPos.offset = goalPos.data(1,1:3);
        goalPos.avg = mean(goalPos.data(:,1:3));
        
        tipPos.offset = tipPos.data(1,1:3);
        tipPos.avg = mean(tipPos.data(:,1:3));
        


    end

    

end