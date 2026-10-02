classdef Oblique
    % Isoentropic oblique shock relations stored here
    % Equations came from: https://www.grc.nasa.gov/www/k-12/airplane/oblique.html

    methods (Static)
        
        function [weakAngle, strongAngle] = calcShockAngle(theta, mach, gamma)
        %CALCSHOCKANGLE Calculates shock angle based on deflection angle
        %and incoming mach.
        %   beta = CALCSHOCKANGLE(theta, mach, gamma) returns the shock angle.
        %
        %   Input Arguments:
        %       theta  - (Scalar, double) Deflection angle in degrees.
        %       mach - (Scalar, double) Upstream mach number.
        %       gamma - (Scalar, double) Adiabatic index.
        %
        %   Output Arguments:
        %       weakAngle - (Scalar, double) Weak angle in degrees.
        %       strongAngle - (Scalar, double) Strong angle in degrees.
                
            f = @(beta) cotd(theta) - tand(beta).*((gamma+1).*mach.*mach./((mach.*mach.*sind(beta).*sind(beta)-1).*2) - 1);
        
            % Determine possible range of possible shock angles
            mu = asind(1./mach);
            tol = 1e-6;
            betaRange = linspace(mu+tol,90-tol,10000);
            fValues = arrayfun(f, betaRange);
            
            % Find sign changes for fzero
            idx = find(fValues(1:end-1).*fValues(2:end) < 0);
        
            % Find shock angles
            if isscalar(idx) && isreal(idx)
                weakAngle = fzero(f, [betaRange(idx(1)), betaRange(idx(1)+1)]);
                strongAngle = NaN;
            elseif length(idx) > 1
                weakAngle = fzero(f, [betaRange(idx(1)), betaRange(idx(1)+1)]);
                strongAngle = fzero(f, [betaRange(idx(end)), betaRange(idx(end)+1)]);
            else
                error("Shock is not attached");
            end
        end
        
        function deflectionAngle = calcDeflectionAngle(beta, mach, gamma)
        %CALCDEFLECTIONANGLE Calculates the deflection angle based on upstream characteristics.
        %   deflectionAngle = CALCDEFLECTIONANGLE(beta, mach, gamma) returns the deflection angle in degrees.
        %
        %   Input Arguments:
        %       beta - (Scalar, double) Shock angle in degrees.
        %       mach - (Scalar, double) Upstream mach number.
        %       gamma - (Scalar, double) Adiabatic index.
        %
        %   Output Arguments:
        %       deflectionAngle - (Scalar, double) Deflection angle in degrees.
        normMachSq = (mach*sind(beta)).^2;
        deflectionAngle = acotd( ...
            tand(beta)* ...
            ((gamma+1)*mach*mach/2/(normMachSq-1) - 1) ...
            );
        end

        function downstreamMach = calcDownstreamMach(beta, theta, upstreamMach, gamma)
        %CALCDOWNSTREAMMACH Calculates the downstream mach number based on upstream characteristics.
        %   downstreamMach = CALCDOWNSTREAMMACH(beta, theta, upstreamMach, gamma) returns the downstream mach number.
        %
        %   Input Arguments:
        %       beta - (Scalar, double) Shock angle in degrees.
        %       theta  - (Scalar, double) Deflection angle in degrees.
        %       upstreamMach - (Scalar, double) Upstream mach number.
        %       gamma - (Scalar, double) Adiabatic index.
        %
        %   Output Arguments:
        %       downstreamMach - (Scalar, double) Downstream mach number.
            normMachSq = (upstreamMach*sind(beta)).^2;
            downstreamMach = sqrt( ...
                ((gamma-1)*normMachSq+2) ...
                / (2*gamma*normMachSq - (gamma - 1)) ... 
                / (sind(beta - theta)^2) ...
                );
        end

        function stagnationPressureRatio = calcStagnationPressureRatio(beta, mach, gamma)
        %CALCSTAGNATIONPRESSURERATIO Calculates the stagnation pressure ratio based on upstream characteristics.
        %   stagnationPressureRatio = CALCSTAGNATIONPRESSURERATIO(beta, mach, gamma) returns the stagnation pressure ratio.
        %
        %   Input Arguments:
        %       beta - (Scalar, double) Shock angle in degrees.
        %       mach - (Scalar, double) Upstream mach number.
        %       gamma - (Scalar, double) Adiabatic index.
        %
        %   Output Arguments:
        %       stagnationPressureRatio - (Scalar, double) Stagnation pressure ratio.
            normMachSq = (mach*sind(beta)).^2;
            stagnationPressureRatio = ( (gamma + 1) * normMachSq / ((gamma - 1)*normMachSq+2) )^(gamma/(gamma-1)) ...
                * ( (gamma + 1) / (2*gamma*normMachSq - (gamma - 1)) )^(1/(gamma-1));
        end

        function staticPressureRatio = calcStaticPressureRatio(beta, mach, gamma)
        %CALCSTATICPRESSURERATIO Calculates the static pressure ratio based on upstream characteristics.
        %   staticPressureRatio = CALCSTATICPRESSURERATIO(beta, mach, gamma) returns the static pressure ratio.
        %
        %   Input Arguments:
        %       beta - (Scalar, double) Shock angle in degrees.
        %       mach - (Scalar, double) Upstream mach number.
        %       gamma - (Scalar, double) Adiabatic index.
        %
        %   Output Arguments:
        %       staticPressureRatio - (Scalar, double) Static pressure ratio.
            normMachSq = (mach*sind(beta)).^2;
            staticPressureRatio = (2*gamma*normMachSq - (gamma - 1)) / (gamma + 1);
        end
        
        function densityRatio = calcDensityRatio(beta, mach, gamma)
        %CALCDENSITYRATIO Calculates the density ratio based on upstream characteristics.
        %   densityRatio = CALCDENSITYRATIO(beta, mach, gamma) returns the denstiy ratio.
        %
        %   Input Arguments:
        %       beta - (Scalar, double) Shock angle in degrees.
        %       mach - (Scalar, double) Upstream mach number.
        %       gamma - (Scalar, double) Adiabatic index.
        %
        %   Output Arguments:
        %       densityRatio - (Scalar, double) Density ratio.
            normMachSq = (mach*sind(beta)).^2;
            densityRatio = (gamma + 1)*normMachSq / ((gamma - 1)*normMachSq + 2);
        end

        function staticTemperatureRatio = calcStaticTemperatureRatio(beta, mach, gamma)
        %CALCSTATICTEMPERATURERATIO Calculates the static temperature ratio based on upstream characteristics.
        %   staticTemperatureRatio = CALCSTATICTEMPERATURERATIO(beta, mach, gamma) returns the static temperature ratio.
        %
        %   Input Arguments:
        %       beta - (Scalar, double) Shock angle in degrees.
        %       mach - (Scalar, double) Upstream mach number.
        %       gamma - (Scalar, double) Adiabatic index.
        %
        %   Output Arguments:
        %       staticTemperatureRatio - (Scalar, double) Static temperature ratio.
            normMachSq = (mach*sind(beta)).^2;
            staticTemperatureRatio = (2*gamma*normMachSq - (gamma - 1)) ...
                .* ((gamma - 1)*normMachSq + 2) ./ (normMachSq*(gamma + 1)^2);
        end
    end
end