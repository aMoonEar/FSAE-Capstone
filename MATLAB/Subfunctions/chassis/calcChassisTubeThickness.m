% =========================================================================
%   Function: 
%
%   Parameters: 
%   
%   Outputs: 
%
%   Description: 
% =========================================================================
function [OuterRadiusTubeA, InnerRadiusTubeA, OutterWidthTubeB, InnerWidthTubeB] = calcChassisTubeThickness(driverWeight)

    %Width of sqaure tubes
    OutterWidthTubeB = 25.4; % mm
    InnerWidthTubeB = (25.4-3.2); % mm

    %Radii of tubes
    OuterRadiusTubeA = 12.5; % mm
    InnerRadiusTubeA = (12.5 - 1.25); % mm

    % Initial calculation of minimum safety factor
    [minimumSafetyFactorFront] = calcChassisFrontImpact(driverWeight, OuterRadiusTubeA, InnerRadiusTubeA, OutterWidthTubeB, InnerWidthTubeB);
    [minimumSafetyFactorRear] = calcChassisRearImpact(driverWeight, OuterRadiusTubeA, InnerRadiusTubeA, OutterWidthTubeB, InnerWidthTubeB);

    % find the minimum safety factor
    safetyFactor = min([minimumSafetyFactorFront, minimumSafetyFactorRear]);

    % re-calculate the safety factor to ensure it is above 2.5
    % by increasing wall thickness
    while safetyFactor < 2.5
        
        % Decrement width of inner tube B
        InnerWidthTubeB = InnerWidthTubeB - 0.1; %mm
        
        % Decrement radii of inner tube A
        InnerRadiusTubeA = InnerRadiusTubeA - 0.1; %mm
    
        % Initial calculation of minimum safety factor
        [minimumSafetyFactorFront] = calcChassisFrontImpact(driverWeight, OuterRadiusTubeA, InnerRadiusTubeA, OutterWidthTubeB, InnerWidthTubeB);
        [minimumSafetyFactorRear] = calcChassisRearImpact(driverWeight, OuterRadiusTubeA, InnerRadiusTubeA, OutterWidthTubeB, InnerWidthTubeB);
    
        % find the minimum safety factor
        safetyFactor = min([minimumSafetyFactorFront, minimumSafetyFactorRear]);
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                        Chassis Tube Output                          %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    logFile = 'H:\groupFSAE2\Log\groupFSAE2_LOG.txt';
    fileID = fopen(logOutput,'at');
    fprintf(fileID,'******************************************************************************\n');
    fprintf(fileID,'                             Optimized Chassis Tube Design \n');
    fprintf(fileID,'******************************************************************************\n\n');
    fprintf(fileID,'------------ Chassis Output ----------------\n\n');
    fprintf(fileID,strcat('Inner width of the square tubes of chassis = ',32, num2str (InnerWidthTubeB),' mm\n'));
    fprintf(fileID,strcat('Inner radius of the circlar tubes of the chassis = ',32, num2str (InnerRadiusTubeA),' mm\n\n'));
    fprintf(fileID,strcat('Safety Factor of the front of chassis = ',32, num2str(minimumSafetyFactorFront),' \n'));
    fprintf(fileID,strcat('Safety Factor of the rear of chassis = ',32, num2str(minimumSafetyFactorRear),'.\n'));
    fclose(fileID); % Close file
    
    
end