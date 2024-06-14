function [filename, pathname, nFiles] = getMultiBinFiles(varargin)

    rmpath('accTrans');
    bpath = path;
    
    [bpath remain] = strtok(bpath,';');
   
    bpath = [bpath '\'];


    if(nargin>1)
        pathname = varargin{1};
    else
        try
            pathname = evalin('base','pathname');
        catch
            try
               pathname = fileread([bpath 'pathname.txt']); 
            catch 
               pathname = []; 
            end
       
            
        end
    end

   [filename, pathname]=uigetfile({'*.bin';'*.dat';'*.*'},...
       'BIN files(*.bin)','MultiSelect','on', pathname);
   

    
    if(iscell(filename))
        nFiles = length(filename);
    else
        if(~filename)
            nFiles = 0;
            error('Please Select Files!');
            %errordlg('Please Select Files!')
            %return;
        else
            nFiles = 1;
            filename = {filename};
        end
       
    end
    
    if(nFiles)
        fileID = fopen([bpath 'pathname.txt'],'w');
        fprintf(fileID,'%s',pathname);
        fclose(fileID);
    end
    

end
