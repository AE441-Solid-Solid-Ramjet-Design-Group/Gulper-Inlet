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
rocketDiameter = 0.638; % m

inletSegmentAngle = 100; % deg

% inletHeight = 0.25; % m
% toInletHeight = rocketDiameter/2 - inletHeight;
% inletArea = inletSegmentAngle/360*pi*((rocketDiameter/2)^2 - toInletHeight^2);

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

inlet = Inlet(12.5,rocketDiameter,massFlowRate, 0.25, freestream)