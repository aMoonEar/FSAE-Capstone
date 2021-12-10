%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Function: calcCenterOfMass
%
%   Parameters: driverMass (kg)
%   
%   Outputs: totalMass (kg), lengthCOMToRearTire (mm),
%   lengthCOMToFrontTire (mm), COMFromGroundX(mm),
%   COMFromGroundY (mm), COMFromGroundZ (mm),
%   lengthCOMToFrontWing (mm), lengthCOMToRearWing (mm),
%   heightCOMToFrontWing (mm), heightCOMToRearWing (mm),
%   lengthToRightWheelCOM (mm), lengthToLeftWheelCOM (mm)
%
%   calcCenterOfMass calculates the main center of mass calculations 
%   with the inputted driver weight.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
    lengthToLeftWheelCOM,...
    sprungMass,...
    unsprungMass] = calcCenterOfMass(driverWeight)
    
    % The value of the axis*Mass without the driver
    xTimesMass = 839.1; % mm*kg (x*Mass is not affected by the weight of the driver)
    yTimesMassWithoutDriver = 43716.7778; % mm*kg
    zTimesMassWithoutDriver = 300147.5028; % mm*kg
    
    % Calculate the axis*Mass of only the driver
    yTimesMassDriver = -35 * driverWeight; % mm*kg
    zTimesMassDriver = 1312.54 * driverWeight; % mm*kg
    
    % Add the axis*Mass of the driver to the total axis*Mass
    yTimesMass = yTimesMassWithoutDriver + yTimesMassDriver; % mm*kg
    zTimesMass = zTimesMassWithoutDriver + zTimesMassDriver; % mm*kg
    
    % Calculate the total mass of the vehicle
    totalMass = 191.885 + driverWeight; % kg
    
    % Calculate the new center of mass of each axis with update axis*Mass
    COMx = xTimesMass / totalMass; % mm
    COMy = yTimesMass / totalMass; % mm
    COMz = zTimesMass / totalMass; % mm
    
    % Add the height above the ground
    COMFromGroundX = COMx; % mm
    COMFromGroundY = COMy + 158; % mm
    COMFromGroundZ = COMz; % mm
    
    % Calculate the distance between each end of the vehicle to the COM
    lengthCOMToRearTire = abs((COMFromGroundZ - 2261.56)/(1000)); % mm
    lengthCOMToFrontTire = abs((COMFromGroundZ - 658.535)/(1000)); % mm
    
    % Calculate the distance between the Front and Rear Wing to the COM
    lengthCOMToFrontWing = lengthCOMToFrontTire + 0.05; % mm
    lengthCOMToRearWing = lengthCOMToRearTire + 0.03; % mm
    
    % Calculate the height of the (distance on y axis) between the COM to
    % the front & rear wing
    heightCOMToFrontWing = (COMFromGroundY/1000) - 0.1; % mm
    heightCOMToRearWing = 1.285 - (COMFromGroundY/1000);% mm
    
    % Calculate the distance between the right and left wheel to the COM
    lengthToRightWheelCOM = 0.5 - (COMFromGroundX/1000);% mm
    lengthToLeftWheelCOM = 1 - lengthToRightWheelCOM;% mm
    
    % Convert to m
    COMFromGroundX = COMFromGroundX/1000; % m
    COMFromGroundY = COMFromGroundY/1000; % m
    COMFromGroundZ = COMFromGroundZ/1000; % m
    
    sprungMass = 111.679 + driverWeight;
    unsprungMass = 80.2065;
    
end