`timescale 1ns/1ps
logic [7:0] rx_data;
logic parity_err, frame_err, overrun_err;


// DUT
uart_top #(.CLOCK_HZ(50_000_000), .BAUD_RATE(115200), .OSR(16),
.DATA_BITS(8), .STOP_BITS(1), .PARITY_MODE(PARITY_NONE))
dut (
.clk(clk), .rst_n(rst_n),
.rxd(rxd), .txd(txd),
.tx_valid(tx_valid), .tx_data(tx_data), .tx_ready(tx_ready),
.rx_valid(rx_valid), .rx_data(rx_data), .rx_ready(rx_ready),
.parity_err(parity_err), .frame_err(frame_err), .overrun_err(overrun_err)
);


// Loopback
assign rxd = txd;


// Reset sequence
initial begin
rst_n = 0;
tx_valid = 0; rx_ready = 0; tx_data = '0;
repeat (10) @(posedge clk);
rst_n = 1;
end


// Drive a few bytes
byte test_vec [0:4] = '{8'h55, 8'hA5, 8'h00, 8'hFF, 8'h3C};
int i;


task send_byte(input byte b);
@(posedge clk);
wait (tx_ready);
tx_data <= b;
tx_valid <= 1'b1;
@(posedge clk);
tx_valid <= 1'b0;
endtask


initial begin
for (i=0; i<$size(test_vec); i++) begin
send_byte(test_vec[i]);
end
end


// Collect bytes
int recv_count = 0;
initial begin
forever begin
@(posedge clk);
if (rx_valid) begin
rx_ready <= 1'b1;
$display("[TB] RX byte = 0x%02h", rx_data);
recv_count++;
@(posedge clk);
rx_ready <= 1'b0;
if (recv_count == $size(test_vec)) begin
$display("PASS: Received %0d bytes.", recv_count);
#100_000; // give some time
$finish;
end
end
end
end
endmodule
