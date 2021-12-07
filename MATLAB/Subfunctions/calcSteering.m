function [] = calcSteering(...
    totalMass,...
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
    coefficientLift,...
    coefficientDrag,...
    coefficientRoad,...
    frontalAreaCar,...
    maxVelocity,...
    trackWidth,...
    gravity)



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                       Ackerman Geometry
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
    %rearAxleToFrontAxle = lengthCOMToRearTire+lengthCOMToFrontTire;
    %keyWidth = 0.004;
    %secondaryShaftDiameter = 0.022225;
    
    %innerWheelSteeringAngle = ;
    %outerWheelSteeringAngle = ;
    
    %minimumTurningAngle = sqrt((lengthCOMToRearTire^2)+(rearAxleToFrontAxle^2)*((cot(R26)+cot(R25))/2)^2)
    
    %theta1 = arc(L/( sqrt(R1^2 - lengthCOMToRearTire^2)^2 - (T/2) ));
    %minimumTurningRadius = sqrt((R27^2)+(R28^2)*((COT(R26)+COT(R25))/2)^2);
    
    %pinReactionForce    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                    Tie Rod & Heim Joint
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    tieRodInputForce = J37/((COS(J35))); %N
    heimJointReactionForce = J29; %N
    areaOfThread = (J36/J38)*10^6; %mm^2
    axialStress = (J36/J38)*10^6; %Pa
    yieldStrength = 220000000 %Pa
    
    

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              Heim Joint Bolt (Steering Knuckle)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = calcHeimJoint(...
    coefficientRoad,...
    maximumTurningAngle,...
    distancePinAxis_HeimJoint,...
    normalForceFrontStatic,...
    radiusContactPatch,...
    totalRadiusContactPatch,...
    totalWheelNormalForce)

    % Calculate the angle between the steering arm the knuckle
    angleSteeringArm_Knuckle = 18.31*(3.14/180);
    
    % Calculate the moment of friction acting on the heim joint
    momentOfFriction = ((2/3)*coefficientRoad*totalWheelNormalForce*totalRadiusContactPatch); %Nm
    
    % Calculate the reaction force on the heim joint to analyse the shear
    % stress. This is the lateral force required to turn the steering arm
    reactionForce = (momentOfFriction)/((distancePinAxis_HeimJoint*cos(-maximumTurningAngle-angleSteeringArm_Knuckle))); %N
    
    % Calculate the maximum shear stress acting on the heim joint
    maxShearStress = ((4/3)*(reactionForce/((3.14*heimJointReactionForce^2)/(4)))); % Pa
    
    % Assume shear stress of AISI-1030
    shearYieldStress = 139200000; %Pa
    
    % Calculate the safety factor of the heim joint bolt of the steering
    % knuckle
    safetyFactor = shearYieldStress/maxShearStress;
    
end