% =========================================================================
%   Function: 
%
%   Parameters: 
%   
%   Outputs: 
%
%   Description:
% =========================================================================
function outputSecondaryShaft(shaftDiameterInner)

    file = 'H:\\groupFSAE2\\SolidWorks\\Equations\\Secondary_Shaft_Equations.txt';
    
    %Write the equations file
    fid = fopen(file,'w+t');
    
    fprintf(fid,strcat('"MinorShaftDiameter"= '," ",num2str(shaftDiameterInner), 'mm\n\n'));
    fprintf(fid,strcat('"D2@Sketch1"="MinorShaftDiameter"'));

    fclose(fid);

end