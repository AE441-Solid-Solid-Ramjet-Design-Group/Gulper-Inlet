classdef Inlet < handle
    % 

    properties
        inletHalfAngle; % Angle of gulper nose in deg
        gulperRadialAngle; % Gulper angle from front
        inletGapHeight; % Height of inlet gap in meters
        bodyRadius; % Maximum diameter
        inletArea;

        effeciency;

        airProfileStuct; % Array of airprofiles throughout inlet
        shockArray; % Array of shocks
    end

    methods
        function obj = Inlet(noseInletHalfAngle, bodyDiameter, massFlowRate, outputMach, freestream)
            import IsoentropicUtil.*

            obj.inletHalfAngle = noseInletHalfAngle;
            obj.bodyRadius = bodyDiameter/2;

            gamma = getGamma("air");

            noseShock = Shock(obj.inletHalfAngle, freestream.mach, gamma, false);
            obj.shockArray = [noseShock];

            obj.airProfileStuct = struct( ...
            'stagnationPressure', [freestream.stagnationPressure freestream.stagnationPressure*noseShock.stagnationPressureRatio], ...
            'staticPressure', [freestream.staticPressure freestream.staticPressure*noseShock.staticPressureRatio], ...
            'staticTemperature', [freestream.staticTemperature freestream.staticTemperature*noseShock.staticTemperatureRatio], ...
            'density', [freestream.density freestream.density*noseShock.densityRatio], ...
            'mach', [freestream.mach noseShock.downstreamMach]);

            inletTemp = obj.airProfileStuct.staticTemperature(2);
            inletVelocity = obj.airProfileStuct.mach(2)*calcSpeedOfSound(gamma,getGasConstant("air"),inletTemp);
            obj.inletArea = massFlowRate/obj.airProfileStuct.density(2)/inletVelocity;

            obj.inletGapHeight = obj.bodyRadius*(tand(noseShock.beta)-tand(noseShock.theta))/tand(noseShock.beta);

            obj.gulperRadialAngle = 360*obj.inletArea/pi/(obj.bodyRadius^2 - (obj.bodyRadius-obj.inletGapHeight)^2);

            obj.calcInteriorShocks(gamma);

            obj.calcSubsonicDiffuser(outputMach, gamma);
            
            % Calculate effeciency
            effeciency = 1;
            for i = 1:length(obj.shockArray)
                effeciency = effeciency * obj.shockArray(i).stagnationPressureRatio;
            end
            obj.effeciency = effeciency;
        end
    end

    methods (Access=private)
        function calcInteriorShocks(obj, gamma)
            import IsoentropicUtil.*

            i = 2;
            while obj.airProfileStuct.mach(i) > 1
                obj.shockArray(i) = Shock(obj.shockArray(i-1).normalMach,obj.shockArray(i-1).downstreamMach,gamma,true);

                obj.airProfileStuct.stagnationPressure(i+1) = obj.airProfileStuct.stagnationPressure(i) ...
                    * obj.shockArray(i).stagnationPressureRatio;
                obj.airProfileStuct.staticPressure(i+1) = obj.airProfileStuct.staticPressure(i) ... 
                    * obj.shockArray(i).staticPressureRatio;
                obj.airProfileStuct.staticTemperature(i+1) = obj.airProfileStuct.staticTemperature(i) ... 
                    * obj.shockArray(i).staticTemperatureRatio;
                obj.airProfileStuct.density(i+1) = obj.airProfileStuct.density(i) ... 
                    * obj.shockArray(i).densityRatio;
                obj.airProfileStuct.mach(i+1) = obj.shockArray(i).downstreamMach;
                i = i + 1;
            end
        end

        function calcSubsonicDiffuser(obj, outputMach, gamma)
            import IsoentropicUtil.*

            subsonicStagnationPressure = obj.airProfileStuct.staticPressure(end) ... 
                / FlowRelations.calcPressureRatio(obj.airProfileStuct.mach(end),gamma);
            subsonicStagnationTemperature = obj.airProfileStuct.staticTemperature(end) ... 
                / FlowRelations.calcTemperatureRatio(obj.airProfileStuct.mach(end),gamma);
            subsonicStagnationDensity = obj.airProfileStuct.density(end) ... 
                / FlowRelations.calcDensityRatio(obj.airProfileStuct.mach(end),gamma);
            
            endingPressure = subsonicStagnationPressure*FlowRelations.calcPressureRatio(outputMach,gamma);
            endingTemperature = subsonicStagnationTemperature*FlowRelations.calcTemperatureRatio(outputMach,gamma);
            endingDensity = subsonicStagnationDensity*FlowRelations.calcDensityRatio(outputMach,gamma);
            
            obj.airProfileStuct.stagnationPressure(end+1) = subsonicStagnationPressure;
            obj.airProfileStuct.staticPressure(end+1) = endingPressure;
            obj.airProfileStuct.staticTemperature(end+1) = endingTemperature;
            obj.airProfileStuct.density(end+1) = endingDensity;
            obj.airProfileStuct.mach(end+1) = outputMach;
        end
    end
end