set_property PACKAGE_PIN Y9 [get_ports clk_in]
set_property IOSTANDARD LVCMOS33 [get_ports clk_in]
set_property PACKAGE_PIN T22 [get_ports clk_out]
set_property IOSTANDARD LVCMOS33 [get_ports clk_out]
set_property PACKAGE_PIN T18 [get_ports reset]
set_property IOSTANDARD LVCMOS18 [get_ports reset]



create_clock -period 10.000 -name clk_in -waveform {0.000 5.000} [get_ports clk_in]
