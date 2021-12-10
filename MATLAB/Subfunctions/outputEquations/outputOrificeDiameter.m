% =========================================================================
%   Function: 
%
%   Parameters: 
%   
%   Outputs: 
%
%   Description:
% =========================================================================
function outputOrificeDiameter(orificeDiameter)

    file = 'H:\\groupFSAE2\\SolidWorks\\Equations\\Orifice_Diameter_Equations.txt';
    
    %Write the equations file
    fid = fopen(file,'w+t');
    
    fprintf(fid,strcat('"OrificeDiameter"= '," ",num2str(orificeDiameter), '\n\n'));
    fprintf(fid,strcat('"D4@Sketch2"="OrificeDiameter"'));

    fclose(fid);

end