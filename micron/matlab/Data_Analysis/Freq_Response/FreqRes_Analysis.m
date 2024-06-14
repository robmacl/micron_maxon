clear all;
close all;
clc

[filename, pathname]=uigetfile({'*.xlsx';'*.dat';'*.*'},'EXCEL files(*.xlsx)');
file=[pathname filename];

endSheet = false;
[type, sheets] = xlsfinfo(file);

nData = size(sheets,2);

figure;
hold on;

for i=1:nData
    [data, headertext] = xlsread(file, sheets{i});
    if(i==1)
        sFreq = data(:,1);
        mag = zeros(size(data,1),nData);
        phase = zeros(size(data,1),nData);
    end
    %mag(:,i) = data(:,2);
    %phase(:,i) = data(:,4);
    semilogx(data(:,1),data(:,2));

end
hold off;
set(gca,'Xscale','log');
xlim([5 250]);
ylim([-10 10]);

