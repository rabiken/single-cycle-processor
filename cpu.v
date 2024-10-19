`default_nettype none
module processor( input         clk, reset,
                  output [31:0] PC,
                  input  [31:0] instruction,
                  output        WE,
                  output [31:0] address_to_mem,
                  output [31:0] data_to_mem,
                  input  [31:0] data_from_mem
                );
    //... write your code here ...
endmodule

//... add new Verilog modules here ...

// Mux 2x1
module Mux2x1( input  sel,
               input  [31:0] a,
               input  [31:0] b,
               output [31:0] y
             );
    assign y = (sel == 1'b0) ? a : b;
endmodule

// Adder 32 bits
module Adder32( input  [31:0] a,
                input  [31:0] b,
                output [31:0] y
              );
    assign y = a + b;
endmodule

// ALU
module ALU( input  [31:0] a,
            input  [31:0] b,
            input  [2:0] alu_ctrl,
            output reg [31:0] y,
            output reg [1:0]  cmp   // 00: a=b, 01: a<b, 10: a>b
          );
    always (*) begin
        // Initialize y and cmp
        y = 32'bx;
        cmp = 2'bxx;
        case (alu_ctrl)

            // Add - Addition
            3'b000: y = a + b;
            // And - Bitwise AND
            3'b001: y = a & b;
            // Sub - Subtract
            3'b010: begin
                y = a - b;
                if (a==b) cmp = 2'b00;
                else if (a<b) cmp = 2'b01;
                else cmp = 2'b10;
            end
            // Srl - Shift Right Logical
            3'b011: y = a >> b;
            // Fll - Floor Log2
            3'b100: begin
                // TODO: Implement Fll
            end
            default: y = 32'bx;
        endcase
    end
endmodule

// GPR Set 
module GPRSet( input  [4:0] a1, a2, a3,
               input  [31:0] wd3,
               input  clk, we,
               output reg [31:0] rd1, rd2
             );
    reg [31:0] gpr_arr[31:0];
    // Initialize GPRs
    initial begin
        for (int i=0; i<32; i=i+1) begin
            gpr_arr[i] = 32'h00000000;
        end
    end
    always @(posedge clk) begin
        gpr_arr[0] = 32'h00000000; // x0 is always zero.
        if (we) begin
            gpr_arr[a3] = wd3;
        end
        rd1 = gpr_arr[a1];
        rd2 = gpr_arr[a2];
    end
endmodule 

// Immediate Decoder
module ImmDecoder( input  [24:0] instr,
                   input  [2:0]  imm_ctrl,
                   output [31:0] imm_out
                 );
    case (imm_ctrl) 
        // I-type
        3'b000: imm_out = { {21{instr[24]}}, instr[23:13] };
        // S-type
        3'b001: imm_out = { {21{instr[24]}}, instr[23:18], instr[4:0] };
        // B-type
        3'b010: imm_out = { {20{instr[24]}}, instr[0], instr[23:18], instr[4:1], 1'b0 };
        // U-type
        3'b011: imm_out = { instr[24:5], 12'b0 };
        // J-type
        3'b100: imm_out = { {12{instr[24]}}, instr[12:5], instr[13], instr[23:14], 1'b0 };
        default: imm_out = 32'bx;
    endcase
endmodule


`default_nettype wire
