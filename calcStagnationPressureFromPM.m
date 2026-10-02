function [stagnationPressure] = calcStagnationPressureFromPM(staticPressure, mach, gamma)

    if mach > 0.3
        stagnationPressure = staticPressure.*(1 + (gamma - 1)./2.*mach.*mach).^(gamma/(gamma - 1));
    end

end