`timescale 1ns / 1ps

module UART_top_tb();

parameter BUS_WIDTH = 8;

reg clk;
reg [BUS_WIDTH-1:0] txData;
reg txStart;
wire [BUS_WIDTH-1:0] rxData;
wire rxBusy;
wire txBusy;
wire frameError;

initial begin
clk = 0;
txData = 0;
txStart = 0;
end

UART_top #(8,1,1) DUT ( .clk(clk),
                        .txData(txData),
                        .txStart(txStart),
                        .rxData(rxData),
                        .txBusy(txBusy),
                        .rxBusy(rxBusy),
                        .frameError(frameError));
                        
initial begin
clk = 1;
txStart = 0;
end

always #5 clk = ~clk;

initial begin
#50
txData = 8'b01010101;
txStart = 1'b1;
#10 txStart = 1'b0;
end

initial begin
#1000
$finish;
end

endmodule
