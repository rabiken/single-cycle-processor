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
    wire [6:0] opcode = instruction[6:0];
    wire [2:0] funct3 = instruction[14:12];
    wire [6:0] funct7 = instruction[31:25];
    wire [2:0] ctrlImmCtrl, ctrlALUCtrl;
    wire ctrlRegWrite, ctrlALUSrc, 
        ctrlBranchJal, ctrlBranchJalr, 
        ctrlBranchBeq, ctrlBranchBlt, 
        ctrlMemToReg, ctrlLui;
    ControlUnit control_unit_inst( 
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .ctrlRegWrite(ctrlRegWrite),
        .ctrlImmCtrl(ctrlImmCtrl), 
        .ctrlALUSrc(ctrlALUSrc),
        .ctrlALUCtrl(ctrlALUCtrl), 
        .ctrlBranchJal(ctrlBranchJal),
        .ctrlBranchJalr(ctrlBranchJalr), 
        .ctrlBranchBeq(ctrlBranchBeq),
        .ctrlBranchBlt(ctrlBranchBlt), 
        .ctrlMemToReg(ctrlMemToReg),
        .ctrlMemWrite(WE),
        .ctrlLui(ctrlLui)
    );
    DataPath data_path_inst( .clk(clk),
        .reset(reset),
        .PC(PC),
        .instruction(instruction),
        .address_to_mem(address_to_mem),
        .data_to_mem(data_to_mem),
        .data_from_mem(data_from_mem),
        .ctrlRegWrite(ctrlRegWrite),
        .ctrlImmCtrl(ctrlImmCtrl), 
        .ctrlALUSrc(ctrlALUSrc),
        .ctrlALUCtrl(ctrlALUCtrl), 
        .ctrlBranchJal(ctrlBranchJal),
        .ctrlBranchJalr(ctrlBranchJalr), 
        .ctrlBranchBeq(ctrlBranchBeq),
        .ctrlBranchBlt(ctrlBranchBlt), 
        .ctrlMemToReg(ctrlMemToReg),
        .ctrlLui(ctrlLui)
    );
endmodule

// Conntrol Unit
module ControlUnit (
    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7,
    output reg ctrlRegWrite,
    output reg [2:0] ctrlImmCtrl,
    output reg ctrlALUSrc,
    output reg [2:0] ctrlALUCtrl,
    output reg ctrlBranchJal,
    output reg ctrlBranchJalr,
    output reg ctrlBranchBeq,
    output reg ctrlBranchBlt,
    output reg ctrlMemToReg,
    output reg ctrlMemWrite,
    output reg ctrlLui
);
    always @(*) begin
        // Initialize all control signals
        ctrlRegWrite = 1'b0;
        ctrlImmCtrl = 3'bxxx;
        ctrlALUSrc = 1'b0;
        ctrlALUCtrl = 3'bxxx;
        ctrlBranchJal = 1'b0;
        ctrlBranchJalr = 1'b0;
        ctrlBranchBeq = 1'b0;
        ctrlBranchBlt = 1'b0;
        ctrlMemToReg = 1'b0;
        ctrlMemWrite = 1'b0;
        ctrlLui = 1'b0;
        case (opcode)
            // R-type
            7'b0110011: begin
                ctrlRegWrite = 1'b1;
                ctrlALUSrc = 1'b0;
                case (funct3)
                    3'b000: ctrlALUCtrl = 3'b000; // Add
                    3'b010: ctrlALUCtrl = 3'b001; // Sub
                    3'b101: ctrlALUCtrl = 3'b010; // Srl
                    3'b111: ctrlALUCtrl = 3'b011; // And
                    default: ctrlALUCtrl = 3'bxxx;
                endcase
            end
            // I-type
            // lw
            7'b0000011: begin
                ctrlRegWrite = 1'b1;
                ctrlImmCtrl = 3'b000; // I-type
                ctrlALUSrc = 1'b1;
                ctrlALUCtrl = 3'b000; // Add
                ctrlMemToReg = 1'b1;
            end 
            // addi
            7'b0010011: begin
                ctrlRegWrite = 1'b1;
                ctrlImmCtrl = 3'b000; // I-type
                ctrlALUSrc = 1'b1;
                ctrlALUCtrl = 3'b000; // Add
                ctrlMemToReg = 1'b1;
            end
            // jalr
            7'b1100111: begin
                ctrlRegWrite = 1'b1;
                ctrlImmCtrl = 3'b000; // I-type
                ctrlALUSrc = 1'b1;
                ctrlALUCtrl = 3'b000; // Add
                ctrlBranchJalr = 1'b1;
            end
            // S-type
            // sw
            7'b0100011: begin
                ctrlImmCtrl = 3'b001; // S-type
                ctrlALUSrc = 1'b1;
                ctrlALUCtrl = 3'b000; // Add
                ctrlMemWrite = 1'b1;
            end

            // B-type
            // beq, blt
            7'b1100011: begin
                ctrlImmCtrl = 3'b010; // B-type
                ctrlALUSrc = 1'b0;
                ctrlALUCtrl = 3'b001; // Sub
                case (funct3)
                    3'b000: ctrlBranchBeq = 1'b1;
                    3'b100: ctrlBranchBlt = 1'b1;
                endcase
            end

            // J-type
            // jal
            7'b1101111: begin
                ctrlRegWrite = 1'b1;
                ctrlImmCtrl = 3'b011; // J-type
                ctrlBranchJal = 1'b1;
            end

            // Others
            // U-type
            // lui
            7'b0110111: begin
                ctrlRegWrite = 1'b1;
                ctrlImmCtrl = 3'b011; // U-type
                ctrlLui = 1'b1;
            end
            // floor_log
            7'b0001011: begin
                ctrlRegWrite = 1'b1;
                ctrlALUSrc = 1'b1;
                ctrlALUCtrl = 3'b100; // Fll
                ctrlMemToReg = 1'b0;
            end

        endcase
    end
