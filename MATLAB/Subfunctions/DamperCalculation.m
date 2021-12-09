% =========================================================================
%   Function: DamperCalculation
%
%   Parameters: dampingCoefficientSuspension (Ns/m), forceOnDamper (N),
%   fullSolidDeflection (mm), innerDiameterSpring (mm), springrate_N_per_mm,
%   frontpushrodforce
%   
%   Outputs: damperwallThickness (mm), innerHousingDiameterOfDamper (mm), 
%   orificeDiameter (mm)
%
%   Description: Calculates the different parameterized variables specific to
%   The damper. It will itterate for a wall thickness and find the respective
%   Inner and Outer Housing diameters of the damper in relation to inner and
%   Diameter of the spring determined from the SpringCalculations file all 
%   Calculations are referring to the equations determiend in the Analysis Report.
%   The springrate_N_per_mm and the frontpushrodforce are reffering to the 
%   Calculations from the SpringCalculation file and the SuspensionForceCalculation 
%   Files respectively.
% =========================================================================
function [damperwallThickness , innerHousingDiameterOfDamper, orificeDiameter, forceOnDamper] = DamperCalculation(dampingCoefficientSuspension, forceOnDamper, fullSolidDeflection, innerDiameterSpring, frontpushrodforce, springrate_N_per_mm )

% This is the range of motion of the shock absorber (damper and spring)
% used for the navier-stokes function this value is derived from the 
% spring calculations folder
fullSolidDeflection = fullSolidDeflection/1000; % m

%Defining the maximum desired deflection which is not to be exceeded to be
desiredmaxdeflection = 50; % mm

% Outer housing diameter of damper, allowing for a 10% clearance 
% between spring and damper, converted from mm to m
% innerDiameterSpring is calculated from the spring_calculation 
outerHousingDiameterOfDamper = (innerDiameterSpring/1000) * 0.9; % m

% Assuming a wall thickness for the start
damperwallThickness = 0.0015; % m

% Deterimining the Diameter of the damper's inner housing, D_Housing
innerHousingDiameterOfDamper = outerHousingDiameterOfDamper - (2 * damperwallThickness); % m

% Determining the annulus Area of the damper's housing
AreaofHousing = (pi / 4) * ((outerHousingDiameterOfDamper^2)-(innerHousingDiameterOfDamper^2)); % m^2

%Force on Damper can be determined by subtracting the Spring Force from the pushrod force
forceOnDamper= frontpushrodforce - (springrate_N_per_mm*desiredmaxdeflection); % N

% Calling buckling safety factor function
[bucklingSafetyFactor] = BucklingOfHousing(forceOnDamper, AreaofHousing);

% Calling bursting pressure safety factor function
[burstingPressureSafetyFactor] = BurstingPressureOfHousing(forceOnDamper, AreaofHousing, innerHousingDiameterOfDamper, damperwallThickness);

% Dtermining lowest safety factor between buckling and bursting pressure
lowestSafetyFactor = min(bucklingSafetyFactor, burstingPressureSafetyFactor);

% While loop increases damperwallThickness by 0.001[mm] until lowestSafetyFactor 
% reaches 2
while (lowestSafetyFactor < 1.5)
    damperwallThickness = damperwallThickness + 0.001; % m

    [bucklingSafetyFactor] = BucklingOfHousing(forceOnDamper, AreaofHousing);
    [burstingPressureSafetyFactor] = BurstingPressureOfHousing(forceOnDamper, AreaofHousing, innerHousingDiameterOfDamper, damperwallThickness);
    
    lowestSafetyFactor = min(bucklingSafetyFactor, burstingPressureSafetyFactor); % unitless

end

% Calling Navier-Stokes function
[innerHousingDiameterOfDamper, orificeDiameter] = NavierStokes(outerHousingDiameterOfDamper, damperwallThickness, dampingCoefficientSuspension, fullSolidDeflection);

% Converting all outputs from [m] to [mm]
damperwallThickness = damperwallThickness * 1000; % mm

innerHousingDiameterOfDamper = innerHousingDiameterOfDamper * 1000; % mm

orificeDiameter = orificeDiameter * 1000; % mm

end

% =========================================================================
%   Function: BucklingOfHousing
%
%   Parameters: forceOnDamper (N), AreaofHousing (m^2)
%   
%   Outputs: bucklingSafetyFactor (unitless)
%
%   Description: Calculates the buckling safety factor of the damper's
%   housing.
% =========================================================================
function [bucklingSafetyFactor] = BucklingOfHousing(forceOnDamper, AreaofHousing)

