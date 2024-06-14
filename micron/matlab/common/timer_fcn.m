function timer_fcn(obj,event,h, data, data2 )
  n = get(obj,'TasksExecuted');               %# The number of times the
                                              %#   timer has fired already
  gData = data(1:n,:); %# Make a new ellipsoid
  tData = data2(1:n,:); %# Make a new ellipsoid
  
  set(h(1),'XData',gData(:,1),'YData',gData(:,2),'ZData',gData(:,3));   %# Update the mesh data
  set(h(2),'XData',tData(:,1),'YData',tData(:,2),'ZData',tData(:,3));   %# Update the mesh data
  drawnow;                                    %# Force the display to update
  %disp(n);
end