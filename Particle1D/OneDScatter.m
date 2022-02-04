function OneDScatter(pathlength, absoprtion_probability, FwProbScat, n, depth)

arrayindexdepthnumber = int16(depth / pathlength);
locationindex = [];
depthindex = zeros(1,arrayindexdepthnumber);
particleterminationArray = [];
ExitParticle = 0;
InteractionArray = [];

for c = 1:n
    locationindex(end+1) = 0;
    locationindex(end+1) = pathlength;
    currentInteraction = 1;
    currentlocation = 0.5;
    aDec = AbsorptionDecision(absoprtion_probability);
    while aDec == 1
        traveled_distance = ScatteredDecision(aDec, pathlength, FwProbScat);
        currentlocation = currentlocation + traveled_distance;
        if currentlocation < 0
            break
        end
        if currentlocation > 10
            break
        end
        locationindex(end + 1) = currentlocation;
        aDec = AbsorptionDecision(absoprtion_probability);
        currentInteraction = currentInteraction + 1;
    end
    particleterminationArray(end+1) = currentlocation;
    InteractionArray(end + 1) = currentInteraction;
    if currentlocation < 0
        ExitParticle = ExitParticle + 1;
    elseif currentlocation > depth
        ExitParticle = ExitParticle + 1;
    end
end

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
ylim([0, 1.5 * n]); % Give some headroom above the bars.
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
sMean3 = sprintf('   Mean = %.3f cm \n   SD = %.3f cm \n   N Left Medium = %.0f', TerminationMu, TerminationSigma, ExitParticle);
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