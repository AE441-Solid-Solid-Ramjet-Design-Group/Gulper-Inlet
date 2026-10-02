function gamma = getGamma(name)
    switch name
        case "air"
            gamma = 1.4;
        otherwise
            error("Name unrecognized");
    end
end