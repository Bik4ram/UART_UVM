// Minimal starter SVAs (bind later). Follow property-instantiation style.


module uart_sva #(parameter int unsigned STOP_BITS = 1) (
input logic clk,
input logic rst_n,
input logic bit_tick,
input logic txd
);
// Example: TX line idles high between frames
property p_txd_idle_high;
@(posedge clk) disable iff (!rst_n)
bit_tick |-> ##1 (txd == 1'b1) [*0:$];
endproperty
assert property (p_txd_idle_high);
endmodule
