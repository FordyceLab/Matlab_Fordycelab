## Matlab code for controlling Microfluidic devices in the Fordyce and Thorn labs

### Configuration files that must be edited in a new install

Common/WagoController.txt must be edited to specify the IP address of the Wago controller
and the number of valves and their status (normally open or closed). If this file does not
exist, rename WagoController_DEFAULT.txt and edit it.