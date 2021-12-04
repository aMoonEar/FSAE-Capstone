
function DesignCode(driverWeight, steeringStiffness, corneringRadius)

    %Check if the user tries to run this file directly
    %if ~exist('axial_force','var')
    %    cd H:\groupABC\MATLAB\
    %    run H:\groupABC\MATLAB\Main.m; %Run Main.m instead
    %    return
    %end
    
    % Output log file location
    %logFile = 'H:\groupFSAE2\Log\groupFSAE2_LOG.txt';
    logFile = 'C:\Users\16138\Documents\FSAE-Capstone\Log\groupFSAE2_LOG.txt'; % replace this directory with above
    %logFile = 'Z:\2018\MCG4322A\Digital Files\BSAE-3B\Log\BSAE-3B_LOG.txt'; % log file
    
    fileID = fopen(logFile,'wt+'); % Open logFile for reading and writing. If the file exists, its contents are erased
    % Writing values to file
    fprintf(fileID,'************************************************************************\n');
    fprintf(fileID,'              Input Parameters \n');
    fprintf(fileID,'************************************************************************\n');
    fprintf(fileID,strcat('Mass of the driver =',32,num2str(driverWeight),' kg\n'));
    fclose(fileID); % Close file
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                   Constants
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    gravity = 9.81;
    coefficientDrag = 0.92;
    radiusOfTire = 0.25527;
    maxVelocity = 105/3.6;
    densityAir = 1.225;
    trackWidth = 1.2538;
    
    frontalAreaCar = 1.5412;
    frontalAreaRearWing = 0.6425;
    frontalAreaFrontWing = 0.5312;
    coefficientLift = 0.29;
    coefficientWing = 3.074;
    coefficientRoad = 0.9;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                   Calculations
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    [totalMass, rearTireToCOM, frontTireToCOM, COMFromGroundX, COMFromGroundY, COMFromGroundZ, lengthCOMToFrontWing, lengthCOMToRearWing, heightCOMToFrontWing, heightCOMToRearWing, lengthToRightWheelCOM, lengthToLeftWheelCOM] = calcCenterOfMass(driverWeight);
    calcDeceleration(totalMass, rearTireToCOM, frontTireToCOM, COMFromGroundX, COMFromGroundY, COMFromGroundZ, lengthCOMToFrontWing,  lengthCOMToRearWing, heightCOMToFrontWing, heightCOMToRearWing, lengthToRightWheelCOM, lengthToLeftWheelCOM, densityAir, coefficientWing, frontalAreaFrontWing, frontalAreaRearWing, coefficientLift, coefficientDrag, coefficientRoad, frontalAreaCar, maxVelocity, gravity);
    calcSteering();
    %default_diameter = 0.5; %Units (mm). Sets an initial diameter value.
    %strength_al = 31; %Units (MPa). Assuming 1100-0 Al alloy, 
    
    %new_diameter = calc_shaft_diameter(default_diameter, strength_al, axial_force, number_of_weights, shaft_length); %A call to a subfunction to calculate the new shaft diameter.

    %Declaring text files to be modified
    %Files
    %log_file = 'H:\\groupABC\\Log\\groupABC_LOG.TXT';
    %shaft_file = 'H:\\groupABC\\SolidWorks\\Equations\\shaft.txt';
     
	%Write the equations file(s) (FILE(s) LINKED TO SOLIDWORKS).
	%You can make a different file for each section of your project (ie one for steering, another for brakes, etc...)
	%or one single large file that includes all the equations. Its up to you!
    %fid = fopen(shaft_file,'w+t');
    %fprintf(fid,strcat('"Diameter"=',num2str(new_diameter),'\n'));
    %fprintf(fid,strcat('"Length"=',num2str(shaft_length),'\n'));
    %fclose(fid);
end