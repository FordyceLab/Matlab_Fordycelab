## Matlab code for controlling Microfluidic devices in the Fordyce and Thorn labs

### Code dependencies

#### Scope control via Micro-manager
To use the Scope object that allows control of the microscope through Micro-manager, 
Micro-manager must be configured in Matlab as described here: https://micro-manager.org/wiki/Matlab_Configuration

#### MFCS-EZ
The Matlab toolkit for the MFCS-EZ must be installed. Instructions are on the Keck wiki here: https://honeybee.ucsf.edu/groups/keck/wiki/ac4d6/Installing_MFCSEZ_Matlab_toolbox.html

### Configuration files that must be edited in a new install

Common/WagoController.txt must be edited to specify the IP address of the Wago controller
and the number of valves and their status (normally open or closed). If this file does not
exist, rename WagoController_DEFAULT.txt and edit it.

ChipDevice/ValveNumbers.txt where ChipDevice is any of the chip folders in the install. 
This file must specify the assignments of valves on the chip to controller lines. There 
should be a ValveNumbers_DEFAULT.txt file with the correct syntax.