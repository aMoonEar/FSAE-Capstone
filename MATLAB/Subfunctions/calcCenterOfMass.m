function [totalMass,... 
    lengthCOMToRearTire,...
    lengthCOMToFrontTire,...
    COMFromGroundX,...
    COMFromGroundY,...
    COMFromGroundZ,...
    lengthCOMToFrontWing,...
    lengthCOMToRearWing,...
    heightCOMToFrontWing,...
    heightCOMToRearWing,...
    lengthToRightWheelCOM,...
    lengthToLeftWheelCOM] = calcCenterOfMass(driverWeight)

    xTimesMass = 839.1;
    yTimesMassWithoutDriver = 43716.7778;
    zTimesMassWithoutDriver = 300147.5028;
    
    yTimesMassDriver = -35 * driverWeight;
    zTimesMassDriver = 1312.54 * driverWeight;
    
    yTimesMass = yTimesMassWithoutDriver + yTimesMassDriver;
    zTimesMass = zTimesMassWithoutDriver + zTimesMassDriver;
    
    totalMass = 191.885 + driverWeight;
    
    COMx = totalMass * xTimesMass;
    COMy = totalMass * yTimesMass;
    COMz = totalMass * zTimesMass;
    
    COMFromGroundX = (COMx)/1000;
    COMFromGroundY = (COMy + 103 + 55)/1000;
    COMFromGroundZ = (COMz)/1000;
    
    lengthCOMToRearTire = abs((COMFromGroundZ - 2261.56)/(1000));
    lengthCOMToFrontTire = abs((COMFromGroundZ - 658.535)/(1000));
    
    lengthCOMToFrontWing = lengthCOMToFrontTire + 0.05;
    lengthCOMToRearWing = lengthCOMToRearTire + 0.03;
    
    heightCOMToFrontWing = COMFromGroundY - 0.1;
    heightCOMToRearWing = 1.285 - COMFromGroundY;
    
    lengthToRightWheelCOM = 0.5 - COMFromGroundX;
    lengthToLeftWheelCOM = 1 - lengthToRightWheelCOM;

end