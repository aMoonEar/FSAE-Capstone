function [totalNormalForceAboutCOM,...
    MaximumTotalFrictionTiresRoad,...
    MaximumDeceleration] = calcDeceleration(...
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
    maxVelocity)
    
    downforceFrontWing = 0.5*densityAir*frontalAreaFrontWing*coefficientWing*(maxVelocity^2);
    downforceRearWing = 0.5*densityAir*frontalAreaRearWing*coefficientWing*(maxVelocity^2);
    
    averageDragCoefficient = coefficientDrag/(frontalAreaRearWing+frontalAreaFrontWing);
    
    liftForce = 0.5*coefficientLift*frontalAreaCar*densityAir*(maxVelocity^2);
    
    dragForceFront = 0.5*densityAir*averageDragCoefficient*frontalAreaFrontWing*(maxVelocity^2);
    dragForceRear = 0.5*densityAir*averageDragCoefficient*frontalAreaRearWing*(maxVelocity^2);
    
    totalDrag = 0.5*coefficientDrag*frontalAreaCar*(maxVelocity^2);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                   Downforce and Drag
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    totalNormalForceCOM = totalMass*gravity+maximumDownForce-liftForce;
    maxAllowableFrictionTiresRoad = totalNormalForceCOM*coefficientRoad;
    maximumDownForce = (1/2)*(1.225)*2.34*(1.542)*(maxVelocity^2);
    maxDeceleration = maxAllowableFrictionTiresRoad/totalMass;

    normalForceFrontWheel = (((totalMass*gravity-liftForce+downforceFrontWing+downforceRearWing)*lengthCOMToRearTire+((totalMass*maxDeceleration+dragForceFront+dragForceRear)*COMFromGroundY)+downforceRearWing*lengthCOMToFrontWing+dragForceFront*heightCOMToFrontWing+dragForceRear*heightCOMToRearWing-downforceFrontWing*lengthCOMToFrontWing))/((2*lengthCOMToFrontTire)+2*lengthCOMToRearTire);
    normalForceRearWheel = (((totalMass*gravity)-liftForce+downforceFrontWing+downforceRearWing)*lengthCOMToFrontTire+((((-totalMass*maxDeceleration)-dragForceFront-dragForceRear))*COMFromGroundY)-downforceRearWing*lengthCOMToRearWing-dragForceFront*heightCOMToFrontWing-dragForceRear*heightCOMToRearWing+downforceFrontWing*lengthCOMToFrontWing)/((2*lengthCOMToFrontTire)+(2*lengthCOMToRearTire));  

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %               Forces Reactions due to acceleratoin (bottom left)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    maxAcceleration = ((-coefficientRoad*lengthCOMToFrontTire))/(COMFromGroundY*coefficientRoad-lengthCOMToFrontTire-lengthCOMToRearTire)*gravity;
    normalForceFrontAcceleration = ((1/2)*C45*gravity*(((lengthCOMToRearTire)/(lengthCOMToRearTire+lengthCOMToFrontTire))-((COMFromGroundY/(lengthCOMToRearTire+lengthCOMToFrontTire))*(C61/gravity))))*2;
    normalForceRearAcceleration = ((1/2)*C45*gravity*(((lengthCOMToFrontTire)/(lengthCOMToRearTire+lengthCOMToFrontTire))+((COMFromGroundY/(lengthCOMToRearTire+lengthCOMToFrontTire))*(C61/gravity))))*2;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %               Static Scenario (bottom left)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    normalForceFrontStatic = (C59*gravity*((lengthCOMToRearTire/(lengthCOMToFrontTire+lengthCOMToRearTire))))/2;
    normalForceRearStatic = (C59*gravity*((lengthCOMToFrontTire/(lengthCOMToFrontTire+lengthCOMToRearTire))))/2;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %               Speed and Cornering
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    normalForceFrontWheelCornering  = (O18*gravity)*((lengthCOMToRearTire)/(lengthCOMToRearTire+lengthCOMToFrontTire));
    normalForceRearWheelCorneringTotal = (O18*gravity)*((lengthCOMToFrontTire)/(lengthCOMToRearTire+lengthCOMToFrontTire);)
    frontBias = lengthCOMToRearTire/(lengthCOMToFrontTire+lengthCOMToRearTire);
    rearBias = lengthCOMToFrontTire/(lengthCOMToFrontTire+lengthCOMToRearTire);
    aeroWithoutVelocity = 0.5*O57*O56*O55;
                                        
    frontNormalForceRightWheelCornering = ((O21+(O25*O23*(O112^2)))*O16-(COMFromGroundY*P112)*(O23))/(2*O16);
    frontNormalForceLeftWheelCorneringFront = ((O21+(O25*O23*(O112^2)))*O16+(COMFromGroundY*P112)*(O23))/(2*O16);
    rearNormalForceRightWheelCorneringRear = ((O22+(O25*O24*(O112^2)))*O16-(COMFromGroundY*P112)*(O24))/(2*O16);
    rearNormalForceLeftWheelCorneringRear = ((O22+(O25*O24*(O112^2)))*O16+(COMFromGroundY*P112)*(O24))/(2*O16);

end