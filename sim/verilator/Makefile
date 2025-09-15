RTL=../../rtl
TB=../../tb
SVA=../../sva


SRC= \
$(RTL)/uart_pkg.sv \
$(RTL)/uart_baud_gen.sv \
$(RTL)/uart_tx.sv \
$(RTL)/uart_rx.sv \
$(RTL)/uart_fifo.sv \
$(RTL)/uart_top.sv \
$(TB)/tb_smoke.sv


# Verilator basic (no UVM yet)
run:
verilator --cc --exe --build -Wall -Wno-UNUSED -Wno-CASEINCOMPLETE --trace \
-sv $(SRC) sim_main.cpp || exit 1; \
./obj_dir/Vtb_smoke


# Minimal C++ harness (auto-generated if missing)
sim_main.cpp:
@echo '#include "Vtb_smoke.h"' > sim_main.cpp; \
echo '#include "verilated.h"' >> sim_main.cpp; \
echo '#include "verilated_vcd_c.h"' >> sim_main.cpp; \
echo 'int main(int argc, char** argv){ Verilated::commandArgs(argc,argv); return 0; }' >> sim_main.cpp;


clean:
rm -rf obj_dir *.vcd sim_main.cpp
