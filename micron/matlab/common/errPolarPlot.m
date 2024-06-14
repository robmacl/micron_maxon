function h = errPolarPlot(data, data2)

    
    s = data(:,1:2);
    rho= sqrt(sum(s.^2,2));
    
    s = data2(:,1:2);
    rho2= sqrt(sum(s.^2,2));
    theta2 = atan2(data2(:,2),data2(:,1));
    
    rlimit = max(max(rho),max(rho2));
    
    rlimit = ceil(rlimit/500)*500;
    
    figure;
    t = 0 : .01 : 2 * pi;
    %rlimit = 1000;
    P = polar(t, rlimit * ones(size(t)));
    set(P, 'Visible', 'off')
    hold on;
    
    
    
    theta = atan2(data(:,2),data(:,1));
    h(1) = polar(theta,rho,'r');
    set(h(1),'LineWidth',1);
    hold on;
    
    

    
    h(2) = polar(theta2,rho2,'g');
    set(h(2),'LineWidth',2);
    
    loc = [0.7 0.8 0.25 0.1];
    legend(h,'Tip position', 'Goal Tip','location',loc);
   
    pol_data = horzcat(theta, rho);
    pol_data2 = horzcat(theta2, rho2);
    
end