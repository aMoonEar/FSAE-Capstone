function [rackLength, finalShaftDiameterInner] = calcSteering(...
    totalMass,...
    corneringRadius,...
    steeringWheelRadius,...
    normalForceFrontStatic,...
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
    densityAir,...
    coefficientWing,...
    frontalAreaFrontWing,...
    frontalAreaRearWing,...
    initialShaftDiameterInner,...
    coefficientLift,...
    coefficientDrag,...
    coefficientRoad,...
    frontalAreaCar,...
    maxVelocity,...
    trackWidth,...
    gravity)

    % set the current diameter of the inner shaft
    shaftDiameterInner = initialShaftDiameterInner; % m
    
    % Calculate the steering angle of the vehicle
    [innerSteeringAngle, outerSteeringAngle] = calcSteeringAngle(...
    corneringRadius,...
    lengthCOMToRearTire,...
    lengthCOMToFrontTire,...
    trackWidth);

    % Calculate the total rack length
    [rackLength] = calcRackLength(...
    steeringWheelRadius,...
    innerSteeringAngle);

    % Calculate the initial safety factor of the steering shaft
    [safetyFactorShaft] = calcShaftSafety(...
    innerSteeringAngle,...
    coefficientRoad,...
    normalForceFrontStatic,...
    shaftDiameterInner);

    % Increase the thickness of the steering shaft until the safety
    % factor is at least 3.5
    while safetyFactorShaft < 3.5
        % Decrement the inner diameter of the shaft by 0.00025m
        shaftDiameterInner = shaftDiameterInner - 0.00025;

        % Re-calculate the safety factor of the steering shaft
        [safetyFactorShaft] = calcShaftSafety(...
            innerSteeringAngle,...
            coefficientRoad,...
            normalForceFrontStatic,...
            shaftDiameterInner);
    end
    
    % set the final inner diameter of the shaft
    finalShaftDiameterInner = shaftDiameterInner; % m
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                        Steering Output                            %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    logFile = 'H:\groupFSAE2\Log\groupFSAE2_LOG.txt';
    fileID = fopen(logOutput,'at');
    fprintf(fileID,'******************************************************************************\n');
    fprintf(fileID,'                             Steering Output \n');
    fprintf(fileID,'******************************************************************************\n\n');

    fprintf(fileID,strcat('Length of steering rack = ',32, num2str (rackLength),' m\n'));
    fprintf(fileID,strcat('Inner diameter of steering shaft = ',32, num2str (finalShaftDiameterInner),' m\n'));
    fprintf(fileID,strcat('Outer Steering Angle = ',32, num2str (outerSteeringAngle),' rad\n'));
    fprintf(fileID,strcat('Inner Steering Angle = ',32, num2str (innerSteeringAngle),' rad\n'));
    fprintf(fileID,strcat('Safety Factor of Steering Shaft = ',32, num2str (safetyFactorShaft),' \n'));

    fclose(fileID); % Close file


end


function [innerSteeringAngle, outerSteeringAngle] = calcSteeringAngle(...
    corneringRadius,...
    lengthCOMToRearTire,...
    lengthCOMToFrontTire,...
    trackWidth)

    % Calculate the horizontal distance from the Center of Corner to center of rear axle
    lengthCOM_RearAxle = sqrt(corneringRadius^2 - lengthCOMToRearTire^2); % m
   
    % Calculate the distance from the rear axle to the front axle
    distanceRearAxle_FrontAxle = lengthCOMToRearTire + lengthCOMToFrontTire; % m
    
    % Calculate the max inner steering angle
    innerSteeringAngle = atan( distanceRearAxle_FrontAxle / (lengthCOM_RearAxle - trackWidth/2)); % rad
    outerSteeringAngle = atan( distanceRearAxle_FrontAxle / (lengthCOM_RearAxle + trackWidth/2)); % rad

end

function [rackLength] = calcRackLength(...
    steeringWheelRadius,...
    innerSteeringAngle)

    % Calculate the steering ratio of the vehicle
    steeringRatio = pi/innerSteeringAngle;

    % Calculate the total rack length
    rackLength = 2*((2/3)*pi*steeringWheelRadius)/steeringRatio; % m

end


function [safetyFactorShaft] = calcShaftSafety(...
    innerSteeringAngle,...
    coefficientRoad,...
    normalForceFrontStatic,...
    shaftDiameterInner)

    radiusContactPatch = 0.1; %m
    distancePinAxis_HeimJoint = 0.08; % m

    % Calculate the angle between the steering arm the knuckle
    angleSteeringArm_Knuckle = 18.31*(3.14/180); % rad
    
    % Calculate the moment of friction acting on the heim joint
    momentOfFriction = ((2/3)*coefficientRoad*normalForceFrontStatic*radiusContactPatch); %Nm
    
    % Calculate the reaction force on the heim joint to analyse the shear
    % stress. This is the lateral force required to turn the steering arm
    heimJointReactionForce = (momentOfFriction)/((distancePinAxis_HeimJoint*cos(-innerSteeringAngle-angleSteeringArm_Knuckle))); %N
    
    % Calculate the angle in the tie rod of the heim joint
    angleTieRodHeimJoint = 0.149762323; %rad

    % Calculate the tie rod input force
    tieRodInputForce = heimJointReactionForce/((cos(angleTieRodHeimJoint))); % N

    % Calculate the angle from the pins to the tie rod
    anglePinsToTieRod = 30*3.14/180; % rad

    % Calculate the reaction forces on the pin in the x-axis
    pinReactionForcesRackX =tieRodInputForce*cos((anglePinsToTieRod)); % N

    % Calculate the tangential force on the tack
    tangentialForceRack =pinReactionForcesRackX*2; % N

    % Set the constants of the pinion, key, ujoint, and shaft
    pinionDiameter = 0.0889; %m
    keyWidth = 0.004; %m
    shaftDiameterOuter = 0.0254; %m
    uJointArmThickness = 0.00476; % m
    distanceBetweenUJointArms = 0.0635; %m

    % Calculate the torque transmitted and pin key reaction force 
    torqueTransmitted = (tangentialForceRack*pinionDiameter)/2; % Nm
    pinKeyReactionForce = torqueTransmitted/((shaftDiameterOuter/2)+(keyWidth/2)); % N

    % Calculate the force on the secondary shaft from u joint
    forceUJointSecondaryShaft = (pinKeyReactionForce*(shaftDiameterInner+(keyWidth/2)))/((distanceBetweenUJointArms+(uJointArmThickness/2)));  % N

    % Calculate the force applied onto the primary shaft
    forceAppliedPrimaryShaft =(forceUJointSecondaryShaft*((uJointArmThickness)+(distanceBetweenUJointArms/2)))/((shaftDiameterOuter)-(keyWidth/2));  % N

    % Calculate the torque from the shaft & moment of inertia
    torqueFromShaft =forceAppliedPrimaryShaft*((shaftDiameterOuter/2)+(keyWidth/2));  % Nm
    momentOfInertia =(3.14)*(shaftDiameterOuter^4-shaftDiameterInner^4); % kg m^2

    stressConcentration = 1.3;
    shearYieldStrength =127600000; % Pa

    % Calculate the safety factor of the steering shaft using the shear stress
    shearStressPrimaryShaft = (16*stressConcentration*torqueFromShaft*(shaftDiameterOuter))/momentOfInertia; % Pa
    safetyFactorShaft =shearYieldStrength/shearStressPrimaryShaft;


end

