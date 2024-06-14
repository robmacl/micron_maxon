function res = calcMax(data)

    normData = sqrt(sum(data.^2,2));
    res = max(normData);
end