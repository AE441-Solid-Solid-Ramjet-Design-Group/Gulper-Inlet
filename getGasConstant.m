function R = getGasConstant(name)
    switch name
        case "air"
            R = 287; % J/kg/K
        otherwise
            error("Name unrecognized");
    end
end