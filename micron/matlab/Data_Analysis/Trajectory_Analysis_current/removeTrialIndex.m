function sFileNameNew = removeTrialIndex(filename, rc)

    if(nargin <2)
        rc = '_';
    end
    sFileName = strtok(filename,'.');
    remain = sFileName; idx = 0;
    while true
        [ch, remain] = strtok(remain, rc);
        if isempty(ch),  break;  end
        idx = idx + 1;
        cha{idx}=remain;
    end
    if(idx >=2)
        sFileNameNew = strrep(sFileName, cha{idx-1}, '');
    end
   
    
end