function OCTToI = setOCTToI(ToI, duration)

    micron_Fs = 1008.050;
        
    OCTToI = ToI;
    OCTToI(:,2) = ToI(:,1) + duration;
    OCTToI(:,4) = ToI(:,3) + floor(duration*micron_Fs);
    
end

