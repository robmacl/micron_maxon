clear all;
close all;
clc

[filename, pathname]=uigetfile({'*.xlsx';'*.dat';'*.*'},'EXCEL files(*.xlsx)');
file=[pathname filename];

[type, sheets] = xlsfinfo(file);

%..find active sheets
nSheets = size(sheets,2);
if(size(sheets,2)==1)
    sheets = {sheets};
end


nDel = 0;
for i=1:nSheets
    id = i - nDel;
    data = xlsread(file, sheets{id},'A1:A5');
    if(isempty(data))
        sheets(id) = [];
        nDel = nDel + 1;
    end
end
nSheets = nSheets-nDel;


nData = nSheets;
%nData = 6;
phase = true;

if(phase)
    selCol = 4;
else
    selCol = 2;
end
%%

dataAll = cell(3,nData);
lNames = cell(1,nData);

for i=1:nData
    %figure(i);
    %hold on;
    figure;
    h1 = subplot(2,1,1);
    hold on;
    h2 = subplot(2,1,2);
    hold on;
    
    [data, headertext] = xlsread(file, sheets{i});
    nTrial = floor(size(data,2)/selCol);
    sFreq = data(:,1);
    
    dataAll{1,i} = zeros(length(sFreq),3);
    subMagAll = zeros(length(sFreq),nTrial);
    subPhiAll = zeros(length(sFreq),nTrial);
    

    valTrial = 0;
    stkFreq = [];

    for j=1:nTrial
        
        if(phase)
            magData = data(:,j*selCol-2);
            phiData = data(:,j*selCol);
        else
            magData = data(:,j*selCol);
            phiData = [];
        end

        nonValId  = isnan(magData);
        
        magData(nonValId)=[];
        phiData(nonValId) = [];
        
        if(length(magData) == length(sFreq))
            valTrial = valTrial + 1;
            subMagAll(:,valTrial) = magData;
            subPhiAll(:, valTrial) = phiData;
            
            stkFreq = [stkFreq;sFreq];
    
            subplot(h1);
            plot(sFreq,magData);
            subplot(h2);
            plot(sFreq,phiData);

            
        end
    end
    
    dataAll{1,i}(:,1) = sFreq;
    dataAll{1,i}(:,2) = mean(subMagAll,2);
    dataAll{1,i}(:,3) = mean(subPhiAll,2);
    dataAll{2,i}(:,1) = stkFreq;
    dataAll{2,i}(:,2) = reshape(subMagAll,[],1);
    dataAll{2,i}(:,3) = reshape(subPhiAll,[],1);
    dataAll{3,i} = valTrial;
    
    
    lNames{i} = strrep(sheets{i}, '_', ' ');
    
    title(lNames{i});
    hold off;
    set(h1,'Xscale','log', 'YGrid', 'on'); 
    set(h2,'Xscale','log', 'YGrid', 'on');
    
    
   
end


%% ..average

figure;
hold on;
cols = hsv(nData);
wLine = 2;
sm = 10;
for i=1:nData

    freq = dataAll{1,i}(:,1);
    data = dataAll{1,i}(:,2);
    
    hi1(i) = plot( freq,  data, 'Color',cols(i,:), 'LineWidth',wLine);
    scatter(freq,data, sm, cols(i,:),'o');
end
hold off;
legend(hi1,lNames, 'Location', 'SouthWest');
set(gca,'Xscale','log');
axis([1e0 1e2 -40 10]);
set(gca,'YGrid', 'on');

%%
%%..smoothing..
figure;
hold on;
cols = hsv(nData);
sm =10;
wLine = 2;


for i=1:nData


    %freq = dataAll{i}(:,1);
    %data = dataAll{i}(:,2);
    freq = dataAll{2,i}(:,1);
    data = dataAll{2,i}(:,2);
    nTrial = dataAll{3,i};
   
       
    scatter(freq,data, sm, cols(i,:),'o');
    
    %interpolate
