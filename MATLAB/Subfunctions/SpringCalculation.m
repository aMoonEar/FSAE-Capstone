% =========================================================================
%   Function: SpringCalculation
%
%   Parameters: springRate (N/m), frontpushrodforce (N)
%   
%   Outputs: meanCoilDiameter (mm), wireDiameter (mm), fullSolidDeflection
%   (mm), innerDiameterSpring (mm)
%
%   Description: Calculates the different parameterized variables for the
%   spring of the shock absorber. We will only be analyzing it for the front
%   spring as it is experiencing the higher forces and thus must satisfy the
%   rear suspension conditions as well. The same spring and damper are used
%   for both the front and rear of the vehicle
% =========================================================================
function [meanCoilDiameter, wireDiameter, innerDiameterSpring, fullSolidDeflection, springrate_N_per_mm] = SpringCalculation(springRate, frontpushrodforce)

    % Assumed initial values
    % Mean Coil Diameter, D
    meanCoilDiameter = 32.5; % mm
    % Wire Diameter, d
    wireDiameter = 5.5; % mm
    
    % Calling the function that calculates the safety factors and verifications for
    % ranges of design
    [condSpringIndex, condActiveCoils, condStability, fatiguesafetyfactor, yieldsafetyfactor, fullSolidDeflection, innerDiameterSpring, springrate_N_per_mm] = SpringSafetyFactors(meanCoilDiameter, wireDiameter, springRate, frontpushrodforce);
    
    % This variable is a flag which holds a false binary value (0 means false)
    keepLooping = 0;
    % MeanCoilDiameter evaluated from initial assumed value to maximum of 200mm
    % to restrict spring within the upper control arm's minimum wishbone spread

    for i = meanCoilDiameter:0.5:50
        % The flag will be toggled to true where 1 is true, when both the
        % MeanCoilDiameter and WireDiameter variables satisfy the if statement 
        %conditions

        if keepLooping == 1
            break
        end
        meanCoilDiameter = i;
        % WireDiameter evaluated from initial assumed value to maximum of 9mm,
        % restriction of manufacturing set for material (Shigley)
        for j = wireDiameter:0.5:9
            if(condSpringIndex == 0 || condActiveCoils == 0 || condStability == 0 || fatiguesafetyfactor < 1.5 || yieldsafetyfactor < 1.2)
                tempWireDiameter = j;
                [condSpringIndex, condActiveCoils, condStability, fatiguesafetyfactor, yieldsafetyfactor, fullSolidDeflection, innerDiameterSpring] = SpringSafetyFactors(meanCoilDiameter, tempWireDiameter, springRate, frontpushrodforce);
            else
                % Final values meeting conditions in if statement
                meanCoilDiameter = i;
                wireDiameter = j-1;
                % Flag toggled to true since both variables meet the conditions
                % in if statement
                keepLooping = 1;
                break
            end
        end
    end
    
    
    end
    
    % ===========================================================================
    %   Function: SpringSafetyFactors
    %
    %   Parameters: meanCoilDiameter (mm), wireDiameter (mm), springRate
    %   (N/mm), frontpushrodforce (N)
    %   
    %   Outputs: condSpringIndex (0 or 1/True or False), condActiveCoils (0 or
    %   1/True or False), condStability (0 or 1/True or False), fatiguesafetyfactor
    %   (unitless), yieldsafetyfactor (unitless), fullSolidDeflection (mm),
    %   innerDiameterSpring (mm)
    %
    %   Description: Calculates all relevant safety factors based on the
    %   spring's parameters, and verifies that they are within the required ratios
    % ===========================================================================
    function [condSpringIndex, condActiveCoils, condStability, fatiguesafetyfactor, yieldsafetyfactor, fullSolidDeflection, innerDiameterSpring, springrate_N_per_mm] = SpringSafetyFactors(meanCoilDiameter, wireDiameter, springRate, frontpushrodforce)
    
    % Material: 302 Stainless Wire - Peened
    
    % Defining the material properties
    % Shear Modulus, G
    shearModulus = 26000; % Mpa

    % Material constants for (used later for UTS)
    A = 2911; % Mpa*mm^m
    m = 0.478;

    % Endurance strength for infinite life for peened springs (used later for safety factor)
    S_sa = 398; % Mpa
        
    % Force when suspension in full rebound (i.e. full extension during a jump, 
    % F_min)
    minimumfrontpushrodforce = 0; % N

    % Amplitude force, F_a
    amplitudeForce = (frontpushrodforce-minimumfrontpushrodforce)/2;

    % Spring rate, called from vibrationAnalysisForSuspension in N/m,converted
    % into to N/mm
    springrate_N_per_mm = springRate/1000; % N/mm

    % Spring's Damping ratio
    zeta = 0.15;
    
    % Calculating Values as illustrated in the Analysis Report
    

    % Inner diameter of the spring, ID
    innerDiameterSpring = meanCoilDiameter - wireDiameter;

    % UTS - Shigley's formula and constants A and m for specified material
    ultimateTensileStrength = A/wireDiameter^m; % Mpa
    
    % Torsional modulus of rupture
    Ssu = 0.67*(UltimateTensileStrength); % N

    % Torsional yield strength
    Ssy = 0.45*(ultimateTensileStrength); % N

    % Spring index, C
    springIndex = meanCoilDiameter/wireDiameter;
    
    % Solid Force, F_s
    solidForce = (1+zeta)*frontpushrodforce; % N

    % Number of active coils, N_a, rounded since it must be an integer
    activeCoils = round(((wireDiameter^4)*shearModulus)/(8*(meanCoilDiameter^3)*springrate_N_per_mm));
    
    % Number of total coils, N_t
    totalCoils = activeCoils + 2;

    % Solid length, L_s
    solidLength = wireDiameter * totalCoils; %mm

    % Free length, L_f
    freeLength = solidLength + (solidForce/springrate_N_per_mm); %mm

    % Full deflection
    fullSolidDeflection = freeLength - solidLength; %mm

    %Spring Force
    springforce = springrate_N_per_mm*fullSolidDeflection % N

    % Correction factor for curvature and direct shear, K_b
    correctionFactorK_b = ((4*springIndex)+2)/((4*springIndex-3));

    % Shear stress amplitude, Tao_a
    shearstress_mplitude = correctionFactorK_b*((8*amplitudeForce*meanCoilDiameter)/(pi*(wireDiameter^3)));

    % Solid shear stress, Tao_s
    solidShearStress = shearstress_mplitude * (solidForce/amplitudeForce);
    
    %Verifying Calculated values fall under the required ranges

    % Spring index verification
    if(springIndex<4) || (springIndex>12)
        condSpringIndex = 0;
    else
        condSpringIndex = 1;
    end
    
    % Active Coils range verification
    if(activeCoils<3) || (activeCoils>15)
        condActiveCoils = 0;
    else
        condActiveCoils = 1;
    end
    
    % Stability verification for Buckling; Squared and ground ends supported between flat parallel surfaces, alpha
    alpha = 0.5;
    stabilityValue = 2.63*(meanCoilDiameter/alpha);
    if(freeLength<stabilityValue)
        condStability = 1;
    else
        condStability = 0;
    end
    
    % Determining the fatigue safety factor
    fatiguesafetyfactor = _/shearstress_mplitude;
    
    % Determining the yielding safety factor
    yieldsafetyfactor = Ssy/solidShearStress;
    
    end