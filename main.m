%% 
% This code uses isentropic flow relations to simulate gulper inlet
% Made by: Shepard Summers
%
% Assumptions: 
%   adiabatic, isoentropic flow
%   calorically perfect gas
%
% Things not accounted for:
%   expansion fans
%   boundary layer interaction
%% 
clear; clc;
close all;
%%
import IsoentropicUtil.*
%%
% Input Variables
mach = 5;
altitude = 20000; % km
halfAngleNoseCone = 12.5; % deg
massFlowRate = 14; % kg/s
desiredMach = 0.25;

% Atmosphere setup
atmosphere = AtmosphericData();
freestream = struct( ...
    'stagnationPressure', NaN, ...
    'staticPressure', NaN, ...
    'staticTemperature', NaN, ...
    'density', NaN, ...
    'mach', NaN);
freestream.staticPressure = atmosphere.calcAbsolutePressure(altitude);
freestream.staticTemperature = atmosphere.calcTemperature(altitude);
freestream.density = atmosphere.calcDensity(altitude);
freestream.mach = mach;
freestream.stagnationPressure = calcStagnationPressureFromPM(freestream.staticPressure,freestream.mach,atmosphere.getGamma);

gamma = atmosphere.getGamma();

shocks(1) = Shock(halfAngleNoseCone,freestream.mach,gamma,false);
inletAir = struct( ...
    'stagnationPressure', [freestream.stagnationPressure freestream.stagnationPressure*shocks(1).stagnationPressureRatio], ...
    'staticPressure', [freestream.staticPressure freestream.staticPressure*shocks(1).staticPressureRatio], ...
    'staticTemperature', [freestream.staticTemperature freestream.staticTemperature*shocks(1).staticTemperatureRatio], ...
    'density', [freestream.density freestream.density*shocks(1).densityRatio], ...
    'mach', [freestream.mach shocks(1).downstreamMach]);
i = 2;
while inletAir.mach(i) > 1
    shocks(i) = Shock(shocks(i-1).normalMach,shocks(i-1).downstreamMach,gamma,true);
    inletAir.stagnationPressure(i+1) = inletAir.stagnationPressure(i)*shocks(i).stagnationPressureRatio;
    inletAir.staticPressure(i+1) = inletAir.staticPressure(i)*shocks(i).staticPressureRatio;
    inletAir.staticTemperature(i+1) = inletAir.staticTemperature(i)*shocks(i).staticTemperatureRatio;
    inletAir.density(i+1) = inletAir.density(i)*shocks(i).densityRatio;
    inletAir.mach(i+1) = shocks(i).downstreamMach;
    i = i + 1;
end


subsonicStagnationPressure = inletAir.staticPressure(end)/FlowRelations.calcPressureRatio(inletAir.mach(end),gamma);
subsonicStagnationTemperature = inletAir.staticTemperature(end)/FlowRelations.calcTemperatureRatio(inletAir.mach(end),gamma);
subsonicStagnationDensity = inletAir.density(end)/FlowRelations.calcDensityRatio(inletAir.mach(end),gamma);

endingPressure = subsonicStagnationPressure*FlowRelations.calcPressureRatio(desiredMach,gamma);
endingTemperature = subsonicStagnationTemperature*FlowRelations.calcTemperatureRatio(desiredMach,gamma);
endingDensity = subsonicStagnationDensity*FlowRelations.calcDensityRatio(desiredMach,gamma);

inletAir.stagnationPressure(end+1) = subsonicStagnationPressure;
inletAir.staticPressure(end+1) = endingPressure;
inletAir.staticTemperature(end+1) = endingTemperature;
inletAir.density(end+1) = endingDensity;
inletAir.mach(end+1) = desiredMach;

effeciency = 1;
for i = 1:length(shocks)
    effeciency = effeciency * shocks(i).stagnationPressureRatio;
end
effeciency

disp(inletAir)