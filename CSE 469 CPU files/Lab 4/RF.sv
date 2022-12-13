// Arnav Mathur & Anthony Pham
// CSE 469
// 12/1/2022


// RF stage
// Uses Muxes, flags and forwarding to do the Register fetch stage
`timescale 1ps/1ps
module RF(clk, instruction, address, DataMem, ALUOut, WriteData, readA, readB, ImmVal,
		forwardOpA, forwardOpB, writeEnable, ALUSrc, ALUOp, MemWrite, MemToReg, RegWrite,
		BranchSum, BrTaken, WriteRegister, Rd, MemRead, flagSel,
		negative, overflow, Db, forwardNegFlag, forwardOverFlag, forwarding_flags);
		
	input logic clk, writeEnable, negative, overflow, forwardNegFlag, forwardOverFlag, forwarding_flags;
	input logic [63:0] address, DataMem, ALUOut, WriteData;
	input logic [31:0] instruction;
	input logic [4:0] WriteRegister;
	input logic [1:0] forwardOpA, forwardOpB;
	
	output logic [63:0] readA, readB, BranchSum, ImmVal;
	output logic [4:0] Rd, Db;
	output logic [2:0] ALUOp; 
	
	output logic ALUSrc, MemWrite, MemToReg, RegWrite, BrTaken, MemRead, flagSel;
	 
	logic [63:0] CondAddrExtended, BrAddrExtended, addr, Imm12, ALU_B;
	
	assign Rd = instruction[4:0];
	
	// Control flags
	logic zeroFlag, Reg2Loc, UncondBr, immSize;
	
	// Shifts data by 2
	shifter addressShifter(.value({{38{instruction[25]}}, instruction[25:0]}), .direction(1'b0),
	.distance(6'b000010), .result(BrAddrExtended));
	shifter addressShifter2(.value({{45{instruction[23]}}, instruction[23:5]}), .direction(1'b0), 
	.distance(6'b000010), .result(CondAddrExtended));
	
	// ImmValue mux
	dataSel2_1  UncondBr_mux (.s0(UncondBr), .A(CondAddrExtended), .B(BrAddrExtended), .OUT(addr));
	
	// Adds PC and Imm12
	logic PC_carryout;
	bitAddSub64 PCandImm (.A(addr), .B(address), .cIn(1'b0), .s(BranchSum), .cOut(PC_carryout));

	// Reg2Loc mux
	dataSel2_1 #(5) reg_input_Ab (.s0(Reg2Loc), .A(instruction[4:0]), .B(instruction[20:16]), .OUT(Db));
	
   logic nClk;
   not #50 inv (nClk, clk);
	logic [63:0] Da_out, Db_out;
	
	// Register File
	regfile register (.ReadData1(Da_out), .ReadData2(Db_out), .WriteData(WriteData), .ReadRegister1(instruction[9:5]),
					 .ReadRegister2(Db), .WriteRegister, .RegWrite(writeEnable), .clk(nClk));
					 
	// Sign extend the two values.
	assign Imm12 = {{52'd0}, {instruction[21:10]}};
	assign ALU_B = {{56{instruction[20]}}, {instruction[19:12]}};
	
	//2:1 mux to select ImmValue
	dataSel2_1 imm_sel (.s0(immSize), .A(ALU_B), .B(Imm12), .OUT(ImmVal));

	// Mux for Forwarding
	mux3_1 muxA (.A(Da_out), .B(ALUOut), .C(DataMem), .sel(forwardOpA), .OUT(readA));
	mux3_1 muxB (.A(Db_out), .B(ALUOut), .C(DataMem), .sel(forwardOpB), .OUT(readB));

	// Checks for ZeroFlag
	zeroChecker zerocheck(.in(readB), .out(zeroFlag));
	
	// Control flags
	logic negativeFlag, overflowFlag;
	
	// forwarding alu flags
	mux2_1 forwardmuxNeg (.s0(forwarding_flags), .a(negative), .b(forwardNegFlag), .out(negativeFlag));
	mux2_1 forwardmuxOver (.s0(forwarding_flags), .a(overflow), .b(forwardOverFlag), .out(overflowFlag));
	
	// Control Unit
	control cntrl (.opcode(instruction), .Reg2Loc, .ALUSrc, .MemToReg, 
					.RegWrite(RegWrite), .MemWrite(MemWrite), .BrTaken, .UncondBr, .ALUOp, 
					.immSize, .MemRead, .flagSel, .zero(zeroFlag), .negative(negativeFlag), 
					.overflow(overflowFlag));
					
endmodule


