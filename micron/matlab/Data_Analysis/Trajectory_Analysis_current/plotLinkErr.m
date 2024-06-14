function plotLinkErr(err, goal_in, options)

    theta = (atan2(goal_in(:,2), goal_in(:,1)))*180/pi;
    idx = find(theta<0);
    theta(idx) = 360+theta(idx);
    
    figure;
    if(options.selTrace == 2) %circle
        h = plot(theta, err);
        
        set(gca,'XTick',0:30:360)
        title('Link Error');
        xlabel('Degree');
    else
        h = plot(err);
        xlabel('Num. Seq.');
    end
    legend({'Link0', 'Link1','Link2','Link3','Link4','Link5'});
    title('Link Errors');
    grid on;
    
end