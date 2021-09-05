`timescale 1ns / 1ps


module UART_Tx_tb();

parameter BUS_WIDTH = 8;

reg     clk;
reg     [BUS_WIDTH-1:0] txData;
reg     txStart;
wire    txBusy;
wire    txBit;

// Initialize all inputs to zero
initial begin
clk     = 0;
txData  = 0;
txStart = 0;
end

// UART_Tx Instance
UART_Tx #(8,1,1) DUT (.clk(clk), .txData(txData), .txStart(txStart), .txBusy(txBusy), .txBit(txBit));

// Generate Clock of period = 10 ns
always #5 clk = ~clk;

initial begin
#20
txData      = 8'b10101010;
txStart     = 1'b1;
#10 txStart = 1'b0;
end

initial begin
#1000
$finish;
end
endmodule