%     xi = 1:5:100;
%     pp = interp1(freq, data,'cubic','pp');
%     yi = ppval(pp,xi);
%     ys = smooth(xi,yi,'lowess');
%     
%     hi(i) = plot(xi, ys, 'Color',cols(i,:), 'LineWidth',wLine);

    %smoothing
    ys = smooth(freq,data,0.1,'rloess');
    %ys = smooth(freq,data,0.1,'rlowess');
    idx = floor(length(freq)/nTrial);
    ys = reshape(ys, idx,[]);
    ys = mean(ys,2);
    freq = dataAll{1,i}(:,1);
    %freq = freq(1:idx);
    %ys = ys(1:idx);
    
    hi2(i) = plot(freq, ys, 'Color',cols(i,:), 'LineWidth',wLine);
    
    % 
%     p = 0.005;
%     ys = csaps(freq,data,p,freq); 
%     hi2(i) = plot(freq, ys, 'Color',cols(i,:), 'LineWidth',wLine);
  


end
hold off;
legend(hi2, lNames, 'Location', 'SouthWest');
set(gca,'Xscale','log');
axis([1e0 1e2 -40 10]);
set(gca,'YGrid', 'on');



%% ..both
fitOpt = 2;

h0 = figure;
h1 = subplot(2,1,1);
hold on;
h2 = subplot(2,1,2);
hold on;

hma = findall(h1,'type','axes');
hpa = findall(h2,'type','axes');
hall = findall(h0,'type','axes');


for i=1:length(hall)
    set(hall(i), 'FontSize',12);
    set(hall(i), 'FontName','Times New Roman');
end

ylabel(hma, 'Gain (dB)'); xlabel(hma, 'Frequnecy (Hz)');
ylabel(hpa, 'Phase (deg.)'); xlabel(hpa, 'Frequnecy (Hz)');




cols = hsv(nData);
sm =10;
wLine = 2;

for i=1:nData

    if(fitOpt == 2)
        freq = dataAll{2,i}(:,1);
        mag = dataAll{2,i}(:,2);
        phi = dataAll{2,i}(:,3);
        nTrial = dataAll{3,i};
        idx = floor(length(freq)/nTrial);
        
        %smoothing
        mags = smooth(freq,mag,0.1,'rloess');
        phis = smooth(freq,phi,0.5,'rloess');
%         freq = freq(1:idx);
%         mags = mags(1:idx);
%         phis = phis(1:idx);

        freq = dataAll{1,i}(:,1);
        mags = reshape(mags, idx,[]); mags = mean(mags,2);
        phis = reshape(phis, idx,[]); phis = mean(phis,2);

    

       
    
    
    elseif(fitOpt == 3)
        freq = dataAll{1,i}(:,1);
        mag = dataAll{1,i}(:,2);
        phi = dataAll{1,i}(:,3);
        p = 0.005;
        mags = csaps(freq,mag,p,freq);
        phis = csaps(freq,phi,p,freq);
    
    end
   
       

    
    subplot(h1);
    hm(i) = plot(freq, mags, 'Color',cols(i,:), 'LineWidth',wLine);
    
    subplot(h2);
    hp(i) = plot(freq, phis, 'Color',cols(i,:), 'LineWidth',wLine);


end
hold off;


set(hma,'Xscale','log'); set(hma,'YGrid', 'on');
set(hpa,'Xscale','log'); set(hpa,'YGrid', 'on');
ylim(hpa,[-180 180]);

%legend(hi2, lNames, 'Location', 'SouthWest');
legend(hma, lNames, 'Location', 'SouthWest');

% set(get(hma, 'Title'), 'String', 'Magitude');
% set(get(hpa, 'Title'), 'String', 'Phase');

% fontSize = 12;
% set(hma, 'FontSize',fontSize);
% set(hpa, 'FontSize',fontSize);
% set(get(hma,'XLabel'),'FontSize',fontSize);
% set(get(hma,'YLabel'),'FontSize',fontSize);
% 
% set(get(hpa,'XLabel'),'FontSize',fontSize);
% set(get(hpa,'YLabel'),'FontSize',fontSize);


