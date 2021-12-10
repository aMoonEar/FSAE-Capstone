% =========================================================================
%   Function: 
%
%   Parameters: 
%   
%   Outputs: 
%
%   Description:
% =========================================================================
function outputRackLength(rackLength)

    file = 'H:\\groupFSAE2\\SolidWorks\\Equations\\rack_length.txt';
    
    %Write the equations file
    fid = fopen(file,'w+t');
    
    fprintf(fid,strcat('"rack_length"= '," ",num2str(rackLength), 'mm\n\n'));
    fprintf(fid,strcat('"Rack Length@Sketch1" = "rack_length"'));

    fclose(fid);

end