# MCDMA
Vivado/Vitis 2023.2

## FPGA/HW build:
scripts folder
> tclsh run.tcl

## SW build:
sw/scripts folder
> vitis -s builder.py 


### Debug config
uart/com : sudo gtkterm
/dev/ttyUSB1 115200-8-N-1

### simulation (with mcdma_bd BDC)
Yikes BDCs! Doesn't work by default.
- Must set mcdma_bd_wrapper as top level in 'Design Sources', not just 'Simulation Sources'. Must first change to used in synth and impl as my script sets as sim only.
- Next, generate output products for mcdma_bd only. Also generate output products for the 3 axi IP.
- Sim should now run.
* Very tedious, abandoning BDCs for now.

### Note on BDCs
Using BDCs abandoned temporarily 8/14/24, xparameters.h is not populated with IP when build in non-project mode.
This does not occur if building using the GUI project mode.