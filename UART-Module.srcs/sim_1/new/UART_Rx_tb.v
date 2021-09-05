`timescale 1ns / 1ps


module UART_Rx_tb();

parameter BUS_WIDTH = 8;

reg     clk;
reg     rxBit;
wire    rxBusy;
wire    [BUS_WIDTH-1:0] rxData;
wire    frameError;

// Initialize all inputs to zero
initial begin
clk     = 0;
rxBit   = 0;
end

// UART_Tx Instance
UART_Rx #(8,1,1) DUT_Rx (.clk(clk), .rxBit(rxBit), .rxBusy(rxBusy), .rxData(rxData), .frameError(frameError));

// Generate Clock of period = 10 ns
always #5 clk = ~clk;

initial begin
end

initial begin
#1000
$finish;
end
endmodule