%Material used is Aluminum 2124-T851

% Buckling stress allowed
bucklingStress = forceOnDamper / AreaofHousing; % Pa

% Defining the Yield strength of the material
yieldStrengthDamperHousing = 4.41e+08; % Pa

% Buckling safety factor for the housing of damper
bucklingSafetyFactor = yieldStrengthDamperHousing / bucklingStress; % unitless

end

% =========================================================================
%   Function: BurstingPressureOfHousing
%
%   Parameters: forceOnDamper (N), AreaofHousing (m^2),
%   innerHousingDiameterOfDamper (m), damperwallThickness (m)
%   
%   Outputs: burstingPressureSafetyFactor (unitless)
%
%   Description: Calculates the bursting pressure safety factor using the
%   Thin wall method
% =========================================================================
function [burstingPressureSafetyFactor] = BurstingPressureOfHousing(forceOnDamper, AreaofHousing, innerHousingDiameterOfDamper, damperwallThickness)

% The thin wall method is implemented since the thickness of the wall is
% about one-tenth or less of its radius (from Shigley's textbook)

% Yield strength of Aluminum 2124-T851
yieldStrengthDamperHousing = 4.41e+08; % Pa

% Maximum pressure inside the damper
innerPressure = forceOnDamper / AreaofHousing; % Pa

% Assuming negligible radial stresses as described in the Shigley's textbook
radialStress = 0; % Pa

% Maximal tangential stress, higher than average tangential stress
maximalTangentialStress = (innerPressure*(innerHousingDiameterOfDamper + damperwallThickness))/(2*damperwallThickness); % Pa

% Longitudinal stress
longitudinalStress = (innerPressure * innerHousingDiameterOfDamper)/(4*damperwallThickness); % Pa

% Sorting stress in ascending order (1 being the highest, 3 being the lowest)
% As specified by the von Mises
% Thus Array of stresses:

arrayOfStresses = [radialStress,maximalTangentialStress,longitudinalStress];

sigma_a = max(arrayOfStresses);
sigma_b = median(arrayOfStresses);
sigma_c = min(arrayOfStresses);

% Von Mises stress
vonMisesStress = sqrt((((sigma_a-sigma_b)^2)+((sigma_b-sigma_c)^2)+((sigma_c-sigma_a)^2))/2); % Pa

% Bursting pressure safety factor
burstingPressureSafetyFactor = yieldStrengthDamperHousing / vonMisesStress; % unitless

end

% =========================================================================
%   Function: NavierStokes
%
%   Parameters: outerHousingDiameterOfDamper (m), damperwallThickness (m),
%   dampingCoefficientSuspension (Ns/m), fullSolidDeflection (m)
%   
%   Outputs: orificeDiameter (m), innerHousingDiameterOfDamper (m)
%
%   Description: NavierStokes equations were used to derive the equation below
%   And are further used to determine the orfiice diameter of the Damper
%   Recalculateing the inner housing diameter of the damper using the final
%   Parameterized wall thickness. The dampingCoefficientSuspension can be 
%   Derived from the VibrationAnalysisCalculation file.
% =========================================================================
function [innerHousingDiameterOfDamper, orificeDiameter] = NavierStokes(outerHousingDiameterOfDamper, damperwallThickness, dampingCoefficientSuspension, fullSolidDeflection)

% Inner housing diameter of damper
innerHousingDiameterOfDamper = outerHousingDiameterOfDamper - (2 * damperwallThickness); % m

% Diameter of the piston, with a 0.5[mm] all-around clearance from the
% damper's inner housing diameter
DiameterofPiston = innerHousingDiameterOfDamper - 0.001; % m

% Number of orifices (holes) in the piston will be 3 as it is considered a 
% pretty standard number to have throughout most FSAE events.
numberOfOrifices = 3;

% SAE 30 oil is used for the damper which has the following 
% Coefficient of dynamic viscosity at 40 degrees C:
coefficientDynamicViscosity = 144; % N*s/m^2

% Orifice diameter calculation, derived from Navier-Stokes refer to Analysis report for derivation
orificeDiameter = abs(((DiameterofPiston^2)-(sqrt( (dampingCoefficientSuspension*(DiameterofPiston^4)) / (8*pi*coefficientDynamicViscosity*fullSolidDeflection) ))) / numberOfOrifices); % m

end