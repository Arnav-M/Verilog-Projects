// Arnav Mathur & Anthony Pham
// CSE 469
// 12/1/2022


// This is the instruction fetch stage
`timescale 1ps/1ps
module IF(clk, reset, branch, BrTaken, instruction, address);
	input logic clk, reset, BrTaken;
	input logic [63:0] branch;
	
	output logic [31:0] instruction;
	output logic [63:0] address;
	
	logic [63:0] PC, BranchSum;
	
	// BrTaken mux that chooses between PC = PC + 4 and PC + different branch;
	dataSel2_1  BrTaken_mux (.s0(BrTaken), .A(BranchSum), .B(branch), .OUT(PC));
	
	// Program Counter registers
	register Program (.Din(PC), .Dout(address), .enable(1'b1), .clk, .reset);
	
	// PC = PC + 4
	bitAddSub64 addition4 (.A(address), .B(64'd4), .cIn(1'b0), .s(BranchSum), .cOut());
	
	// Instruction memory
	instructmem instructions (.address(address), .instruction, .clk);
	
endmodule
