% =========================================================================
%   Function: 
%
%   Parameters: 
%   
%   Outputs: 
%
%   Description:
% =========================================================================
function outputDamperHousing(damperwallThickness, innerHousingDiameterOfDamper)

    file = 'H:\\groupFSAE2\\SolidWorks\\Equations\\Damper_Housing_Equations.txt';
    
    %Write the equations file
    fid = fopen(file,'w+t');
    fprintf(fid,strcat('"OuterHousingDiameter"= 30\n\n'));
    fprintf(fid,strcat('"InnerHousingDiameter"= '," ",num2str(innerHousingDiameterOfDamper),'\n\n'));
    fprintf(fid,strcat('"WallThickness" ='," ",num2str(damperwallThickness)));

    fclose(fid);

end