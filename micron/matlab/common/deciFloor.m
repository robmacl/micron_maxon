function round_x = deciFloor(x,dec)
    round_x = floor(x * 10^dec) / 10^dec;
end