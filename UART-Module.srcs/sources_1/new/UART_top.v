`timescale 1ns / 1ps

module UART_top #(parameter BUS_WIDTH = 8, parameter PARITY = 1'b1, parameter STOP_BITS = 2'b01)
(
        input clk,
        input [BUS_WIDTH-1:0] txData,
        input txStart,
        output [BUS_WIDTH-1:0] rxData,
        output  rxBusy,
        output  txBusy,
        output  frameError
);

wire serialBus;

UART_Tx #(8,1,1) UTX (.clk(clk),
                      .txData(txData),
                      .txStart(txStart),
                      .txBusy(txBusy),
                      .txBit(serialBus));
                      
UART_Rx #(8,1,1) URX (.clk(clk),
                      .rxBusy(rxBusy),
                      .rxData(rxData),
                      .frameError(frameError),
                      .rxBit(serialBus));
endmodule
