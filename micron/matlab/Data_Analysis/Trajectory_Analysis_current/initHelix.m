function [X Y Z r] = initHelix(options)


    prompt = {'Enter diameter of workspace:'};
    dlg_title = 'Input for workspace diameter';
    num_lines = 1;
    def = {'2'};
    answer = inputdlg(prompt,dlg_title,num_lines,def);
    r = str2double(answer);
    
    [X,Y,Z] = cylinder(r,20);
    
    if(nargin < 1)
        options.scale = 0;
    end
    cScale = ((1-options.scale)*999 + 1)*ones(1,3);
    X = X*cScale(1);
    Y = Y*cScale(2);
    Z = 2*r*(Z-0.5)*cScale(3);
%     figure;
%     surf(X,Y,Z);
%     alpha(0.1);
end