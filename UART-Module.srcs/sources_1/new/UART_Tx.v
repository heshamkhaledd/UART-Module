`timescale 1ns / 1ps

/*
BUS_WIDTH:  Parameter to Initialize the number of data bits (Can Vary from 
PARITY:     Parameter to Initialize Parity Type, [1' (Even) | 0' (Odd)]
STOP_BITS:  Parameter to Initialize the number of stop bits either one or two bits

 */

module UART_Tx #(parameter BUS_WIDTH = 8, parameter PARITY = 1'b1, parameter STOP_BITS = 2'b01)
(
        input clk,                      // Module Clock
        input [BUS_WIDTH-1:0] txData,   // Data-to-be Transmitted
        input txStart,                  // Start Signal
        output reg txBusy,              // Busy Signal
        output reg txBit                // Bit to be send on the transmission bus
);

//UART States
parameter idleState     = 3'b000;
parameter startState    = 3'b001;
parameter dataState     = 3'b010; 
parameter parityState   = 3'b011;
parameter endState      = 3'b100;
parameter finishState   = 3'b101;

reg [2:0] currState;
reg [BUS_WIDTH-1:0] dataToSend;
reg txStartBit;

integer bitCount;

// Initialize Tx Module at Idle State
initial begin
currState   = idleState;
txStartBit  = 1'b0;
bitCount    = 0;
txBusy      = 0;
end


always@(posedge clk)
begin
txStartBit <= txStart;
dataToSend <= txData;
    case(currState)
        idleState: begin
                    txBit <= 1'b1;
                    txBusy <= 1'b0;
                    if (txStartBit == 1)
                        begin
                        currState <= startState;
                        txBusy <= 1'b1;
                        end
                     else
                        currState <= idleState;
                   end
                   
        startState: begin
                        txBit <= 1'b0;
                        currState <= dataState;
                    end
                    
        dataState: begin
                    if (bitCount != BUS_WIDTH)
                        begin
                            txBit <= dataToSend[bitCount];
                            bitCount <= bitCount + 1;
                        end
                    else
                        begin
                            bitCount <= 0;
                            currState <= parityState;
                        end 
                   end
        
        parityState: begin
                        case (PARITY)
                            1'b1: begin // Even Parity
                                    txBit <= ^dataToSend;
                                  end
                                  
                            1'b0: begin // Odd Parity
                                    txBit <= ~(^dataToSend);
                                  end
                        endcase
                        currState <= endState;       
                     end
                     
        endState: begin
                    txBit <= 1'b1;
                    if (STOP_BITS == 2'b01)
                        begin
                            currState <= idleState;
                        end
                    else
                        currState <= finishState;
                  end
                  
         finishState: begin
                        txBit <= 1'b1;
                        txBusy <= 1'b0;
                        currState <= idleState;
                      end
    endcase
end
endmodule