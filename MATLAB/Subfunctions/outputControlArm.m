% =========================================================================
%   Function: 
%
%   Parameters: 
%   
%   Outputs: 
%
%   Description:
% =========================================================================
function outputControlArm(innerDiameter)

    file = 'H:\\groupFSAE2\\SolidWorks\\Equations\\Control_Arm_Inner_Diameters.txt';
    
    %Write the equations file
    fid = fopen(file,'w+t');
    fprintf(fid,strcat('"CA_ID"= '," ",num2str(innerDiameter),'\n\n'));
    fprintf(fid,strcat('"D2@Sketch5"="CA_ID"\n\n'));
    fprintf(fid,strcat('"D2@Sketch6"="CA_ID"\n\n'));
    fprintf(fid,strcat('"tube_end_to_ball_center" = 31.721675mm\n\n'));
    fprintf(fid,strcat('"D6@Sketch3"="tube_end_to_ball_center"\n\n'));
    fprintf(fid,strcat('"D5@Sketch3"="tube_end_to_ball_center"\n\n'));

    fclose(fid);

end