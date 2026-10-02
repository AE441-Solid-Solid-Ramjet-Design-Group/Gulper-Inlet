classdef Normal
    % Normal shock equations
    % Source: https://www.grc.nasa.gov/www/k-12/airplane/normal.html

    methods (Static)
        function downstreamMach = calcDownstreamMach(upstreamMach, gamma)
        %CALCDOWNSTREAMMACH Calculates the downstream mach number based on upstream characteristics.
        %   downstreamMach = CALCDOWNSTREAMMACH(upstreamMach, gamma) returns the downstream mach number.
        %
        %   Input Arguments:
        %       upstreamMach - (Scalar, double) Upstream mach number.
        %       gamma - (Scalar, double) Adiabatic index.
        %
        %   Output Arguments:
        %       downstreamMach - (Scalar, double) Downstream mach number.
            machSq = upstreamMach.^2;
            downstreamMach = sqrt( ...
                ((gamma-1)*machSq+2) ...
                / (2*gamma*machSq - (gamma - 1)) ... 
                );
        end

        function stagnationPressureRatio = calcStagnationPressureRatio(mach, gamma)
        %CALCSTAGNATIONPRESSURERATIO Calculates the stagnation pressure ratio based on upstream characteristics.
        %   stagnationPressureRatio = CALCSTAGNATIONPRESSURERATIO(mach, gamma) returns the stagnation pressure ratio.
        %
        %   Input Arguments:
        %       mach - (Scalar, double) Upstream mach number.
        %       gamma - (Scalar, double) Adiabatic index.
        %
        %   Output Arguments:
        %       stagnationPressureRatio - (Scalar, double) Stagnation pressure ratio.
            machSq = mach.^2;
            stagnationPressureRatio = ( (gamma + 1) * machSq / ((gamma - 1)*machSq+2) )^(gamma/(gamma-1)) ...
                * ( (gamma + 1) / (2*gamma*machSq - (gamma - 1)) )^(1/(gamma-1));
        end

        function staticPressureRatio = calcStaticPressureRatio(mach, gamma)
        %CALCSTATICPRESSURERATIO Calculates the static pressure ratio based on upstream characteristics.
        %   staticPressureRatio = CALCSTATICPRESSURERATIO(mach, gamma) returns the static pressure ratio.
        %
        %   Input Arguments:
        %       mach - (Scalar, double) Upstream mach number.
        %       gamma - (Scalar, double) Adiabatic index.
        %
        %   Output Arguments:
        %       staticPressureRatio - (Scalar, double) Static pressure ratio.
            machSq = mach.^2;
            staticPressureRatio = (2*gamma*machSq - (gamma - 1)) / (gamma + 1);
        end
        
        function densityRatio = calcDensityRatio(mach, gamma)
        %CALCDENSITYRATIO Calculates the density ratio based on upstream characteristics.
        %   densityRatio = CALCDENSITYRATIO(mach, gamma) returns the denstiy ratio.
        %
        %   Input Arguments:
        %       mach - (Scalar, double) Upstream mach number.
        %       gamma - (Scalar, double) Adiabatic index.
        %
        %   Output Arguments:
        %       densityRatio - (Scalar, double) Density ratio.
            machSq = mach.^2;
            densityRatio = (gamma + 1)*machSq / ((gamma - 1)*machSq + 2);
        end

        function staticTemperatureRatio = calcStaticTemperatureRatio(mach, gamma)
        %CALCSTATICTEMPERATURERATIO Calculates the static temperature ratio based on upstream characteristics.
        %   staticTemperatureRatio = CALCSTATICTEMPERATURERATIO(mach, gamma) returns the static temperature ratio.
        %
        %   Input Arguments:
        %       mach - (Scalar, double) Upstream mach number.
        %       gamma - (Scalar, double) Adiabatic index.
        %
        %   Output Arguments:
        %       staticTemperatureRatio - (Scalar, double) Static temperature ratio.
            machSq = mach.^2;
            staticTemperatureRatio = (2*gamma*machSq - (gamma - 1)) ...
                .* ((gamma - 1)*machSq + 2) ./ (machSq*(gamma + 1)^2);
        end
    end
end