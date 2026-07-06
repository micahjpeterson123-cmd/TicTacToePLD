`timescale 1ns/1ps

module tictactoefinal (

input wire CLK_66MHz,

output reg LED_1_GREEN,   // LED 1 Green output
    output reg LED_1_RED,     // LED 1 Red output
    output reg LED_1_BLUE,    // LED 1 Blue output
    output reg LED_2_GREEN,   // LED 2 Green output
    output reg LED_2_RED,     // LED 2 Red output
    output reg LED_2_BLUE,    // LED 2 Blue output
    output reg LED_3_GREEN,   // LED 3 Green output
    output reg LED_3_RED,     // LED 3 Red output
    output reg LED_3_BLUE,    // LED 3 Blue output
    output reg LED_4_GREEN,   // LED 4 Green output
    output reg LED_4_RED,     // LED 4 Red output
    output reg LED_4_BLUE,     // LED 4 Blue output

output reg TR_DIR_1,
output reg TR_OE_1,
output reg TR_DIR_2,
output reg TR_OE_2,
output reg TR_DIR_3,
output reg TR_OE_3,
output reg TR_DIR_4,
output reg TR_OE_4,
output reg TR_DIR_5,
output reg TR_OE_5,

input wire   [7:0]         LB_AD,          //XIOH -- J8

input wire   [7:0]         LB_IOH,         //XIOH -- J9

output reg   [7:0]         LB_COMM,        //COMM -- J10

output reg   [7:0]         LB_XIOH,        //XIOL -- J16

output reg   [7:0]        LB_XIOLA,       //XIOH -- J16

    output reg clk_out

);

parameter SIZE = 12;

parameter A = 4'b0000, B = 4'b0001, C = 4'b0010, D = 4'b0011, E = 4'b0100, F =  4'b0101, G = 4'b0110, H = 4'b0111, I = 4'b1000, J = 4'b1001, K = 4'b1010;

reg [SIZE-1:0] curstate;

reg [SIZE-1:0] prevstate;

reg [SIZE-1:0] nextstate;

// Initialize LEDs to off state
initial begin
LED_1_GREEN = 1'b1;
LED_1_RED = 1'b1;
LED_1_BLUE = 1'b1;
LED_2_GREEN = 1'b1;
LED_2_RED = 1'b1;
LED_2_BLUE = 1'b1;
LED_3_GREEN = 1'b1;
LED_3_RED = 1'b1;
LED_3_BLUE = 1'b1;
LED_4_GREEN = 1'b1;
LED_4_RED = 1'b1;
LED_4_BLUE = 1'b1;
TR_DIR_1 = 0;
TR_OE_1 = 0;
TR_DIR_2 = 1;
TR_OE_2 = 0;
TR_DIR_3 = 1;
TR_OE_3 = 0;
TR_DIR_4 = 0;
TR_OE_4 = 0;
TR_DIR_5 = 0;
TR_OE_5 = 0;
end


reg[27:0] clk_increment = 28'd0;
   parameter DIVISOR = 28'd66000000;

always @(posedge CLK_66MHz) begin

if (clk_increment > (DIVISOR)) begin

clk_out <= ~clk_out;
clk_increment <= 28'd0;

if (LB_AD[7])
begin
LB_XIOLA[6] <= 0; // ra
   LB_XIOLA[4] <= 0; // rb
LB_XIOLA[2] <= 0; // rc
LB_XIOLA[0] <= 0; // rd
LB_XIOH[1] <= 0; // re
LB_XIOH[3] <= 0; // rf
LB_XIOH[5] <= 0; // rg
LB_XIOH[7] <= 0; // rh
LB_COMM[0] <= 0; // ri
LB_XIOLA[7] <= 0; // ba
LB_XIOLA[5] <= 0; // bb
LB_XIOLA[3] <= 0; // bc
LB_XIOLA[1] <= 0; // bd
LB_XIOH[0] <= 0; // be
LB_XIOH[2] <= 0; // bf
LB_XIOH[4] <= 0; // bg
LB_XIOH[6] <= 0; // bh
LB_COMM[1] <= 0; // bi
curstate <= #1 A;
end else
case(curstate)

A: if (LB_AD[0])
  begin
LED_1_RED <= 1'b0;
LED_1_BLUE <= 1'b1;
LED_2_RED <= 1'b1;
LED_3_BLUE <= 1'b1;
LED_4_RED <= 1'b1;
 curstate <= #1 B;
 LB_XIOLA[6] <= 1;
end else if (LB_AD[1])
begin
LED_1_RED <= 1'b0;
LED_1_BLUE <= 1'b1;
LED_2_RED <= 1'b1;
LED_3_BLUE <= 1'b1;
LED_4_RED <= 1'b1;
 curstate <= #1 B;
 LB_XIOLA[4] <= 1;
end else if (LB_AD[2])
begin
 curstate <= #1 B;
 LB_XIOLA[2] <= 1;
end else if (LB_AD[3])
begin
 curstate <= #1 B;
 LB_XIOLA[0] <= 1;
end else if (LB_AD[4])
begin
 curstate <= #1 B;
 LB_XIOH[1] <= 1;
 end else if (LB_AD[5])
begin
 curstate <= #1 B;
 LB_XIOH[3] <= 1;
end else if (LB_AD[6])
begin
 curstate <= #1 B;
 LB_XIOH[5] <= 1;
 end else if (LB_IOH[0])
begin
 curstate <= #1 B;
 LB_XIOH[7] <= 1;
end else if (LB_IOH[1])
begin
 curstate <= #1 B;
 LB_COMM[0] <= 1;
end else
begin
 curstate <= #1 A;
end

B: if (LB_AD[0])
  begin
LED_2_RED <= 1'b0;
 curstate <= #1 C;
 LB_XIOLA[7] <= 1;
end else if (LB_AD[1])
begin
LED_2_RED <= 1'b0;
 curstate <= #1 C;
 LB_XIOLA[5] <= 1;
end else if (LB_AD[2])
begin
 curstate <= #1 C;
 LB_XIOLA[3] <= 1;
end else if (LB_AD[3])
begin
 curstate <= #1 C;
 LB_XIOLA[1] <= 1;
end else if (LB_AD[4])
begin
 curstate <= #1 C;
 LB_XIOH[0] <= 1;
 end else if (LB_AD[5])
begin
 curstate <= #1 C;
 LB_XIOH[2] <= 1;
end else if (LB_AD[6])
begin
 curstate <= #1 C;
 LB_XIOH[4] <= 1;
 end else if (LB_IOH[0])
begin
 curstate <= #1 C;
 LB_XIOH[6] <= 1;
end else if (LB_IOH[1])
begin
 curstate <= #1 C;
 LB_COMM[1] <= 1;
end else
begin
 curstate <= #1 B;
end

C: if (LB_AD[0])
  begin
LED_3_RED <= 1'b0;
 curstate <= #1 D;
 LB_XIOLA[6] <= 1;
end else if (LB_AD[1])
begin
LED_3_RED <= 1'b0;
 curstate <= #1 D;
 LB_XIOLA[4] <= 1;
end else if (LB_AD[2])
begin
 curstate <= #1 D;
 LB_XIOLA[2] <= 1;
end else if (LB_AD[3])
begin
 curstate <= #1 D;
 LB_XIOLA[0] <= 1;
end else if (LB_AD[4])
begin
 curstate <= #1 D;
 LB_XIOH[1] <= 1;
 end else if (LB_AD[5])
begin
 curstate <= #1 D;
 LB_XIOH[3] <= 1;
end else if (LB_AD[6])
begin
 curstate <= #1 D;
 LB_XIOH[5] <= 1;
 end else if (LB_IOH[0])
begin
 curstate <= #1 D;
 LB_XIOH[7] <= 1;
end else if (LB_IOH[1])
begin
 curstate <= #1 D;
 LB_COMM[0] <= 1;
end else
begin
 curstate <= #1 C;
end

D: if (LB_AD[0])
  begin
LED_4_RED <= 1'b0;
 curstate <= #1 E;
 LB_XIOLA[7] <= 1;
end else if (LB_AD[1])
begin
LED_4_RED <= 1'b0;
 curstate <= #1 E;
 LB_XIOLA[5] <= 1;
end else if (LB_AD[2])
begin
 curstate <= #1 E;
 LB_XIOLA[3] <= 1;
end else if (LB_AD[3])
begin
 curstate <= #1 E;
 LB_XIOLA[1] <= 1;
end else if (LB_AD[4])
begin
 curstate <= #1 E;
 LB_XIOH[0] <= 1;
 end else if (LB_AD[5])
begin
 curstate <= #1 E;
 LB_XIOH[2] <= 1;
end else if (LB_AD[6])
begin
 curstate <= #1 E;
 LB_XIOH[4] <= 1;
 end else if (LB_IOH[0])
begin
 curstate <= #1 E;
 LB_XIOH[6] <= 1;
end else if (LB_IOH[1])
begin
 curstate <= #1 E;
 LB_COMM[1] <= 1;
end else
begin
 curstate <= #1 D;
end

E: if (LB_AD[0])
  begin
         LED_1_RED <= 1'b1;
LED_2_RED <= 1'b1;
LED_3_RED <= 1'b1;
LED_4_RED <= 1'b1;
LED_1_BLUE <= 1'b0;
 prevstate <= curstate;
 curstate <= #1 J;
 LB_XIOLA[6] <= 1;
end else if (LB_AD[1])
begin
LED_1_RED <= 1'b1;
LED_2_RED <= 1'b1;
LED_3_RED <= 1'b1;
LED_4_RED <= 1'b1;
LED_1_BLUE <= 1'b0;
 prevstate <= curstate;
 LB_XIOLA[4] <= 1;
 curstate <= #1 J;
end else if (LB_AD[2])
begin
 prevstate <= curstate;
 curstate <= #1 J;
 LB_XIOLA[2] <= 1;
end else if (LB_AD[3])
begin
 prevstate <= curstate;
 curstate <= #1 J;
 LB_XIOLA[0] <= 1;
end else if (LB_AD[4])
begin
 prevstate <= curstate;
 curstate <= #1 J;
 LB_XIOH[1] <= 1;
 end else if (LB_AD[5])
begin
 prevstate <= curstate;
 curstate <= #1 J;
 LB_XIOH[3] <= 1;
end else if (LB_AD[6])
begin
 prevstate <= curstate;
 curstate <= #1 J;
 LB_XIOH[5] <= 1;
 end else if (LB_IOH[0])
begin
 prevstate <= curstate;
 curstate <= #1 J;
 LB_XIOH[7] <= 1;
end else if (LB_IOH[1])
begin
 prevstate <= curstate;
 curstate <= #1 J;
 LB_COMM[0] <= 1;
end else
begin
 curstate <= #1 E;
end

F: if (LB_AD[0])
  begin
LED_2_BLUE <= 1'b0;
 prevstate <= curstate;
 curstate <= #1 J;
 LB_XIOLA[7] <= 1;
end else if (LB_AD[1])
begin
LED_2_BLUE <= 1'b0;
 prevstate <= curstate;
 LB_XIOLA[5] <= 1;
 curstate <= #1 J;
end else if (LB_AD[2])
begin
 prevstate <= curstate;
 curstate <= #1 J;
 LB_XIOLA[3] <= 1;
end else if (LB_AD[3])
begin
 prevstate <= curstate;
 curstate <= #1 J;
 LB_XIOLA[1] <= 1;
end else if (LB_AD[4])
begin
 prevstate <= curstate;
 curstate <= #1 J;
 LB_XIOH[0] <= 1;
 end else if (LB_AD[5])
begin
 prevstate <= curstate;
 curstate <= #1 J;
 LB_XIOH[2] <= 1;
end else if (LB_AD[6])
begin
 prevstate <= curstate;
 curstate <= #1 J;
 LB_XIOH[4] <= 1;
 end else if (LB_IOH[0])
begin
 prevstate <= curstate;
 curstate <= #1 J;
 LB_XIOH[6] <= 1;
end else if (LB_IOH[1])
begin
 prevstate <= curstate;
 curstate <= #1 J;
 LB_COMM[1] <= 1;
end else
begin
 curstate <= #1 F;
end

G: if (LB_AD[0])
  begin
LED_3_BLUE <= 1'b0;
 prevstate <= curstate;
 curstate <= #1 J;
 LB_XIOLA[6] <= 1;
end else if (LB_AD[1])
begin
LED_3_BLUE <= 1'b0;
 prevstate <= curstate;
 LB_XIOLA[4] <= 1;
 curstate <= #1 J;
end else if (LB_AD[2])
begin
 prevstate <= curstate;
 curstate <= #1 J;
 LB_XIOLA[2] <= 1;
end else if (LB_AD[3])
begin
 prevstate <= curstate;
 curstate <= #1 J;
 LB_XIOLA[0] <= 1;
end else if (LB_AD[4])
begin
 prevstate <= curstate;
 curstate <= #1 J;
 LB_XIOH[1] <= 1;
 end else if (LB_AD[5])
begin
 prevstate <= curstate;
 curstate <= #1 J;
 LB_XIOH[3] <= 1;
end else if (LB_AD[6])
begin
 prevstate <= curstate;
 curstate <= #1 J;
 LB_XIOH[5] <= 1;
 end else if (LB_IOH[0])
begin
 prevstate <= curstate;
 curstate <= #1 J;
 LB_XIOH[7] <= 1;
end else if (LB_IOH[1])
begin
 prevstate <= curstate;
 curstate <= #1 J;
 LB_COMM[0] <= 1;
end else
begin
 curstate <= #1 G;
end

H: if (LB_AD[0])
  begin
LED_4_BLUE <= 1'b0;
 prevstate <= curstate;
 curstate <= #1 J;
 LB_XIOLA[7] <= 1;
end else if (LB_AD[1])
begin
LED_4_BLUE <= 1'b0;
 prevstate <= curstate;
 LB_XIOLA[5] <= 1;
 curstate <= #1 J;
end else if (LB_AD[2])
begin
 prevstate <= curstate;
 curstate <= #1 J;
 LB_XIOLA[3] <= 1;
end else if (LB_AD[3])
begin
 prevstate <= curstate;
 curstate <= #1 J;
 LB_XIOLA[1] <= 1;
end else if (LB_AD[4])
begin
 prevstate <= curstate;
 curstate <= #1 J;
 LB_XIOH[0] <= 1;
 end else if (LB_AD[5])
begin
 prevstate <= curstate;
 curstate <= #1 J;
 LB_XIOH[2] <= 1;
end else if (LB_AD[6])
begin
 prevstate <= curstate;
 curstate <= #1 J;
 LB_XIOH[4] <= 1;
 end else if (LB_IOH[0])
begin
 prevstate <= curstate;
 curstate <= #1 J;
 LB_XIOH[6] <= 1;
end else if (LB_IOH[1])
begin
 prevstate <= curstate;
 curstate <= #1 J;
 LB_COMM[1] <= 1;
end else
begin
 curstate <= #1 H;
end

I: if (LB_AD[0])
  begin
LED_2_RED <= 1'b0;
LED_2_BLUE <= 1'b1;
LED_4_RED <= 1'b0;
LED_4_BLUE <= 1'b1;
 prevstate <= curstate;
 curstate <= #1 J;
 LB_XIOLA[6] <= 1;
end else if (LB_AD[1])
begin
 prevstate <= curstate;
 LB_XIOLA[4] <= 1;
 curstate <= #1 J;
end else if (LB_AD[2])
begin
 prevstate <= curstate;
 curstate <= #1 J;
 LB_XIOLA[2] <= 1;
end else if (LB_AD[3])
begin
 prevstate <= curstate;
 curstate <= #1 J;
 LB_XIOLA[0] <= 1;
end else if (LB_AD[4])
begin
 prevstate <= curstate;
 curstate <= #1 J;
 LB_XIOH[1] <= 1;
 end else if (LB_AD[5])
begin
 prevstate <= curstate;
 curstate <= #1 J;
 LB_XIOH[3] <= 1;
end else if (LB_AD[6])
begin
 prevstate <= curstate;
 curstate <= #1 J;
 LB_XIOH[5] <= 1;
 end else if (LB_IOH[0])
begin
 prevstate <= curstate;
 curstate <= #1 J;
 LB_XIOH[7] <= 1;
end else if (LB_IOH[1])
begin
 prevstate <= curstate;
 curstate <= #1 J;
 LB_COMM[0] <= 1;
end else
begin
 curstate <= #1 I;
end

J: if (LB_XIOLA[6] == 1 && LB_XIOLA[4] == 1 && LB_XIOLA[2] == 1 || LB_XIOLA[0] == 1 && LB_XIOH[1] == 1 && LB_XIOH[3] == 1 || LB_XIOH[5] == 1 && LB_XIOH[7] == 1 && LB_COMM[0] == 1 || LB_XIOLA[6] == 1 && LB_XIOLA[0] == 1 && LB_XIOH[5] == 1 || LB_XIOLA[4] == 1 && LB_XIOH[1] == 1 && LB_XIOH[7] == 1 || LB_XIOLA[2] == 1 && LB_XIOH[3] == 1 && LB_COMM[0] == 1 || LB_XIOLA[6] == 1 && LB_XIOH[1] == 1 && LB_COMM[0] == 1 || LB_XIOLA[2] == 1 && LB_XIOH[1] == 1 && LB_XIOH[5] == 1)
  begin
    LB_XIOLA[6] <= 1;
 LB_XIOLA[4] <= 1;
 LB_XIOLA[2] <= 1;
 LB_XIOLA[0] <= 1;
   LB_XIOH[1] <= 1;
 LB_XIOH[3] <= 1;
 LB_XIOH[5] <= 1;
 LB_XIOH[7] <= 1;
 LB_COMM[0] <= 1;
 LB_XIOLA[7] <= 0;
 LB_XIOLA[5] <= 0;
 LB_XIOLA[3] <= 0;
 LB_XIOLA[1] <= 0;
 LB_XIOH[0] <= 0;
 LB_XIOH[2] <= 0;
 LB_XIOH[4] <= 0;
 LB_XIOH[6] <= 0;
 LB_COMM[1] <= 0;
 curstate <= #1 K;
end else if (LB_XIOLA[7] <= 1 && LB_XIOLA[5] == 1 && LB_XIOLA[3] == 1 || LB_XIOLA[1] == 1 && LB_XIOH[0] == 1 && LB_XIOH[2] == 1 || LB_XIOH[4] == 1 && LB_XIOH[6] == 1 && LB_COMM[1] == 1 || LB_XIOLA[7] <= 1 && LB_XIOLA[1] == 1 && LB_XIOH[4] == 1 || LB_XIOLA[5] == 1 && LB_XIOH[0] == 1 && LB_XIOH[6] == 1 || LB_XIOLA[3] == 1 && LB_XIOH[2] == 1 && LB_COMM[1] == 1 || LB_XIOLA[7] <= 1 && LB_XIOH[0] == 1 && LB_COMM[1] == 1 || LB_XIOLA[3] == 1 && LB_XIOH[0] == 1 && LB_XIOH[4] == 1)
begin
 LB_XIOLA[6] <= 1;
 LB_XIOLA[4] <= 1;
 LB_XIOLA[2] <= 1;
 LB_XIOLA[0] <= 1;
   LB_XIOH[1] <= 1;
 LB_XIOH[3] <= 1;
 LB_XIOH[5] <= 1;
 LB_XIOH[7] <= 1;
 LB_COMM[0] <= 1;
 LB_XIOLA[7] <= 0;
 LB_XIOLA[5] <= 0;
 LB_XIOLA[3] <= 0;
 LB_XIOLA[1] <= 0;
 LB_XIOH[0] <= 0;
 LB_XIOH[2] <= 0;
 LB_XIOH[4] <= 0;
 LB_XIOH[6] <= 0;
 LB_COMM[1] <= 0;
 curstate <= #1 K;
end else if (prevstate == E)
begin
 curstate <= #1 F;
end else if (prevstate == F)
begin
 curstate <= #1 G;
end else if (prevstate == G)
begin
 curstate <= #1 H;
end else if (prevstate == H)
begin
 curstate <= #1 I;
end else
begin
 curstate <= #1 A;
end

K: if (LB_XIOLA[6] == 1 && LB_XIOLA[4] == 1 && LB_XIOLA[2] == 1 || LB_XIOLA[0] == 1 && LB_XIOH[1] == 1 && LB_XIOH[3] == 1 || LB_XIOH[5] == 1 && LB_XIOH[7] == 1 && LB_COMM[0] == 1 || LB_XIOLA[6] == 1 && LB_XIOLA[0] == 1 && LB_XIOH[5] == 1 || LB_XIOLA[4] == 1 && LB_XIOH[1] == 1 && LB_XIOH[7] == 1 || LB_XIOLA[2] == 1 && LB_XIOH[3] == 1 && LB_COMM[0] == 1 || LB_XIOLA[6] == 1 && LB_XIOH[1] == 1 && LB_COMM[0] == 1 || LB_XIOLA[2] == 1 && LB_XIOH[1] == 1 && LB_XIOH[5] == 1)
  begin
    LB_XIOLA[6] <= 0;
 LB_XIOLA[4] <= 0;
 LB_XIOLA[2] <= 0;
 LB_XIOLA[0] <= 0;
   LB_XIOH[1] <= 0;
 LB_XIOH[3] <= 0;
 LB_XIOH[5] <= 0;
 LB_XIOH[7] <= 0;
 LB_COMM[0] <= 0;
 LB_XIOLA[7] <= 1;
 LB_XIOLA[5] <= 1;
 LB_XIOLA[3] <= 1;
 LB_XIOLA[1] <= 1;
 LB_XIOH[0] <= 1;
 LB_XIOH[2] <= 1;
 LB_XIOH[4] <= 1;
 LB_XIOH[6] <= 1;
 LB_COMM[1] <= 1;
 curstate <= #1 J;
end else if (LB_XIOLA[7] <= 1 && LB_XIOLA[5] == 1 && LB_XIOLA[3] == 1 || LB_XIOLA[1] == 1 && LB_XIOH[0] == 1 && LB_XIOH[2] == 1 || LB_XIOH[4] == 1 && LB_XIOH[6] == 1 && LB_COMM[1] == 1 || LB_XIOLA[7] <= 1 && LB_XIOLA[1] == 1 && LB_XIOH[4] == 1 || LB_XIOLA[5] == 1 && LB_XIOH[0] == 1 && LB_XIOH[6] == 1 || LB_XIOLA[3] == 1 && LB_XIOH[2] == 1 && LB_COMM[1] == 1 || LB_XIOLA[7] <= 1 && LB_XIOH[0] == 1 && LB_COMM[1] == 1 || LB_XIOLA[3] == 1 && LB_XIOH[0] == 1 && LB_XIOH[4] == 1)
begin
 LB_XIOLA[6] <= 0;
 LB_XIOLA[4] <= 0;
 LB_XIOLA[2] <= 0;
 LB_XIOLA[0] <= 0;
   LB_XIOH[1] <= 0;
 LB_XIOH[3] <= 0;
 LB_XIOH[5] <= 0;
 LB_XIOH[7] <= 0;
 LB_COMM[0] <= 0;
 LB_XIOLA[7] <= 1;
 LB_XIOLA[5] <= 1;
 LB_XIOLA[3] <= 1;
 LB_XIOLA[1] <= 1;
 LB_XIOH[0] <= 1;
 LB_XIOH[2] <= 1;
 LB_XIOH[4] <= 1;
 LB_XIOH[6] <= 1;
 LB_COMM[1] <= 1;
 curstate <= #1 J;
end else if (prevstate == E)
begin
 curstate <= #1 F;
end else if (prevstate == F)
begin
 curstate <= #1 G;
end else if (prevstate == G)
begin
 curstate <= #1 H;
end else if (prevstate == H)
begin
 curstate <= #1 I;
end else
begin
 curstate <= #1 A;
end
default : curstate <= #1 A;

endcase 
end else begin

clk_increment <= clk_increment + 1;

end
end

endmodule 
