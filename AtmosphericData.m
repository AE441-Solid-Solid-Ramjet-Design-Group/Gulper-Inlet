classdef AtmosphericData < handle
    % Contains atmospheric data
    % Data from: https://www.engineeringtoolbox.com/standard-atmosphere-d_604.html#gsc.tab=0

    properties (Access = private)
        altitude; % m
        temperature; % k
        gravity; % m/s/s
        absolutePressure; % N/m/m
        density; % kg/m/m/m
        dynamicViscosity; % Ns/m/m
        
        speedOfSound; % m/s

        gamma = getGamma("air");
        gasConstant = getGasConstant("air");
    end

    methods
        function obj = AtmosphericData()
            obj.altitude = [-1000 0 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 ... 
                15000 20000 25000 30000 40000 50000 60000 70000 80000];
            obj.temperature = [294.65 288.15 281.65 275.15 268.66 262.17 255.68 249.19 ...
                242.7 236.21 229.73 223.25 216.65 216.65 221.55 226.51 250.35 270.65 ...
                247.02 219.58 198.64];
            obj.gravity = [9.81 9.807 9.804 9.801 9.797 9.794 9.791 9.788 9.785 9.782 ...
                9.779 9.776 9.761 9.745 9.73 9.715 9.684 9.654 9.624 9.594 9.564];
            obj.absolutePressure = [11.39 10.13 8.988 7.95 7.012 6.166 5.405 4.722 4.111 ...
                3.565 3.08 2.65 1.211 0.5529 0.2549 0.1197 0.0287 0.007978 0.002196 ...
                0.00052 0.00011]*1e+4;
            obj.density = [1.347 1.225 1.112 1.007 0.9093 0.8194 0.7364 0.6601 0.59 0.5258 ...
                0.4671 0.4135 0.1948 0.08891 0.04008 0.01841 0.003996 0.001027 0.0003097 ...
                0.00008283 0.00001846];
            obj.dynamicViscosity = [1.821 1.789 1.758 1.726 1.694 1.661 1.628 1.595 1.561 ...
                1.527 1.493 1.458 1.422 1.422 1.448 1.475 1.601 1.704 1.584 1.438 1.321]*1e-5;

            obj.speedOfSound = calcSpeedOfSound(obj.gamma, obj.gasConstant, obj.temperature);
        end

        function temperature = calcTemperature(obj,altitude)
            obj.altitudeCheck(altitude);
            temperature = interp1(obj.altitude, obj.temperature, altitude);
        end

        function gravity = calcGravity(obj,altitude)
            obj.altitudeCheck(altitude);
            gravity = interp1(obj.altitude, obj.gravity, altitude);
        end

        function absolutePressure = calcAbsolutePressure(obj,altitude)
            obj.altitudeCheck(altitude);
            absolutePressure = interp1(obj.altitude, obj.absolutePressure, altitude);
        end

        function density = calcDensity(obj,altitude)
            obj.altitudeCheck(altitude);
            density = interp1(obj.altitude, obj.density, altitude);
        end

        function dynamicViscosity = calcDynamicViscosity(obj,altitude)
            obj.altitudeCheck(altitude);
            dynamicViscosity = interp1(obj.altitude, obj.dynamicViscosity, altitude);
        end

        function speedOfSound = calcSpeedOfSound(obj,altitude)
            obj.altitudeCheck(altitude);
            speedOfSound = interp1(obj.altitude, obj.speedOfSound, altitude);
        end

        function gamma = getGamma(obj)
            gamma = obj.gamma;
        end
        
        function gasConstant = getGasConstant(obj)
            gasConstant = obj.gasConstant;
        end
    end

    methods (Access = private)
        function altitudeCheck(obj,altitude)
            if altitude < obj.altitude(1) || altitude > obj.altitude(end)
                error("Invalid altitude");
            end
        end
    end
end