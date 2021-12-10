_________________________________________________________________

FSAE2 

Team Members:
Abdalaziz AlGhoul
Hisham Ali
Hasan Shazad
Munir Alsafi
Peter Saroufim

_________________________________________________________________

How to run the parametrization:

The parametrization can be ran from the MAIN.m file found in the MATLAB folder.
Running this program in MATLAB opens the GUI. The GUI has buttons to alter the input
parameters of the vehicle, alongside a button at the bottom of the GUI to re-generate
the vehicle assembly.

On the right of the GUI is an output log of the parameters that are calculated with the 
given inputs.

Once the dialog window claiming 'Successfully optimized' is shown, please re-build the solidworks
assembly to view the optimzed vehicle.

When the parameters are generated, the main differences can be found in the following assemblies

Solidworks\Steering\Updated Steering\Steering Rack and Pinion\Rack and Pinion

Solidworks\Suspension\SubAssemblies\Shock_Absorber_Assembly
Solidworks\Suspension\SubAssemblies\FLCALeft_Assembly
Solidworks\Suspension\SubAssemblies\FLCARight_Assembly
Solidworks\Suspension\SubAssemblies\FPushrod_Assembly
Solidworks\Suspension\SubAssemblies\FUCA_Assembly
Solidworks\Suspension\SubAssemblies\RLCALeft_Assembly
Solidworks\Suspension\SubAssemblies\RLCARight_Assembly
Solidworks\Suspension\SubAssemblies\RPushrod_Assembly

Solidworks\Chassis with Panels

_________________________________________________________________

Locations of Files:

[GroupFSAE2]
--> Log: Contains the output log while generating the updated design of the vehicle

--> MATLAB: Contains all of the programming code
-----> MAIN.m: Main matlab file that runs the GUI
-----> Subfunctions: Contains subfunctions that are used within the MAIN.m file

--> Reports: Contains all past written reports alongside the overleaf zips

--> Solidworks: Contains the main assembly and sub-assemblies
-----> Assembly.SLDASM: Main Vehicle assembly that gets updated with the parameters
-----> Equations: Contains the equation and parameters used in the solidworks parts
-----> Rest of the folders: Contains the subassemblies and parts

--> Excel Modelling: Contains the excel sheets used to model the vehicle

