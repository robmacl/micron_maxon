function statusFlag = extractStatusFlag(status)

%  tStart = tic;
% flags = cellfun(@hex2bin2, status);
% statusFlag = cell2mat(flags);
%  tElapsed = toc(tStart);
%  disp(tElapsed);
 
    nStatus = length(status);
    nMaxFlag = 16;
    statusFlag = zeros(nStatus,nMaxFlag,'int8');
    tStart = tic;
    for i=1:nStatus

        dec = hex2dec(status{i});
        bin = dec2bin(dec);
        bin2 = bitget(dec,length(bin):-1:1);

        statusFlag (i,nMaxFlag-length(bin)+1:nMaxFlag) = bin2;

    end
    statusFlag = fliplr(statusFlag);
    tElapsed = toc(tStart);
    disp(tElapsed);
    
end