function Tasks = loadToIs2(timeStamp, statusFlag, duration)

    [filename, pathname, filterIndex]=uigetfile({'*.csv';'*.txt';'*.*'},'OCT referece files(*.csv)',...
         'MultiSelect','on' );
 
    
    if(iscell(filename))
        nToI = length(filename);
    else
        nToI = 1;
        filename = {filename};
    end
    
    micron_Fs = 1008.05;
        
    if(nargin < 3)
        setDuration = false;
    else
        nInd = floor(micron_Fs*duration);
        setDuration = true;
    end
    
    cancellationFlag = statusFlag(:,1);
    goalFilerFlag = statusFlag(:,2);


    %ToIs = zeros(nToI, 5);
    Tasks = cell(nToI, 6);
    for i = 1:nToI
        
        file = [pathname filename{i}];

        [~, remain] = strtok(filename{i}, '_');
       
        if(isempty(remain))
            target = filename{i};
        else
            target = remain;
        end
        task = strtok(target, '.');
        if(length(task)>1), task(1) = []; end
        %fprintf('Task %d: %s\n',i, task);
    
        if(filterIndex == 1) %..csv
            %data = csvread(file)';
            data = csvread(file); %after change data as column
            ToI = [data(1), data(length(data))];
        elseif(filterIndex == 2)%..txt
            oct_ref = importdata(file, ',', 1);
            ToI = [oct_ref.data(3) oct_ref.data(4)];
        else
            error('inappropriate file format');
        end

 
        ToI = deciFloor(ToI,3);

        iStart = find(timeStamp==ToI(1));
        if(isempty(iStart))
            dist = (timeStamp - ToI(1)).^2;
            [minDist, iStart] = min(dist(:));
            %disp('find min ditance for starting index');
            fprintf('find min ditance for starting index: %.5f\n',minDist);
            
            if(sqrt(minDist) > 0.001 )
                %iStart = [];
               % error('Cannot find corresponding iStart');
                task = 'not match with ltrace file';
            end
        end
        
        if(setDuration)
            iEnd = iStart(1) + nInd;
            ToI(2) = timeStamp(iEnd);
            %ToI(2) = ToI(1) + duration;
            
        else
            iEnd = find(timeStamp==ToI(2));
            if(isempty(iEnd))
                dist = (timeStamp - ToI(2)).^2;
                [minDist, iEnd] = min(dist(:));
                %disp('find min ditance for ending index');
                fprintf('find min ditance for ending index: %.5f\n',minDist);
                if(sqrt(minDist) > 0.001 )
                    %iEnd = [];
                    %error('Cannot find corresponding iEnd');
                    task = 'not match with ltrace file';
                end
                
            end

        end
        %assert(~isempty(iEnd(1)), 'Cannot find correspoind indices');
        
        
        ind = [iStart(1) iEnd(1)];

        totalTime = ToI(2) - ToI(1); %...in seconds
        %fprintf('Testing Time: %.1f sec\n',totalTime);
        

        Tasks{i,1} = task; %from file name..
        
        %from status flag
        cancel = sum(cancellationFlag(ind));
        filter = sum(goalFilerFlag(ind));
        if(cancel ==2)
            if(filter ==2)
                flag_task = 'Scaling';
            elseif(filter ==1)
                flag_task = 'Change on scaling';
            else
                flag_task = 'Lowpass';
            end
        elseif(cancel ==1)
            flag_task = 'Change on lowpass';
        else
            flag_task = 'Off';
        end
        Tasks{i,2} = flag_task;
        
        Tasks{i,3} = ToI;
        Tasks{i,4} = ind;
        Tasks{i,5} = totalTime;
        Tasks{i,6} = convUnixTimeSec(ToI(1));
%         [token, ~] = strtok(filename{i}, 'T');
%         token(1:6)=[]; token(length(token))=[];
%         Tasks{i,5} = token;
%         
        fprintf('flag_Task %d: %s\n',i, flag_task);
        
    end
    
    
end