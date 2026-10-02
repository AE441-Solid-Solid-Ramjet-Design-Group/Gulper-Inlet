classdef FlowRelations
    % Isoentropic flow relations
    % Source: https://www.grc.nasa.gov/www/k-12/airplane/isentrop.html

    properties
        Property1
    end

    methods (Static)
        function pressureRatio = calcPressureRatio(mach, gamma)
        %CALCPRESSURERATIO Calculates the pressure ratio based on flow characteristics.
        %   pressureRatio = CALCPRESSURERATIO(mach, gamma) returns the static to stagnation pressure ratio.
        %
        %   Input Arguments:
        %       mach - (Scalar, double) Mach number.
        %       gamma - (Scalar, double) Adiabatic index.
        %
        %   Output Arguments:
        %       pressureRatio - (Scalar, double) Static to stagnation pressure ratio.
            pressureRatio = (1 + (gamma-1)/2*mach*mach)^(-gamma/(gamma-1));
        end

        function temperatureRatio = calcTemperatureRatio(mach, gamma)
        %CALCTEMPERATURERATIO Calculates the temperature ratio based on flow characteristics.
        %   temperatureRatio = CALCTEMPERATURERATIO(mach, gamma) returns the static to stagnation temperature ratio.
        %
        %   Input Arguments:
        %       mach - (Scalar, double) Mach number.
        %       gamma - (Scalar, double) Adiabatic index.
        %
        %   Output Arguments:
        %       temperatureRatio - (Scalar, double) Static to stagnation temperature ratio.
            temperatureRatio = (1 + (gamma-1)/2*mach*mach)^(-1);
        end

        function densityRatio = calcDensityRatio(mach, gamma)
        %CALCDENSTIYRATIO Calculates the density ratio based on flow characteristics.
        %   densityRatio = CALCDENSITYRATIO(mach, gamma) returns the static to stagnation density ratio.
        %
        %   Input Arguments:
        %       mach - (Scalar, double) Mach number.
        %       gamma - (Scalar, double) Adiabatic index.
        %
        %   Output Arguments:
        %       densityRatio - (Scalar, double) Static to stagnation density ratio.
            densityRatio = (1 + (gamma-1)/2*mach*mach)^(-1/(gamma-1));
        end
    end
end