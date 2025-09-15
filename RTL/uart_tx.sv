import uart_pkg::*;


module uart_tx #(
parameter int unsigned DATA_BITS = 8,
parameter int unsigned STOP_BITS = 1,
parameter parity_e PARITY_MODE = PARITY_NONE
) (
input logic clk,
input logic rst_n,
input logic bit_tick, // 1-cycle per bit time
// Stream in
input logic tx_valid,
input logic [DATA_BITS-1:0] tx_data,
output logic tx_ready,
// Line out
output logic txd
);
typedef enum logic [2:0] {S_IDLE, S_START, S_DATA, S_PARITY, S_STOP} state_e;


state_e state, nstate;
logic [DATA_BITS-1:0] shreg;
logic [$clog2(DATA_BITS):0] bit_idx;
logic [1:0] stop_cnt;
logic parity_bit;


// combinational parity of data
function logic parity_calc(input logic [DATA_BITS-1:0] d);
logic p;
begin
p = ^d; // XOR reduction (1 if odd number of 1s)
case (PARITY_MODE)
PARITY_EVEN: parity_calc = ~p; // even => parity bit makes total #1s even
PARITY_ODD : parity_calc = p; // odd => parity bit makes total #1s odd
default : parity_calc = 1'b0; // unused when no parity
endcase
end
endfunction


// output defaults
assign tx_ready = (state == S_IDLE);


// State machine
always_ff @(posedge clk or negedge rst_n) begin
if (!rst_n) begin
state <= S_IDLE;
shreg <= '0;
bit_idx <= '0;
stop_cnt <= '0;
txd <= 1'b1; // idle high
parity_bit<= 1'b0;
end else begin
if (state == S_IDLE) begin
txd <= 1'b1;
if (tx_valid) begin
shreg <= tx_data;
parity_bit <= parity_calc(tx_data);
bit_idx <= '0;
stop_cnt <= '0;
state <= S_START;
endmodule
