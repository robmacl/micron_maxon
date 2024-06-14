function options = mapCtrl2Opts(hc)

    val2 = get(hc,'Value');
    chk = logical(cell2mat(val2));
    %chk = find([val2{:}],1);

    options.scale = chk(1); % 1. scale, false: um, true: mm
    options.decimate = chk(2);  % 2. decimate,
    options.plot = chk(3); % 3. plot
    options.simulation = chk(4); % 4. simulation
    options.save = chk(5); % 5. save

    options.tipTransform = chk(6); % 6. tipTransform
    options.eigTransform = chk(7); % 7. eigTransform
    options.accTransform = chk(8); % 8. accTransform.
    options.relative = chk(9); % 9. relative offset
    options.errPlot = chk(10); % 10. none %not yet

    options.dec_by = str2double(get(hc(11),'String')); % 11. decimate num.
    options.iOffset = str2double(get(hc(12),'String')); % 12. index offset

end