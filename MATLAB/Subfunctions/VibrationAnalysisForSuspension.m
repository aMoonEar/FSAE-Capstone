% =========================================================================
%   Function: VibrationAnalysisSuspension
%
%   Parameters: dampingRatio (unitless), unsprungCornerMassperWheel (kg), 
%   frontunsprungCornerMass (kg), frontmotionRatio (unitless),
%   rearunsprungCornerMass (kg), rearmotionRatio (unitless)
%
%   Outputs: FrontspringRateOfSuspension (N/m), frontdampingCoefficientOfSuspension
%   (Ns/m), RearspringRateofSuspension (N/m), reardampingCoefficientOfSuspension
%   (Ns/m)
%
%
%   Description: Calculates the spring rate for the shock absorber's spring
%   as well as the damping coefficient for the shock absorber's damper;
%   using vibration analysis, using the model illustrated in the Analysis Report.
% =========================================================================
function [frontspringRateOfSuspension, frontdampingCoefficientOfSuspension, rearspringRateOfSuspension, reardampingCoefficientOfSuspension] = VibrationAnalysisForSuspension(dampingRatio, frontunsprungCornerMass,rearunsprungCornerMass)

    %Defining rocker geometry to determine the Motion Ratio of the Vehicle
    a=0.06125; %m
    b=0.05; %m
    thetafront=(93.5*(3.14/180));  %radians
    thetarear=(90.5*(3.14/180));   %radians 

    %Motion Ratio for Push Rod Geometry
    frontmotionRatio=(a/b)*sin(theta1); 
    rearmotionRatio=(a/b)*sin(theta2); 
                                                                                                      
    % Ride frequency, f Typical ride frequency for an FSAE car
    rideFrequency = 3.75; % Hz

    % Spring constamt for front suspension (one corner), K_sf
    frontspringRateOfSuspension = (4*(pi^2)*(rideFrequency^2)*frontunsprungCornerMass*((1/(frontmotionRatio))^2)); % N/m

    % Spring constamt for Rear suspension (one corner), K_sr
    rearspringRateOfSuspension = (4*(pi^2)*(rideFrequency^2)*rearunsprungCornerMass*((1/(rearmotionRatio))^2)); % N/m   

    % Tire stiffness, K_t
    tireStiffness = 147281.668    ; % N/m

    % Wheel rate, K_w
    frontwheelRate = frontspringRateOfSuspension*(frontmotionRatio^2); % N/m
    rearwheelRate = rearspringRateOfSuspension*(rearmotionRatio^2); % N/m

    % Adding the unsprung masses to find the total unsprung mass acting on the axles
    totalfrontunsprungmass=2*frontunsprungCornerMass;
    totalrearunsprungmass=2*rearunsprungCornerMass;


    % Critical damping coefficient
    frontcriticalDampingCoefficientOfSuspension = 2*(sqrt(((frontwheelRate*tireStiffness)/(frontwheelRate+tireStiffness))*totalfrontunsprungmass)); % Ns/m
    rearcriticalDampingCoefficientOfSuspension = 2*(sqrt(((rearwheelRate*tireStiffness)/(rearwheelRate+tireStiffness))*totalrearunsprungmass)); % Ns/m

    % Damping coefficent for front suspension (one corner), c_front and c_rear, 
    % Where the damping ratio is the GUI input from the user and determines the stifness of the vehicle
    frontdampingCoefficientOfSuspension = dampingRatio*frontcriticalDampingCoefficientOfSuspension; % Ns/m
    reardampingCoefficientOfSuspension = dampingRatio*rearcriticalDampingCoefficientOfSuspension; % Ns/m
    
    end

%   It will need the inputs from the COFM file which will calculate the unsprung masses 
%   and then splits them based on bias and divides it by 2 to find the per corner 
%   unsprung mass of the vehicle 