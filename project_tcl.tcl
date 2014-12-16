# TODO:
# - set variable for project_name (so that it is not hardcoded "pure_hdl_project1")
# - set variable(s) for fileset file(s) (so that it is not hardcoded "frequency_divider")
# - set variable(s) for constraint file(s) (so that it is not hardcoded "constraints1")
# - find a way to check if it is necessary to reset and run the synthesis. If not, jump over!
# - set variable for number of threads when running the launch_runs command. Now it is hardcoded to 8 threads (j 8).

# THE SCRIPT BEGINS:

# Set the reference directory for source file relative paths (by default the value is script directory path)
set origin_dir "."

# Set the directory path for the original project from where this script was exported
set orig_proj_dir "[file normalize "$origin_dir/"]"

# Try to open the project. If the project cannot be opened (it does not exist), create the project (else branch)
set project_found [llength [open_project -quiet ./pure_hdl_project1/pure_hdl_project1.xpr]]
puts $project_found
if {$project_found > 0} {
    puts "Project Found."
} else {
    puts "No Projects Found."
    create_project pure_hdl_project1 ./pure_hdl_project1
}

# Set the directory path for the new project
set proj_dir [get_property directory [current_project]]

# Set project properties
set obj [get_projects pure_hdl_project1]
set_property "board_part" "em.avnet.com:zed:part0:1.2" $obj
set_property "default_lib" "xil_defaultlib" $obj
set_property "simulator_language" "Mixed" $obj
set_property "target_language" "VHDL" $obj

# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}

# Set 'sources_1' fileset object, adding the project files
set obj [get_filesets sources_1]
set files [list \
 "[file normalize "$origin_dir/hdl_sources/frequency_divider.vhd"]"\
]
add_files -norecurse -fileset $obj $files

# Set 'sources_1' fileset file properties for remote files
set file "$origin_dir/hdl_sources/frequency_divider.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "VHDL" $file_obj

# Set 'sources_1' fileset file properties for local files
# None

# Set 'sources_1' fileset properties
set obj [get_filesets sources_1]
set_property "top" "frequency_divider" $obj

# Create 'constrs_1' fileset (if not found)
if {[string equal [get_filesets -quiet constrs_1] ""]} {
  create_fileset -constrset constrs_1
}

# Set 'constrs_1' fileset object
set obj [get_filesets constrs_1]

# Add/Import constrs file and set constrs file properties
set file "[file normalize "$origin_dir/constrs_1/new/constraints1.xdc"]"
set file_added [add_files -norecurse -fileset $obj $file]
set file "$origin_dir/constrs_1/new/constraints1.xdc"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets constrs_1] [list "*$file"]]
set_property "file_type" "XDC" $file_obj

# Set 'constrs_1' fileset properties
set obj [get_filesets constrs_1]
set_property "target_constrs_file" "$orig_proj_dir/constrs_1/new/constraints1.xdc" $obj

# Create 'sim_1' fileset (if not found)
if {[string equal [get_filesets -quiet sim_1] ""]} {
  create_fileset -simset sim_1
}

# Set 'sim_1' fileset object
set obj [get_filesets sim_1]
# Empty (no sources present)

# Set 'sim_1' fileset properties
set obj [get_filesets sim_1]
set_property "top" "frequency_divider" $obj

# Create 'synth_1' run (if not found)
if {[string equal [get_runs -quiet synth_1] ""]} {
  create_run -name synth_1 -part xc7z020clg484-1 -flow {Vivado Synthesis 2014} -strategy "Vivado Synthesis Defaults" -constrset constrs_1
} else {
  set_property strategy "Vivado Synthesis Defaults" [get_runs synth_1]
  set_property flow "Vivado Synthesis 2014" [get_runs synth_1]
}
set obj [get_runs synth_1]

# set the current synth run
current_run -synthesis [get_runs synth_1]

# Create 'impl_1' run (if not found)
if {[string equal [get_runs -quiet impl_1] ""]} {
  create_run -name impl_1 -part xc7z020clg484-1 -flow {Vivado Implementation 2014} -strategy "Vivado Implementation Defaults" -constrset constrs_1 -parent_run synth_1
} else {
  set_property strategy "Vivado Implementation Defaults" [get_runs impl_1]
  set_property flow "Vivado Implementation 2014" [get_runs impl_1]
}
set obj [get_runs impl_1]

# set the current impl run
current_run -implementation [get_runs impl_1]

puts "INFO: Project created:pure_hdl_project1"

# start the synthesis flow:
# NOTE: at the moment I give a reset_run, forcing to re-synthesize the system
#       I need to find a way to check if the synthesis should be updated or not,
#       and eventually skip it.
reset_run synth_1
launch_runs synth_1 -jobs 8
wait_on_run synth_1
puts "INFO: Synthesis synth_1 completed"

# start the implementation flow
launch_runs impl_1 -jobs 8
wait_on_run impl_1
puts "INFO: Implementation impl_1 completed"

# create bitstream
open_run impl_1
write_bitstream -force design1.bit
puts "INFO: Generation of bitstream completed"

#################################################################################

# DOWN HERE: some useful examples/commands

#################################################################################

# start_gui
# create_project led_controller /home/osso/Projects/Vivado_test/led_controller -part xc7z020clg484-1
# set_property board_part em.avnet.com:zed:part0:1.2 [current_project]
# set_property target_language VHDL [current_project]


# start_gui
# open_project /home/osso/Projects/Vivado_test/zynq_interrupts/zynq_interrupts.xpr
# open_bd_design {/home/osso/Projects/Vivado_test/zynq_interrupts/zynq_interrupts.srcs/sources_1/bd/zynq_interrupt_system/zynq_interrupt_system.bd}
# startgroup
# create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 axi_timer_0
# endgroup
# apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" Clk "Auto" }  [get_bd_intf_pins axi_timer_0/S_AXI]
# startgroup
# create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0
# endgroup
# delete_bd_objs [get_bd_nets axi_gpio_0_ip2intc_irpt]
# connect_bd_net [get_bd_pins xlconcat_0/dout] [get_bd_pins processing_system7_0/IRQ_F2P]
# regenerate_bd_layout
# connect_bd_net [get_bd_pins axi_timer_0/interrupt] [get_bd_pins xlconcat_0/In1]
# connect_bd_net [get_bd_pins axi_gpio_0/ip2intc_irpt] [get_bd_pins xlconcat_0/In0]
# regenerate_bd_layout
# make_wrapper -files [get_files /home/osso/Projects/Vivado_test/zynq_interrupts/zynq_interrupts.srcs/sources_1/bd/zynq_interrupt_system/zynq_interrupt_system.bd] -top
# save_bd_design
# reset_run synth_1
# launch_runs impl_1 -to_step write_bitstream
# wait_on_run impl_1
# open_run impl_1
# report_utilization -name utilization_1
# file copy -force /home/osso/Projects/Vivado_test/zynq_interrupts/zynq_interrupts.runs/impl_1/zynq_interrupt_system_wrapper.sysdef /home/osso/Projects/Vivado_test/zynq_interrupts/zynq_interrupts.sdk/zynq_interrupt_system_wrapper.hdf

# launch_sdk -workspace /home/osso/Projects/Vivado_test/zynq_interrupts/zynq_interrupts.sdk -hwspec /home/osso/Projects/Vivado_test/zynq_interrupts/zynq_interrupts.sdk/zynq_interrupt_system_wrapper.hdf