endmodule

// Data Path
module DataPath ( input        clk, reset,
                  output [31:0] PC,
                  input  [31:0] instruction,
                  output [31:0] address_to_mem,
                  output [31:0] data_to_mem,
                  input  [31:0] data_from_mem,
                  input ctrlRegWrite,
                  input [2:0] ctrlImmCtrl,
                  input ctrlALUSrc,
                  input [2:0] ctrlALUCtrl,
                  input ctrlBranchJal,
                  input ctrlBranchJalr,
                  input ctrlBranchBeq,
                  input ctrlBranchBlt,
                  input ctrlMemToReg,
                  input ctrlLui
                );
    // Program Counter Register
    wire [31:0] pc_next;
    DFF pc_reg( .clk(clk), .reset(reset), .d(pc_next), .q(PC) );

    // Adder PC + 4
    reg  [31:0] instr_size = 32'd4; // The size of an instruction in bytes (4 bytes)
    wire [31:0] pc_plus_4; // The value of PC + 4    
    Adder32 adder_pc_plus_4( .a(PC), .b(instr_size), .y(pc_plus_4) );

    // GPR Set
    wire [31:0] res; // The result to writeback to GPR
    wire [31:0] rs1, rs2;   // The values read from GPR
    wire [4:0] a1, a2, a3; // The addresses inputs for GPR
    assign a1 = instruction[19:15];
    assign a2 = instruction[24:20];
    assign a3 = instruction[11:7];
    GPRSet gpr_set( .a1(a1), .a2(a2), .a3(a3), 
                    .wd3(res), .clk(clk), .we(ctrlRegWrite), 
                    .rd1(rs1), .rd2(rs2) );

    // Immediate Decoder
    wire [24:0] imm_instr; // The immediate instruction
    assign imm_instr = instruction[31:7];
    wire [31:0] imm_op; // The immediate operand
    ImmDecoder imm_decoder_inst ( 
        .instr(imm_instr), .imm_ctrl(ctrlImmCtrl), 
        .imm_out(imm_op) );
    
    // Adder PC + Imm
    wire [31:0] pc_plus_imm; // The value of PC + immediate
    Adder32 adder_pc_plus_imm( .a(PC), .b(imm_op), .y(pc_plus_imm) );

    // Mux ALU Src
    wire [31:0] alu_src; // The value of the selected ALU source
    Mux2x1 mux_alu_src( .sel(ctrlALUSrc), .a(rs2), .b(imm_op), .y(alu_src) );

    // ALU
    wire [1:0] alu_cmp; // The comparison result
    wire [31:0] alu_out; // The ALU output 
    ALU alu_inst( .a(rs1), .b(alu_src), .alu_ctrl(ctrlALUCtrl), 
        .y(alu_out), .cmp(alu_cmp) );

    // Mux for Branch target
    wire [31:0] branch_target; // The target address for branch
    Mux2x1 mux_branch_target( .sel(ctrlBranchJalr), 
        .a(pc_plus_imm), .b(alu_out), .y(branch_target) );
    
    // Combinational logic for the branching
    reg branch_outcome; // The outcome of the branch
    reg branch_jalx; // The register is 1 when the branch is jal or jalr
    always @(*) begin
        branch_jalx = ctrlBranchJal || ctrlBranchJalr;
        if (ctrlBranchBeq) begin
            branch_outcome = (alu_cmp == 2'b00);
        end 
        else if (ctrlBranchBlt) begin
            branch_outcome = (alu_cmp == 2'b01);
        end
        else if (branch_jalx) begin
            branch_outcome = 1'b1;
        end
        else branch_outcome = 1'b0; // Otherwise, the branch is not taken
    end

    // Mux for the branch outcome
    Mux2x1 mux_pc_next( .sel(branch_outcome), .a(pc_plus_4), .b(branch_target), .y(pc_next) );

    // Data selector for the writeback
    WriteBackSelecter writeback_selecter_inst( 
        .ctrlMemToReg(ctrlMemToReg), .branch_jalx(branch_jalx), 
        .ctrlLui(ctrlLui), .data_from_mem(data_from_mem), 
        .pc_plus_4(pc_plus_4), .alu_out(alu_out), 
        .imm_op(imm_op), .res(res) );

    assign address_to_mem = alu_out;
    assign data_to_mem = rs2;


endmodule

//... add new Verilog modules here ...

// Write Back Selecter 
module WriteBackSelecter( 
    input ctrlMemToReg,
    input branch_jalx,
    input ctrlLui, 
    input [31:0] data_from_mem,
    input [31:0] pc_plus_4,
    input [31:0] alu_out,
    input [31:0] imm_op,
    output [31:0] res
);
    wire [31:0] w1, w2;
    Mux2x1 mux_inst1( .sel(branch_jalx), .a(alu_out), .b(pc_plus_4), .y(w1) );
    Mux2x1 mux_inst2( .sel(ctrlLui), .a(w1), .b(imm_op), .y(w2) );
    Mux2x1 mux_inst3( .sel(ctrlMemToReg), .a(w2), .b(data_from_mem), .y(res) );
endmodule

// Clock Triggered D Flip-Flop
module DFF( input  clk, reset,
            input  [31:0] d,
            output reg [31:0] q
          );
    always @(posedge clk) begin
        if (reset) q <= 32'd0;
        else q <= d;
    end
endmodule

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
    always @(a, b, alu_ctrl) begin
        // Initialize y and cmp
        y = 32'd0;
        cmp = 2'bxx;
        case (alu_ctrl)

            // Add - Addition
            3'b000: y = a + b;
            // Sub - Subtract
            3'b001: begin
                y = a - b;
                if (a==b) cmp = 2'b00;
                else if (a<b) cmp = 2'b01;
                else cmp = 2'b10;
            end
            // Srl - Shift Right Logical
            3'b010: y = a >> b;
            // And - Bitwise AND
            3'b011: y = a & b;
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
    integer i;
    initial begin
        for (i=0; i<32; i=i+1) begin
            gpr_arr[i] <= 32'h00000000;
        end
    end
    always @(posedge clk) begin
        gpr_arr[0] <= 32'h0; // x0 is always zero.
        if (we) begin
            gpr_arr[a3] <= wd3;
        end
        rd1 <= gpr_arr[a1];
        rd2 <= gpr_arr[a2];
    end
endmodule 

// Immediate Decoder
module ImmDecoder( input  [24:0] instr,
                   input  [2:0]  imm_ctrl,
                   output reg [31:0] imm_out
                 );
    always @(*) begin
        case (imm_ctrl) 
            // I-type
            3'b000: imm_out <= { {21{instr[24]}}, instr[23:13] };
            // S-type
            3'b001: imm_out <= { {21{instr[24]}}, instr[23:18], instr[4:0] };
            // B-type
            3'b010: imm_out <= { {20{instr[24]}}, instr[0], instr[23:18], instr[4:1], 1'b0 };
            // U-type
            3'b011: imm_out <= { instr[24:5], 12'b0 };
            // J-type
            3'b100: imm_out <= { {12{instr[24]}}, instr[12:5], instr[13], instr[23:14], 1'b0 };
            default: imm_out <= 32'dx;
        endcase
    end
endmodule


`default_nettype wire
