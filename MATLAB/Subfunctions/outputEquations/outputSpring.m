% =========================================================================
%   Function: 
%
%   Parameters: 
%   
%   Outputs: 
%
%   Description:
% =========================================================================
function outputSpring(meanCoilDiameter, wireDiameter)

    file = 'H:\\groupFSAE2\\SolidWorks\\Equations\\Spring_Equations.txt';
    
    %Write the equations file
    fid = fopen(file,'w+t');
    
    fprintf(fid,strcat('"wireDiameter"= '," ",num2str(wireDiameter), '\n\n'));
    fprintf(fid,strcat('"D1@Sketch83"="wireDiameter"\n\n'));
    fprintf(fid,strcat('"meanDiameter"= '," ",num2str(meanCoilDiameter), '\n\n'));
    fprintf(fid,strcat('"D1@Sketch80"="meanDiameter"'));

    fclose(fid);

end

