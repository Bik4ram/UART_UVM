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
$(SVA)/uart_assertions.sv \
$(TB)/tb_smoke.sv


run:
vlib work && vlog -sv $(SRC) && vsim -c tb_smoke -do "run -all; quit"


clean:
rm -rf work transcript vsim.wlf *.log *.jou *.str *.ucdb
