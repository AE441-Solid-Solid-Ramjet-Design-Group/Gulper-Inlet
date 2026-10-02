classdef Shock < handle
    % Shock

    properties
        theta; % Deflection angle in deg
        beta; % Shock angle in deg
        gamma; % Adiabatic index
        upstreamMach; % Upstream mach number
        downstreamMach; % Downstream mach number
        normalMach; % Mach normal to shock

        staticPressureRatio;
        stagnationPressureRatio;
        densityRatio;
        staticTemperatureRatio;
    end

    methods
        function obj = Shock(val, mach, gamma, isReflected)
            obj.upstreamMach = mach;
            obj.gamma = gamma;

            if mach > 1
                if ~isReflected
                    % Value is theta
                    obj.theta = val;
                    [obj.beta, ~] = IsoentropicUtil.Oblique.calcShockAngle(obj.theta,obj.upstreamMach,obj.gamma);
                    
                else
                    % Value is mach normal
                    obj.beta = real(asind(val/mach));
                    obj.theta = IsoentropicUtil.Oblique.calcDeflectionAngle(obj.beta,obj.upstreamMach,obj.gamma);
                end

                if obj.beta < 90
                    obj.staticPressureRatio = IsoentropicUtil.Oblique.calcStaticPressureRatio(obj.beta,obj.upstreamMach,obj.gamma);
                    obj.stagnationPressureRatio = IsoentropicUtil.Oblique.calcStagnationPressureRatio(obj.beta,obj.upstreamMach,obj.gamma);
                    obj.densityRatio = IsoentropicUtil.Oblique.calcDensityRatio(obj.beta,obj.upstreamMach,obj.gamma);
                    obj.staticTemperatureRatio = IsoentropicUtil.Oblique.calcStaticTemperatureRatio(obj.beta,obj.upstreamMach,obj.gamma);
                    obj.downstreamMach = IsoentropicUtil.Oblique.calcDownstreamMach(obj.beta,obj.theta,obj.upstreamMach,obj.gamma);
                    obj.normalMach = sind(obj.beta)*obj.upstreamMach;

                    if obj.downstreamMach < 1
                        error("Last shock needs to be normal");
                    end
                elseif obj.beta == 90
                    obj.staticPressureRatio = IsoentropicUtil.Normal.calcStaticPressureRatio(obj.upstreamMach,obj.gamma);
                    obj.stagnationPressureRatio = IsoentropicUtil.Normal.calcStagnationPressureRatio(obj.upstreamMach,obj.gamma);
                    obj.densityRatio = IsoentropicUtil.Normal.calcDensityRatio(obj.upstreamMach,obj.gamma);
                    obj.staticTemperatureRatio = IsoentropicUtil.Normal.calcStaticTemperatureRatio(obj.upstreamMach,obj.gamma);
                    obj.downstreamMach = IsoentropicUtil.Normal.calcDownstreamMach(obj.upstreamMach,obj.gamma);
                    obj.normalMach = 0;
                else
                    error("Beta is wack");
                end
            else
                error("Subsonic upstream mach");
            end
            
            
        end
    end
end