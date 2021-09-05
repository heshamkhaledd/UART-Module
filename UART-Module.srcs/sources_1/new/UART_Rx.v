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
parameter idleState     = 3'b000;
parameter startState    = 3'b001;
parameter dataState     = 3'b010; 
parameter parityState   = 3'b011;
parameter endState      = 3'b100;
parameter finishState   = 3'b101;

reg [2:0] currState;
reg [BUS_WIDTH-1:0] receivedData;

integer bitCount;

// Initialize Tx Module at Idle State
initial begin
currState   = idleState;
rxBusy      = 1'b0;
bitCount    = 0;
end

always@(posedge clk)
begin

    case(currState)
        idleState: begin
                    if (rxBit == 1'b1)
                        begin
                            rxBusy <= 1'b0;
                            currState <= idleState;
                        end
                    else
                        begin
                            rxBusy <= 1'b1;
                            currState <= dataState;
                        end
                   end
                   
        dataState: begin
                    if (bitCount != BUS_WIDTH)
                        begin
                            receivedData[bitCount] <= rxBit;
                            bitCount = bitCount + 1;
                        end
                    else
                        begin
                            currState <= dataState;
                        end
                   end
        
        parityState: begin
                        case(PARITY)
                            1'b1: begin
                                    if (rxBit == ^receivedData)
                                        begin
                                            frameError <= 1'b0;
                                            rxData <= receivedData;
                                            currState <= endState;
                                        end
                                    else
                                        begin
                                            frameError <= 1'b1;
                                            currState <=endState;
                                        end
                                  end
                            1'b0: begin
                                    if (rxBit == ~(^receivedData))
                                        begin
                                            frameError <= 1'b0;
                                            rxData <=receivedData;
                                            currState <= endState;
                                        end
                                    else
                                        begin
                                            frameError <= 1'b1;
                                            currState <= endState;
                                        end
                                  end
                        endcase
                     end
        
        endState: begin
                    if(STOP_BITS == 2'b01)
                        begin
                        bitCount <= 0;
                        rxBusy <= 1'b0;
                        currState <= idleState;
                        end
                    else
                        currState <= finishState;
                    end
                  
       finishState: begin
                     bitCount <= 0;
                     rxBusy <= 1'b0;
                     currState <= idleState;
                    end
    endcase
end
endmodule
