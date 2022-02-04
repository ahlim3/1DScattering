function traveled_distance = ScatteredDecision(aDec, pathlength, FwProbScat)
if aDec == 0
    traveled_distance = 0;
else
    if FwProbScat > rand
        traveled_distance = pathlength;
    else
        traveled_distance = -pathlength;
    end
end
end

