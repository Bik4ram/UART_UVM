// Generates oversample tick (osr_tick) and bit tick (bit_tick)
module uart_baud_gen #(
parameter int unsigned CLOCK_HZ = 50_000_000,
parameter int unsigned BAUD_RATE = 115200,
parameter int unsigned OSR = 16
) (
input logic clk,
input logic rst_n,
output logic osr_tick, // 1-cycle pulse at OSR*BAUD_RATE
output logic bit_tick // 1-cycle pulse at BAUD_RATE
);
// Divider: clocks per oversample tick
localparam int unsigned DIV = (CLOCK_HZ / (BAUD_RATE * OSR)) > 0 ?
(CLOCK_HZ / (BAUD_RATE * OSR)) : 1;


logic [$clog2(DIV):0] div_cnt;
logic [$clog2(OSR):0] osr_cnt;


always_ff @(posedge clk or negedge rst_n) begin
if (!rst_n) begin
div_cnt <= '0;
osr_cnt <= '0;
osr_tick <= 1'b0;
bit_tick <= 1'b0;
end else begin
osr_tick <= 1'b0;
bit_tick <= 1'b0;


if (div_cnt == DIV-1) begin
div_cnt <= '0;
osr_tick <= 1'b1;
if (osr_cnt == OSR-1) begin
osr_cnt <= '0;
bit_tick <= 1'b1; // once each bit period
end else begin
osr_cnt <= osr_cnt + 1'b1;
end
end else begin
div_cnt <= div_cnt + 1'b1;
end
end
end
endmodule
