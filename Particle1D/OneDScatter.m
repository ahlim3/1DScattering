function OneDScatter(pathlength, absoprtion_probability, FwProbScat, n, depth)

arrayindexdepthnumber = int16(depth / pathlength);
locationindex = [];
depthindex = zeros(1,arrayindexdepthnumber);
particleterminationArray = [];
FWScatterdParticle = 0;
BWScatteredParticle = 0;
AbsorptionCount = 0;
InteractionArray = [];

for c = 1:n
    %describing the particle enetering the medium
    locationindex(end+1) = 0;
    %first interaction occur nomatter what with pathlength
    locationindex(end+1) = pathlength;
    %Number of interaction is 1
    currentInteraction = 1;
    %Again first interaction location is at the pathlength
    currentlocation = pathlength;
    %Establishing boolean that absorption or scattering occur
    aDec = AbsorptionDecision(absoprtion_probability);
    %If scattering occur particle path continues
    if aDec == 0
        AbsorptionCount = AbsorptionCount + 1;
    end
    while aDec == 1
        %Estimating the path that particle will take for next interaction
        traveled_distance = ScatteredDecision(aDec, pathlength, FwProbScat);
        %Location that particle will be present at the next interaction
        currentlocation = currentlocation + traveled_distance;
        %Particle is backscattered
        if currentlocation < 0
            currentlocation = 0;
            BWScatteredParticle = BWScatteredParticle + 1;
            break
        end
        %Particle is fowardscattered
        if currentlocation > depth
            currentlocation = depth;
            FWScatterdParticle = FWScatterdParticle + 1;
            break
        end
        %Recording the path that particle is taking
        locationindex(end + 1) = currentlocation;
        %Defining the particle is absorbed or scattered
        aDec = AbsorptionDecision(absoprtion_probability);
        if aDec == 0
            AbsorptionCount = AbsorptionCount + 1;
        end
        %Interaction of particle is increased by 1
        currentInteraction = currentInteraction + 1;
    end
    %The location that particle is terminated
    particleterminationArray(end+1) = currentlocation;
    %Registering the total number of interaction that particle
    InteractionArray(end + 1) = currentInteraction;
end

PrbAbs = AbsorptionCount / n
FwScatPRob = FWScatterdParticle / n
BwScatPRob = BWScatteredParticle / n

binnumber = int16(max(locationindex) / pathlength);
figure(1)
histogram(locationindex,binnumber,"BinWidth",pathlength)
grid on;
xlabel('Depth in Medium (cm)', 'FontSize', 15);
ylabel('Count', 'FontSize', 15);
LocationIndexMu = mean(locationindex)
LocationIndexSigma = std(locationindex)
xline(LocationIndexMu, 'color', 'g', "LineWidth", 2);
xline(LocationIndexMu - LocationIndexSigma, 'color', 'r', 'LineWidth', 2, 'LineStyle', '--');
xline(LocationIndexMu + LocationIndexSigma, 'color', 'r', 'LineWidth', 2, 'LineStyle', '--');
ylim([0, 3.0 * n]); % Give some headroom above the bars.
yl = ylim;
sMean = sprintf('  Mean = %.3f cm \n   SD = %.3f cm ', LocationIndexMu, LocationIndexSigma);
text(binnumber * pathlength * 0.5, 0.9*yl(2), sMean, 'Color', 'r','FontWeight', 'bold', 'FontSize', 12, 'EdgeColor', 'b');
sMean2= sprintf('Interaction Count vs Depth in Medium. N = %.0f particles  Mean = %.3f. cm  SD = %.3f cm', n, LocationIndexMu, LocationIndexSigma);
title(sMean2, 'FontSize', 15);

figure(2)
histogram(particleterminationArray, binnumber + 1, "BinWidth",pathlength)
TerminationMu = mean(particleterminationArray);
TerminationSigma = std(particleterminationArray);
grid on;
xlabel('Depth in Medium (cm)', 'FontSize', 15);
ylabel('Count', 'FontSize', 15);
TerminationMu = mean(particleterminationArray)
TerminationSigma = std(particleterminationArray)
xline(TerminationMu, 'color', 'g', "LineWidth", 2);
xline(TerminationMu - TerminationSigma, 'color', 'r', 'LineWidth', 2, 'LineStyle', '--');
xline(TerminationMu + TerminationSigma, 'color', 'r', 'LineWidth', 2, 'LineStyle', '--');
ylim([0, 0.75 * n]); % Give some headroom above the bars.
yl = ylim;
sMean3 = sprintf('   Mean = %.3f cm \n   SD = %.3f cm \n', TerminationMu, TerminationSigma);
text(binnumber * pathlength * 0.5, 0.9*yl(2), sMean3, 'Color', 'r','FontWeight', 'bold', 'FontSize', 12, 'EdgeColor', 'b');
sMean4= sprintf('Interaction Count vs Particle Termiantion Location. N = %.0f particles  Mean = %.3f. cm  SD = %.3f cm', n, TerminationMu, TerminationSigma);
title(sMean4, 'FontSize', 15);

InteractionBin = int16(max(InteractionArray));
figure(3)
histogram(InteractionArray, InteractionBin)
InteractionMu = mean(InteractionArray);
InteractionSigma = std(InteractionArray);
grid on;
xlabel('Interaction per Particle', 'FontSize', 15);
ylabel('Particle Count', 'FontSize', 15);
InteractionMu = mean(InteractionArray)
InteractionSigma = std(InteractionArray)
xline(InteractionMu, 'color', 'g', "LineWidth", 2);
xline(InteractionMu - InteractionSigma, 'color', 'r', 'LineWidth', 2, 'LineStyle', '--');
xline(InteractionMu + InteractionSigma, 'color', 'r', 'LineWidth', 2, 'LineStyle', '--');
ylim([0, n]); % Give some headroom above the bars.
yl = ylim;
sMean5 = sprintf('  Mean = %.3f interactions \n   SD = %.3f interactions ', InteractionMu, InteractionSigma);
text(0.5 * InteractionBin, 0.9*yl(2), sMean5, 'Color', 'r','FontWeight', 'bold', 'FontSize', 12, 'EdgeColor', 'b');
sMean6= sprintf('Particle Count vs Interaction per particle N = %.0f particles  Mean = %.3f.  SD = %.3f', n, InteractionMu, InteractionSigma);
title(sMean6, 'FontSize', 15);

end