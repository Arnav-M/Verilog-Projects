// Arnav Mathur & Anthony Pham
// CSE 469
// 12/1/2022

// Execution Stage
`timescale 1ps/1ps
module EX(ALUSrc, ALUOp, ImmVal, dataA, dataB, EX_output, negative, zero, overflow, carry_out);
    input logic ALUSrc;
    input logic [2:0] ALUOp;
    input logic [63:0] dataA, dataB, ImmVal;

    output logic negative, zero, overflow, carry_out;
    output logic [63:0] EX_output;
    
    logic [63:0] ALU_B, ALUSum;
	 
    // ALU input mux
	 dataSel2_1 ALU_inpt (.s0(ALUSrc), .A(dataB), .B(ImmVal), .OUT(ALU_B));
	
	 // ALU initialization
	 alu alu(.A(dataA), .B(ALU_B), .cntrl(ALUOp), .result(EX_output), .negative, .zero, .overflow, .carry_out);
endmodule
