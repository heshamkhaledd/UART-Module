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
clk     = 1;
rxBit   = 0;
end

// UART_Tx Instance
UART_Rx #(8,1,1) DUT_Rx (.clk(clk), .rxBit(rxBit), .rxBusy(rxBusy), .rxData(rxData), .frameError(frameError));

// Generate Clock of period = 10 ns
always #5 clk = ~clk;

initial begin
rxBit = 1'b1; //Idle State Bit
#50
rxBit = 1'b0; //Start Bit
#10
rxBit = 1'b1; //Data[0]
#10
rxBit = 1'b0; //Data[1]
#10
rxBit = 1'b1; //Data[2]
#10
rxBit = 1'b0; //Data[3]
#10
rxBit = 1'b1; //Data[4]
#10
rxBit = 1'b0; //Data[5]
#10
rxBit = 1'b1; //Data[6]
#10
rxBit = 1'b0; //Data[7]
#10
rxBit = 1'b0; //Even Parity for 8'b01010101
#10
rxBit = 1'b1;
end

initial begin
#200
$finish;
end
endmodule