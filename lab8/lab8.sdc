set_time_format -unit ns -decimal_places 3
create_clock -name {altera_reserved_tck} -period 100.000 -waveform { 0.000 50.000 } [get_ports {altera_reserved_tck}]
create_clock -name {main_clk_50} -period 20.000 -waveform { 0.000 10.000 } [get_ports {CLOCK_50}]
create_generated_clock -name {m_lab7_soc|sdram_pll|sd1|pll7|clk[0]} -source [get_pins {m_lab7_soc|sdram_pll|sd1|pll7|inclk[0]}] -duty_cycle 50.000 -multiply_by 1 -phase -54.000 -master_clock {main_clk_50} [get_pins {m_lab7_soc|sdram_pll|sd1|pll7|clk[0]}]
create_generated_clock -name {m_lab7_soc|sdram_pll|sd1|pll7|clk[1]} -source [get_pins {m_lab7_soc|sdram_pll|sd1|pll7|inclk[0]}] -duty_cycle 50.000 -multiply_by 1 -phase -54.000 -master_clock {main_clk_50} [get_pins {m_lab7_soc|sdram_pll|sd1|pll7|clk[1]}]
set_input_delay -add_delay -max -clock [get_clocks {main_clk_50}]  3.000 [get_ports {altera_reserved_tck}]
set_input_delay -add_delay -min -clock [get_clocks {main_clk_50}]  2.000 [get_ports {altera_reserved_tck}]
set_input_delay -add_delay -max -clock [get_clocks {main_clk_50}]  3.000 [get_ports {altera_reserved_tdi}]
set_input_delay -add_delay -min -clock [get_clocks {main_clk_50}]  2.000 [get_ports {altera_reserved_tdi}]
set_input_delay -add_delay -max -clock [get_clocks {main_clk_50}]  3.000 [get_ports {altera_reserved_tms}]
set_input_delay -add_delay -min -clock [get_clocks {main_clk_50}]  2.000 [get_ports {altera_reserved_tms}]
set_output_delay -add_delay  -clock [get_clocks {main_clk_50}]  2.000 [get_ports {altera_reserved_tdo}]
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}]
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}]
set_false_path -from [get_registers {*altera_avalon_st_clock_crosser:*|in_data_buffer*}] -to [get_registers {*altera_avalon_st_clock_crosser:*|out_data_buffer*}]
set_false_path -to [get_keepers {*altera_std_synchronizer:*|din_s1}]
set_false_path -to [get_pins -nocase -compatibility_mode {*|alt_rst_sync_uq1|altera_reset_synchronizer_int_chain*|clrn}]
set_false_path -from [get_keepers {*lab7_soc_nios2_qsys_0:*|lab7_soc_nios2_qsys_0_nios2_oci:the_lab7_soc_nios2_qsys_0_nios2_oci|lab7_soc_nios2_qsys_0_nios2_oci_break:the_lab7_soc_nios2_qsys_0_nios2_oci_break|break_readreg*}] -to [get_keepers {*lab7_soc_nios2_qsys_0:*|lab7_soc_nios2_qsys_0_nios2_oci:the_lab7_soc_nios2_qsys_0_nios2_oci|lab7_soc_nios2_qsys_0_jtag_debug_module_wrapper:the_lab7_soc_nios2_qsys_0_jtag_debug_module_wrapper|lab7_soc_nios2_qsys_0_jtag_debug_module_tck:the_lab7_soc_nios2_qsys_0_jtag_debug_module_tck|*sr*}]
set_false_path -from [get_keepers {*lab7_soc_nios2_qsys_0:*|lab7_soc_nios2_qsys_0_nios2_oci:the_lab7_soc_nios2_qsys_0_nios2_oci|lab7_soc_nios2_qsys_0_nios2_oci_debug:the_lab7_soc_nios2_qsys_0_nios2_oci_debug|*resetlatch}] -to [get_keepers {*lab7_soc_nios2_qsys_0:*|lab7_soc_nios2_qsys_0_nios2_oci:the_lab7_soc_nios2_qsys_0_nios2_oci|lab7_soc_nios2_qsys_0_jtag_debug_module_wrapper:the_lab7_soc_nios2_qsys_0_jtag_debug_module_wrapper|lab7_soc_nios2_qsys_0_jtag_debug_module_tck:the_lab7_soc_nios2_qsys_0_jtag_debug_module_tck|*sr[33]}]
set_false_path -from [get_keepers {*lab7_soc_nios2_qsys_0:*|lab7_soc_nios2_qsys_0_nios2_oci:the_lab7_soc_nios2_qsys_0_nios2_oci|lab7_soc_nios2_qsys_0_nios2_oci_debug:the_lab7_soc_nios2_qsys_0_nios2_oci_debug|monitor_ready}] -to [get_keepers {*lab7_soc_nios2_qsys_0:*|lab7_soc_nios2_qsys_0_nios2_oci:the_lab7_soc_nios2_qsys_0_nios2_oci|lab7_soc_nios2_qsys_0_jtag_debug_module_wrapper:the_lab7_soc_nios2_qsys_0_jtag_debug_module_wrapper|lab7_soc_nios2_qsys_0_jtag_debug_module_tck:the_lab7_soc_nios2_qsys_0_jtag_debug_module_tck|*sr[0]}]
set_false_path -from [get_keepers {*lab7_soc_nios2_qsys_0:*|lab7_soc_nios2_qsys_0_nios2_oci:the_lab7_soc_nios2_qsys_0_nios2_oci|lab7_soc_nios2_qsys_0_nios2_oci_debug:the_lab7_soc_nios2_qsys_0_nios2_oci_debug|monitor_error}] -to [get_keepers {*lab7_soc_nios2_qsys_0:*|lab7_soc_nios2_qsys_0_nios2_oci:the_lab7_soc_nios2_qsys_0_nios2_oci|lab7_soc_nios2_qsys_0_jtag_debug_module_wrapper:the_lab7_soc_nios2_qsys_0_jtag_debug_module_wrapper|lab7_soc_nios2_qsys_0_jtag_debug_module_tck:the_lab7_soc_nios2_qsys_0_jtag_debug_module_tck|*sr[34]}]
set_false_path -from [get_keepers {*lab7_soc_nios2_qsys_0:*|lab7_soc_nios2_qsys_0_nios2_oci:the_lab7_soc_nios2_qsys_0_nios2_oci|lab7_soc_nios2_qsys_0_nios2_ocimem:the_lab7_soc_nios2_qsys_0_nios2_ocimem|*MonDReg*}] -to [get_keepers {*lab7_soc_nios2_qsys_0:*|lab7_soc_nios2_qsys_0_nios2_oci:the_lab7_soc_nios2_qsys_0_nios2_oci|lab7_soc_nios2_qsys_0_jtag_debug_module_wrapper:the_lab7_soc_nios2_qsys_0_jtag_debug_module_wrapper|lab7_soc_nios2_qsys_0_jtag_debug_module_tck:the_lab7_soc_nios2_qsys_0_jtag_debug_module_tck|*sr*}]
set_false_path -from [get_keepers {*lab7_soc_nios2_qsys_0:*|lab7_soc_nios2_qsys_0_nios2_oci:the_lab7_soc_nios2_qsys_0_nios2_oci|lab7_soc_nios2_qsys_0_jtag_debug_module_wrapper:the_lab7_soc_nios2_qsys_0_jtag_debug_module_wrapper|lab7_soc_nios2_qsys_0_jtag_debug_module_tck:the_lab7_soc_nios2_qsys_0_jtag_debug_module_tck|*sr*}] -to [get_keepers {*lab7_soc_nios2_qsys_0:*|lab7_soc_nios2_qsys_0_nios2_oci:the_lab7_soc_nios2_qsys_0_nios2_oci|lab7_soc_nios2_qsys_0_jtag_debug_module_wrapper:the_lab7_soc_nios2_qsys_0_jtag_debug_module_wrapper|lab7_soc_nios2_qsys_0_jtag_debug_module_sysclk:the_lab7_soc_nios2_qsys_0_jtag_debug_module_sysclk|*jdo*}]
set_false_path -from [get_keepers {sld_hub:*|irf_reg*}] -to [get_keepers {*lab7_soc_nios2_qsys_0:*|lab7_soc_nios2_qsys_0_nios2_oci:the_lab7_soc_nios2_qsys_0_nios2_oci|lab7_soc_nios2_qsys_0_jtag_debug_module_wrapper:the_lab7_soc_nios2_qsys_0_jtag_debug_module_wrapper|lab7_soc_nios2_qsys_0_jtag_debug_module_sysclk:the_lab7_soc_nios2_qsys_0_jtag_debug_module_sysclk|ir*}]
set_false_path -from [get_keepers {sld_hub:*|sld_shadow_jsm:shadow_jsm|state[1]}] -to [get_keepers {*lab7_soc_nios2_qsys_0:*|lab7_soc_nios2_qsys_0_nios2_oci:the_lab7_soc_nios2_qsys_0_nios2_oci|lab7_soc_nios2_qsys_0_nios2_oci_debug:the_lab7_soc_nios2_qsys_0_nios2_oci_debug|monitor_go}]
