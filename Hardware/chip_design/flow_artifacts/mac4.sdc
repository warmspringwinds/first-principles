# mac4.sdc -- the entire timing contract with the outside world
create_clock -name clk -period 1.0 [get_ports clk]                 ;# 1 GHz
set_clock_transition 0.03 [get_clocks clk]                         ;# 30 ps clock edges at the flops
set DATA_IN [remove_from_collection [all_inputs] [get_ports clk]]  ;# the clock port is not a data input
set_input_delay  0.10 -clock clk $DATA_IN                          ;# inputs arrive 100 ps after the edge
set_output_delay 0.10 -clock clk [all_outputs]                     ;# outputs must be ready 100 ps early
set_input_transition 0.02 $DATA_IN                                 ;# 20 ps edges from outside
