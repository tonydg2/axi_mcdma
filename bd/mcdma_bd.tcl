
################################################################
# This is a generated script based on design: mcdma_bd
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2023.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   if { [string compare $scripts_vivado_version $current_vivado_version] > 0 } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2042 -severity "ERROR" " This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Sourcing the script failed since it was created with a future version of Vivado."}

   } else {
     catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   }

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source mcdma_bd_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# axil_reg32, axis_stim_syn_vwrap, user_init_64b_wrapper_zynq

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xczu3eg-sbva484-1-i
   set_property BOARD_PART avnet.com:ultra96v2:part0:1.2 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name mcdma_bd

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:blk_mem_gen:8.4\
xilinx.com:ip:axi_bram_ctrl:4.1\
xilinx.com:ip:axi_mcdma:1.1\
xilinx.com:ip:smartconnect:1.0\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:proc_sys_reset:5.0\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
axil_reg32\
axis_stim_syn_vwrap\
user_init_64b_wrapper_zynq\
"

   set list_mods_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2020 -severity "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2021 -severity "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_gid_msg -ssname BD::TCL -id 2022 -severity "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set M_AXIS_MM2S [ create_bd_intf_port -mode Monitor -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_MM2S ]
  set_property -dict [ list \
   CONFIG.HAS_TKEEP {1} \
   CONFIG.HAS_TLAST {1} \
   CONFIG.HAS_TSTRB {1} \
   CONFIG.TDATA_NUM_BYTES {4} \
   CONFIG.TDEST_WIDTH {4} \
   CONFIG.TID_WIDTH {8} \
   CONFIG.TUSER_WIDTH {16} \
   ] $M_AXIS_MM2S

  set S00_AXI [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {40} \
   CONFIG.ARUSER_WIDTH {16} \
   CONFIG.AWUSER_WIDTH {16} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {0} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {16} \
   CONFIG.MAX_BURST_LENGTH {256} \
   CONFIG.NUM_READ_OUTSTANDING {8} \
   CONFIG.NUM_READ_THREADS {4} \
   CONFIG.NUM_WRITE_OUTSTANDING {8} \
   CONFIG.NUM_WRITE_THREADS {4} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S00_AXI

  set S_AXI [ create_bd_intf_port -mode Monitor -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {15} \
   CONFIG.ARUSER_WIDTH {4} \
   CONFIG.AWUSER_WIDTH {4} \
   CONFIG.BUSER_WIDTH {1} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.ID_WIDTH {1} \
   CONFIG.MAX_BURST_LENGTH {16} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.RUSER_WIDTH {1} \
   CONFIG.SUPPORTS_NARROW_BURST {0} \
   CONFIG.WUSER_WIDTH {1} \
   ] $S_AXI


  # Create ports
  set ext_reset_in [ create_bd_port -dir I -type rst ext_reset_in ]
  set s_axi_aclk [ create_bd_port -dir I -type clk s_axi_aclk ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S00_AXI:M_AXIS_MM2S:S_AXI} \
 ] $s_axi_aclk

  # Create instance: MEMORY_BRAM, and set properties
  set MEMORY_BRAM [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 MEMORY_BRAM ]
  set_property -dict [list \
    CONFIG.Enable_B {Use_ENB_Pin} \
    CONFIG.Memory_Type {True_Dual_Port_RAM} \
    CONFIG.Port_B_Clock {100} \
    CONFIG.Port_B_Enable_Rate {100} \
    CONFIG.Port_B_Write_Rate {50} \
    CONFIG.Use_RSTB_Pin {true} \
  ] $MEMORY_BRAM


  # Create instance: MEM_BRAM_CTRL, and set properties
  set MEM_BRAM_CTRL [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 MEM_BRAM_CTRL ]

  # Create instance: SG_BRAM, and set properties
  set SG_BRAM [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 SG_BRAM ]
  set_property -dict [list \
    CONFIG.Assume_Synchronous_Clk {true} \
    CONFIG.Enable_B {Use_ENB_Pin} \
    CONFIG.Memory_Type {True_Dual_Port_RAM} \
    CONFIG.Port_B_Clock {100} \
    CONFIG.Port_B_Enable_Rate {100} \
    CONFIG.Port_B_Write_Rate {50} \
    CONFIG.Use_RSTB_Pin {true} \
  ] $SG_BRAM


  # Create instance: SG_BRAM_CTRL, and set properties
  set SG_BRAM_CTRL [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 SG_BRAM_CTRL ]

  # Create instance: axi_mcdma_0, and set properties
  set axi_mcdma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_mcdma:1.1 axi_mcdma_0 ]
  set_property -dict [list \
    CONFIG.c_group1_mm2s {0000000000000011} \
    CONFIG.c_group1_s2mm {0000000000000011} \
    CONFIG.c_num_mm2s_channels {2} \
    CONFIG.c_num_s2mm_channels {2} \
  ] $axi_mcdma_0


  # Create instance: axi_smc, and set properties
  set axi_smc [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axi_smc ]
  set_property -dict [list \
    CONFIG.NUM_MI {3} \
    CONFIG.NUM_SI {2} \
  ] $axi_smc


  # Create instance: axi_smc1, and set properties
  set axi_smc1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axi_smc1 ]
  set_property -dict [list \
    CONFIG.NUM_MI {1} \
    CONFIG.NUM_SI {2} \
  ] $axi_smc1


  # Create instance: axil_reg32_0, and set properties
  set block_name axil_reg32
  set block_cell_name axil_reg32_0
  if { [catch {set axil_reg32_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $axil_reg32_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: axis_stim_syn_vwrap_0, and set properties
  set block_name axis_stim_syn_vwrap
  set block_cell_name axis_stim_syn_vwrap_0
  if { [catch {set axis_stim_syn_vwrap_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $axis_stim_syn_vwrap_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: const_0, and set properties
  set const_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 const_0 ]
  set_property CONFIG.CONST_VAL {0} $const_0


  # Create instance: const_1, and set properties
  set const_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 const_1 ]

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: user_init, and set properties
  set block_name user_init_64b_wrapper_zynq
  set block_cell_name user_init
  if { [catch {set user_init [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $user_init eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create interface connections
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins MEMORY_BRAM/BRAM_PORTA] [get_bd_intf_pins MEM_BRAM_CTRL/BRAM_PORTA]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTB [get_bd_intf_pins MEMORY_BRAM/BRAM_PORTB] [get_bd_intf_pins MEM_BRAM_CTRL/BRAM_PORTB]
  connect_bd_intf_net -intf_net axi_bram_ctrl_1_BRAM_PORTA [get_bd_intf_pins SG_BRAM_CTRL/BRAM_PORTA] [get_bd_intf_pins SG_BRAM/BRAM_PORTA]
  connect_bd_intf_net -intf_net axi_bram_ctrl_1_BRAM_PORTB [get_bd_intf_pins SG_BRAM_CTRL/BRAM_PORTB] [get_bd_intf_pins SG_BRAM/BRAM_PORTB]
connect_bd_intf_net -intf_net axi_mcdma_0_M_AXIS_MM2S [get_bd_intf_pins axi_mcdma_0/M_AXIS_MM2S] [get_bd_intf_ports M_AXIS_MM2S]
  connect_bd_intf_net -intf_net axi_mcdma_0_M_AXI_MM2S [get_bd_intf_pins axi_smc1/S00_AXI] [get_bd_intf_pins axi_mcdma_0/M_AXI_MM2S]
  connect_bd_intf_net -intf_net axi_mcdma_0_M_AXI_S2MM [get_bd_intf_pins axi_mcdma_0/M_AXI_S2MM] [get_bd_intf_pins axi_smc1/S01_AXI]
  connect_bd_intf_net -intf_net axi_mcdma_0_M_AXI_SG [get_bd_intf_pins axi_mcdma_0/M_AXI_SG] [get_bd_intf_pins axi_smc/S01_AXI]
  connect_bd_intf_net -intf_net axi_smc1_M00_AXI [get_bd_intf_pins MEM_BRAM_CTRL/S_AXI] [get_bd_intf_pins axi_smc1/M00_AXI]
connect_bd_intf_net -intf_net [get_bd_intf_nets axi_smc1_M00_AXI] [get_bd_intf_pins MEM_BRAM_CTRL/S_AXI] [get_bd_intf_ports S_AXI]
  connect_bd_intf_net -intf_net axi_smc_M00_AXI [get_bd_intf_pins axi_smc/M00_AXI] [get_bd_intf_pins axi_mcdma_0/S_AXI_LITE]
  connect_bd_intf_net -intf_net axi_smc_M01_AXI [get_bd_intf_pins axi_smc/M01_AXI] [get_bd_intf_pins SG_BRAM_CTRL/S_AXI]
  connect_bd_intf_net -intf_net axi_smc_M02_AXI [get_bd_intf_pins axi_smc/M02_AXI] [get_bd_intf_pins axil_reg32_0/S_AXI]
  connect_bd_intf_net -intf_net axis_stim_syn_vwrap_0_M_AXIS [get_bd_intf_pins axis_stim_syn_vwrap_0/M_AXIS] [get_bd_intf_pins axi_mcdma_0/S_AXIS_S2MM]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_M_AXI_HPM0_FPD [get_bd_intf_ports S00_AXI] [get_bd_intf_pins axi_smc/S00_AXI]

  # Create port connections
  connect_bd_net -net axi_resetn_0_1 [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins MEM_BRAM_CTRL/s_axi_aresetn] [get_bd_pins SG_BRAM_CTRL/s_axi_aresetn] [get_bd_pins axi_mcdma_0/axi_resetn]
  connect_bd_net -net proc_sys_reset_0_interconnect_aresetn [get_bd_pins proc_sys_reset_0/interconnect_aresetn] [get_bd_pins axi_smc1/aresetn] [get_bd_pins axi_smc/aresetn] [get_bd_pins axil_reg32_0/S_AXI_ARESETN]
  connect_bd_net -net proc_sys_reset_0_peripheral_reset [get_bd_pins proc_sys_reset_0/peripheral_reset] [get_bd_pins axis_stim_syn_vwrap_0/rst]
  connect_bd_net -net s_axi_lite_aclk_0_1 [get_bd_ports s_axi_aclk] [get_bd_pins MEM_BRAM_CTRL/s_axi_aclk] [get_bd_pins SG_BRAM_CTRL/s_axi_aclk] [get_bd_pins axi_mcdma_0/s_axi_aclk] [get_bd_pins axi_mcdma_0/s_axi_lite_aclk] [get_bd_pins axis_stim_syn_vwrap_0/clk] [get_bd_pins axi_smc1/aclk] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins axil_reg32_0/S_AXI_ACLK] [get_bd_pins axi_smc/aclk]
  connect_bd_net -net user_init_64b_wrappe_0_usr_access_data_o [get_bd_pins user_init/usr_access_data_o] [get_bd_pins axil_reg32_0/timestamp]
  connect_bd_net -net user_init_64b_wrappe_0_value_o [get_bd_pins user_init/value_o] [get_bd_pins axil_reg32_0/git_hash]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins const_1/dout] [get_bd_pins axi_mcdma_0/m_axis_mm2s_tready]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins const_0/dout] [get_bd_pins axis_stim_syn_vwrap_0/start]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_resetn0 [get_bd_ports ext_reset_in] [get_bd_pins proc_sys_reset_0/ext_reset_in]

  # Create address segments
  assign_bd_address -offset 0xC0000000 -range 0x00008000 -target_address_space [get_bd_addr_spaces axi_mcdma_0/Data_MM2S] [get_bd_addr_segs MEM_BRAM_CTRL/S_AXI/Mem0] -force
  assign_bd_address -offset 0xC0000000 -range 0x00008000 -target_address_space [get_bd_addr_spaces axi_mcdma_0/Data_S2MM] [get_bd_addr_segs MEM_BRAM_CTRL/S_AXI/Mem0] -force
  assign_bd_address -offset 0xA0010000 -range 0x00002000 -target_address_space [get_bd_addr_spaces axi_mcdma_0/Data_SG] [get_bd_addr_segs SG_BRAM_CTRL/S_AXI/Mem0] -force
  assign_bd_address -offset 0xA0010000 -range 0x00002000 -target_address_space [get_bd_addr_spaces S00_AXI] [get_bd_addr_segs SG_BRAM_CTRL/S_AXI/Mem0] -force
  assign_bd_address -offset 0xA0000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S00_AXI] [get_bd_addr_segs axi_mcdma_0/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0xA0012000 -range 0x00000080 -target_address_space [get_bd_addr_spaces S00_AXI] [get_bd_addr_segs axil_reg32_0/S_AXI/reg0] -force

  # Exclude Address Segments
  exclude_bd_addr_seg -offset 0xA0000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_mcdma_0/Data_SG] [get_bd_addr_segs axi_mcdma_0/S_AXI_LITE/Reg]
  exclude_bd_addr_seg -offset 0xA0012000 -range 0x00000080 -target_address_space [get_bd_addr_spaces axi_mcdma_0/Data_SG] [get_bd_addr_segs axil_reg32_0/S_AXI/reg0]


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


