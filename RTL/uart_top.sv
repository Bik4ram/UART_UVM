import uart_pkg::*;


module uart_top #(
parameter int unsigned CLOCK_HZ = 50_000_000,
parameter int unsigned BAUD_RATE = 115200,
parameter int unsigned OSR = 16,
parameter int unsigned DATA_BITS = 8,
parameter int unsigned STOP_BITS = 1,
parameter parity_e PARITY_MODE= PARITY_NONE
) (
input logic clk,
input logic rst_n,
// Serial lines
input logic rxd,
output logic txd,
// TX stream in
input logic tx_valid,
input logic [DATA_BITS-1:0] tx_data,
output logic tx_ready,
// RX stream out
output logic rx_valid,
output logic [DATA_BITS-1:0] rx_data,
input logic rx_ready,
// Errors
output logic parity_err,
output logic frame_err,
output logic overrun_err
);
logic osr_tick, bit_tick;


uart_baud_gen #(
.CLOCK_HZ (CLOCK_HZ),
.BAUD_RATE(BAUD_RATE),
.OSR (OSR)
) u_baud (
.clk(clk), .rst_n(rst_n),
.osr_tick(osr_tick), .bit_tick(bit_tick)
);


uart_tx #(
.DATA_BITS (DATA_BITS),
.STOP_BITS (STOP_BITS),
.PARITY_MODE(PARITY_MODE)
) u_tx (
.clk(clk), .rst_n(rst_n), .bit_tick(bit_tick),
.tx_valid(tx_valid), .tx_data(tx_data), .tx_ready(tx_ready),
.txd(txd)
);


uart_rx #(
.DATA_BITS (DATA_BITS),
.OSR (OSR),
.STOP_BITS (STOP_BITS),
.PARITY_MODE(PARITY_MODE)
) u_rx (
.clk(clk), .rst_n(rst_n), .osr_tick(osr_tick),
.rxd(rxd),
.rx_valid(rx_valid), .rx_data(rx_data), .rx_ready(rx_ready),
.parity_err(parity_err), .frame_err(frame_err), .overrun_err(overrun_err)
);
endmodule
