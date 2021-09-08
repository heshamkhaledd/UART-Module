`timescale 1ns / 1ps

module UART_Rx#(parameter BUS_WIDTH = 8, parameter PARITY = 1'b1, parameter STOP_BITS = 2'b01)
(
    input clk,
    input rxBit,
    output reg rxBusy,
    output reg [BUS_WIDTH-1:0] rxData,
    output reg frameError
    );

//UART Receiver States
localparam idleState     = 3'b000;
localparam dataState     = 3'b001; 
localparam parityState   = 3'b010;
localparam endState      = 3'b011;
localparam finishState   = 3'b100;

reg [2:0] currState;


integer bitCount;

// Initialize Rx Module at Idle State
initial begin
currState   = idleState;
rxBusy      = 1'b0;
bitCount    = 0;
end

always@(posedge clk)
begin
    case(currState)
        idleState: begin
                    if (rxBit != 1'b1)
                        begin
                            rxBusy <= 1'b1;
                            currState <= dataState;
                        end
                   end
                   
        dataState: begin
                    rxData[bitCount] <= rxBit;
                    if (bitCount != BUS_WIDTH - 1)
                        begin
                            bitCount = bitCount + 1;
                        end
                    else
                        begin
                            bitCount <= 0;
                            currState <= parityState;
                        end
                   end
        
        parityState: begin
                        case (PARITY)
                            1'b1: begin
                                    if (rxBit == ^rxData)
                                        begin
                                            frameError <= 1'b0;
                                        end
                                    else
                                        begin
                                            frameError <= 1'b1;
                                        end
                                    end
                            1'b0: begin
                                    if (rxBit == ~(^rxData))
                                        begin
                                            frameError <= 1'b0;
                                        end
                                    else
                                        begin
                                            frameError <= 1'b1;
                                        end
                                  end
                        endcase
                        currState <= endState;
                     end
        
        endState: begin
                    if(STOP_BITS == 2'b01)
                        begin
                        rxBusy <= 1'b0;
                        currState <= idleState;
                        end
                    else
                        currState <= finishState;
                    end
                  
       finishState: begin
                     rxBusy <= 1'b0;
                     currState <= idleState;
                    end
    endcase
end
endmodule
