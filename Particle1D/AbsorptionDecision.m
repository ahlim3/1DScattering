function aDec = AbsorptionDecision(absoprtion_probability)
    if absoprtion_probability > rand
        aDec = 0; %Absorbed
    else
        aDec = 1; %Scattered
    end
end
