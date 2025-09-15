module uart_fifo #(
parameter int unsigned WIDTH = 8,
parameter int unsigned DEPTH = 16
) (
input logic clk,
input logic rst_n,
input logic wr_en,
input logic [WIDTH-1:0] wr_data,
input logic rd_en,
output logic [WIDTH-1:0] rd_data,
output logic full,
output logic empty
);
localparam int ADDR_W = $clog2(DEPTH);
logic [WIDTH-1:0] mem [0:DEPTH-1];
logic [ADDR_W:0] wptr, rptr;


assign full = (wptr[ADDR_W] != rptr[ADDR_W]) && (wptr[ADDR_W-1:0] == rptr[ADDR_W-1:0]);
assign empty = (wptr == rptr);


always_ff @(posedge clk or negedge rst_n) begin
if (!rst_n) begin
wptr <= '0;
end else if (wr_en && !full) begin
mem[wptr[ADDR_W-1:0]] <= wr_data;
wptr <= wptr + 1'b1;
end
end


always_ff @(posedge clk or negedge rst_n) begin
if (!rst_n) begin
rptr <= '0;
rd_data<= '0;
end else if (rd_en && !empty) begin
rd_data <= mem[rptr[ADDR_W-1:0]];
rptr <= rptr + 1'b1;
end
end
endmodule
