function simTrajectory(data, data2, timing, type)


    if(nargin < 3)
        timing = 0.001;
    end
    if(nargin > 3 && strcmp(type,'pol'))
        pType = 2;
    else
        pType = 1;
    end

    if(~isempty(timerfindall))
        delete(timerfindall);
    end
   
    nLen = size(data,1);

    switch pType
        case 1
            figure, hold on,  grid on;
            daspect([1 1 1]);
            cut = 100;
            ratio = 0.1;
            maxLim = ceil(max(max(data),max(data2))/cut)*cut;
            minLim = floor(min(min(data),min(data2))/cut)*cut;
            sLim = (maxLim - minLim)*ratio;
            maxLim = maxLim + sLim;
            minLim = minLim -sLim;

            axis([minLim(1) maxLim(1) minLim(2) maxLim(2) minLim(3), maxLim(3)]);


            % axis([-1100 1100 -1100 1100 -1100 1100]);
            axis([-2100 2100 -2100 2100 -2100 2100]);

            h(1) = plot3(data(1,1),data(1,2),data(1,3),'r','LineWidth',2);
            h(2) = plot3(data2(:,1),data2(:,2),data2(:,3),'g','LineWidth',1);

            view(3);
            
        case 2
            [theta,rho] = cart2pol(data(:,1),data(:,2)) ;
            [theta2,rho2] = cart2pol(data2(:,1),data2(:,2)) ;
            
            pol_data = horzcat(theta, rho);
            pol_data2 = horzcat(theta2, rho2);
            
             t = 0 : .01 : 2 * pi;
             rlimit = max(2100, max(rho));
                       
             figure;
             P = polar(t, rlimit * ones(size(t)));
             set(P, 'Visible', 'off')
             hold on;
    
             
             h(1) = polar(pol_data(1,1),pol_data(1,2),'r');
            
             h(2) = polar(pol_data2(:,1),pol_data(:,2),'g');
             set(h(1),'LineWidth',2);
             set(h(2),'LineWidth',1);
    
    end
    
    animationTimer = timer('ExecutionMode','fixedRate',...  %# Fire at a fixed rate
        'Period',timing,...                %#   every 0.25 seconds
        'TasksToExecute',nLen,...          %#   for 40 times and
        'TimerFcn',{@timer_fcn h data data2});  %#   run this function
    tStart = tic;
    start(animationTimer);  %# Start timer, which runs on its own until it ends
    nPlot = 0;
    while(nPlot ~= nLen)
        nPlot = get(animationTimer,'TasksExecuted');
    end
    stop(animationTimer);
    
    tElapsed = toc(tStart);
    fprintf('Animation is done!: %.1f sec\n', tElapsed);
    %disp('Animation is done!');
    delete(animationTimer);
    hold off;
    
    

%     axis equal;
%     grid on;
%     daspect([1 1 1]);
%     cut = 100;
%     ratio = 0.1;
%     maxLim = ceil(max(max(data),max(data2))/cut)*cut;
%     minLim = floor(min(min(data),min(data2))/cut)*cut;
%     sLim = (maxLim - minLim)*ratio;
%     maxLim = maxLim + sLim;
%     minLim = minLim -sLim;
%     
%     axis([minLim(1) maxLim(1) minLim(2) maxLim(2) minLim(3), maxLim(3)]);
%     view(3);
%     
%    % axis([-1100 1100 -1100 1100 -1100 1100]);
%     %axis([-2100 2100 -2100 2100 -2100 2100]);
%     


%     
%     animationTimer = timer('ExecutionMode','fixedRate',...  %# Fire at a fixed rate
%                        'Period',timing,...                %#   every 0.25 seconds
%                        'TasksToExecute',nLen,...          %#   for 40 times and
%                        'TimerFcn',{@timer_fcn h data data2});  %#   run this function
%    tStart = tic;
%     start(animationTimer);  %# Start timer, which runs on its own until it ends
%     nPlot = 0;
%     while(nPlot ~= nLen)
%         nPlot = get(animationTimer,'TasksExecuted');    
%     end
%     stop(animationTimer);
%     
%     tElapsed = toc(tStart);
%     fprintf('Animation is done!: %.1f sec\n', tElapsed);
%     %disp('Animation is done!');
%     delete(animationTimer);
%     hold off;
    
    
    
    
    
    
end