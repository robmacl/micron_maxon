function date = convUnixTimeSec(unix_time)

    date = datestr((unix_time)/86400 + datenum(1970,1,1)-4/24);

end