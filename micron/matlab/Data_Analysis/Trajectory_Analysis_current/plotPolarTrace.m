function [h pol_tipPos pol_goalPos] = plotPolarTrace(tipPos, goalPos)

    
    s = tipPos(:,1:2);
    rho= sqrt(sum(s.^2,2));
    
    s = goalPos(:,1:2);
    rho2= sqrt(sum(s.^2,2));
    theta2 = atan2(goalPos(:,2),goalPos(:,1));
    
    rlimit = max(max(rho),max(rho2));
    
    rlimit = ceil(rlimit/500)*500;
    
    figure;
    t = 0 : .01 : 2 * pi;
    %rlimit = 1000;
    P = polar(t, rlimit * ones(size(t)));
    set(P, 'Visible', 'off')
    hold on;
    
        
    h(2) = polar(theta2,rho2,'g');
    set(h(2),'LineWidth',2);
    
    
    theta = atan2(tipPos(:,2),tipPos(:,1));
    h(1) = polar(theta,rho,'r');
    set(h(1),'LineWidth',2);
    hold on;
    
    


    
    loc = [0.7 0.8 0.25 0.1];
    legend(h,'Tip Position', 'Goal Position','location',loc);
   
    pol_tipPos = horzcat(theta, rho);
    pol_goalPos = horzcat(theta2, rho2);
    xlabel('X (\mum)'), ylabel('Y (\mum)')
end