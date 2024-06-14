function [dist, idx, time] = loadOCTSurf()
    
    [filename, pathname]=uigetfile({'*.csv';'*.txt';'*.*'},'OCT surface profile(*.csv)',...
        'MultiSelect','off' );
    
    file = [pathname filename];
    %data = csvread(filename); %after change data as column
    data = importdata(file);
    
    dist = data.data(:,2);
    idx = data.data(:,1);
    
    [token remain]= strtok(file,'.');
    new_file = strrep(token, 'Surfaces', 'TimeStamps');
    new_file = [new_file remain];
    
    time = importdata(new_file);
    
    
end