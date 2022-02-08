function traveled_distance = ScatteredDecision(aDec, pathlength, FwProbScat)
%Particle is absobed
if aDec == 0
    traveled_distance = 0;
else
    %Particle is Scattered
    %Foward Scattered
    if FwProbScat > rand
        traveled_distance = pathlength;
    else
        %Backward Scattered
        traveled_distance = -pathlength;
    end
end
end

