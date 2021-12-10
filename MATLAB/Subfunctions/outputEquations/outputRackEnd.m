% =========================================================================
%   Function: 
%
%   Parameters: 
%   
%   Outputs: 
%
%   Description:
% =========================================================================
function outputRackEnd(rackLength)

    file = 'H:\\groupFSAE2\\SolidWorks\\Equations\\rack_end_equations.txt';
    
    %Write the equations file
    fid = fopen(file,'w+t');
    
    fprintf(fid,strcat('"rack_length"= '," ",num2str(rackLength), 'mm\n\n'));
    fprintf(fid,strcat('"rack_end_length"= - 0.5 * "rack_length" + 312.2mm\n\n'));
    fprintf(fid,strcat('"r_end_length@Sketch1"="rack_end_length"'));

    fclose(fid);

end