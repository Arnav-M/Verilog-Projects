// Arnav Mathur & Anthony Pham
// CSE 469
// 12/1/2022

// This module is a pipelined CPU that uses an ALU, datamem, instructionmem, registers, control logic,
// flags, instructions to run commands such as  B, BL, BLT, CBZ, ADDI, ADDS, BR, LDUR, STUR, SUBS.
// The CPU has registers and D_FF modules in between stages to allow for pipelining. It also has a
// forwarding unit to forward data and flags.

module Pipelined_CPU(reset, clk);
	input logic clk, reset;
	
	/*------------------------------- Stage 1 - Instruction Fetch ---------------------------------*/ 

	logic [63:0] NextBranchCount, IF_Address, RF_Address;
   logic [31:0] IF_opcode, RF_opcode;
	logic [3:0] Flags;
	
	logic negative, zero, overflow, carry_out, BrTaken;

	// Instruction Fetch Stage
	IF stage1 (.clk, .reset, .branch(NextBranchCount), .BrTaken, .instruction(IF_opcode), .address(IF_Address));
	
	// Registers between IF and RF
	register #(64) program_counter(.Din(IF_Address), .Dout(RF_Address), .enable(1'b1), .clk, .reset);
   register #(32) opcodes(.Din(IF_opcode), .Dout(RF_opcode), .enable(1'b1), .clk, .reset);

	/*------------------------------- Stage 2 - Register Fetch -----------------------------------*/

	logic [63:0] RF_Data1, RF_Data2, RF_ImmVal, 
					 EX_Data1, EX_Data2, EX_ImmVal, EX_ALU_output,
					 MEM_ALU_output, MEM_WriteData, WB_WriteData;			 
	logic [6:0] RF_Flags, EX_Flags;
	logic [4:0] RF_RegWrite, EX_RegWrite, Db, WB_RegWrite;
	logic [2:0] RF_ALUOp, EX_ALUOp;
	logic [1:0] ForwardingData1, ForwardingData2;
	
	logic RF_ALUSrc, RF_EX_MemWrite, RF_MemToReg, RF_EX_RegWrite,RF_MemRead, RF_FlagOp, 
			EX_ALUSrc, EX_MEM_MemWrite, EX_MemToReg, EX_MEM_RegWrite, EX_MemRead, EX_FlagOp, 
			MEM_WB_RegWrite, forwarding_flags;
		
	// Register Fetch Stage
	RF stage2 (.clk, .instruction(RF_opcode), .address(RF_Address), .DataMem(MEM_WriteData), 
	       .ALUOut(EX_ALU_output), .WriteData(WB_WriteData), .readA(RF_Data1), .readB(RF_Data2), 
			 .ImmVal(RF_ImmVal), .forwardOpA(ForwardingData1), .forwardOpB(ForwardingData2), 
			 .writeEnable(MEM_WB_RegWrite), .ALUSrc(RF_ALUSrc), .ALUOp(RF_ALUOp), .MemWrite(RF_EX_MemWrite), 
		    .MemToReg(RF_MemToReg), .RegWrite(RF_EX_RegWrite), .BranchSum(NextBranchCount), .BrTaken, 
		    .WriteRegister(WB_RegWrite), .Rd(RF_RegWrite),.MemRead(RF_MemRead), .flagSel(RF_FlagOp), 
			 .negative(Flags[0]), .overflow(Flags[2]), .Db, .forwardNegFlag(negative), .forwardOverFlag(overflow), 
			 .forwarding_flags);

	assign RF_Flags = RF_opcode[31:25];
	
	// Registers for forwarding between RF and EX
	register #(64) dataA_reg (.Din(RF_Data1), .Dout(EX_Data1), .enable(1'b1), .clk, .reset);
	register #(64) dataB_reg (.Din(RF_Data2), .Dout(EX_Data2), .enable(1'b1), .clk, .reset);
	register #(64) ImmVal_reg (.Din(RF_ImmVal), .Dout(EX_ImmVal), .enable(1'b1), .clk, .reset);

	// Forwarding register for Negative and Overflow flags
	register #(7) neg_over_register (.Din(RF_Flags), .Dout(EX_Flags), .enable(1'b1), .clk, .reset); 
	register #(5) RegWrite_register (.Din(RF_RegWrite), .Dout(EX_RegWrite), .enable(1'b1), .clk, .reset);
	register #(3) ALUOp_register (.Din(RF_ALUOp), .Dout(EX_ALUOp), .enable(1'b1), .clk, .reset);

	D_FF ALUSrc_register (.q(EX_ALUSrc), .d(RF_ALUSrc), .reset, .clk);
	D_FF MemWrite_register (.q(EX_MEM_MemWrite), .d(RF_EX_MemWrite), .reset, .clk);
	D_FF MemToReg_register (.q(EX_MemToReg), .d(RF_MemToReg), .reset, .clk);
	D_FF RegWrite_RF_EX_register (.q(EX_MEM_RegWrite), .d(RF_EX_RegWrite), .reset, .clk);
	D_FF MemRead_reg (.q(EX_MemRead), .d(RF_MemRead), .reset, .clk);
	D_FF FlagOp_reg (.q(EX_FlagOp), .d(RF_FlagOp), .reset, .clk);

	/*---------------------------------- Stage 3 - Execute ------------------------------------------*/
	
	logic [4:0] MEM_RegWrite;
	logic [63:0] MEM_Db;
   
   logic MEM_MemWrite, MEM_MemToReg, MEM_EX_RegWrite, MEM_MemRead;

	EX stage3 (.ALUSrc(EX_ALUSrc), .ALUOp(EX_ALUOp), .ImmVal(EX_ImmVal), 
				  .dataA(EX_Data1), .dataB(EX_Data2), .EX_output(EX_ALU_output),
				  .negative, .zero, .overflow, .carry_out);
	
	// Forwarding registers between EX and MEM
	D_FF MemWrite_dff (.q(MEM_MemWrite), .d(EX_MEM_MemWrite), .reset, .clk);
   D_FF MemToReg_dff (.q(MEM_MemToReg), .d(EX_MemToReg), .reset, .clk);
   D_FF RegWrite_dff (.q(MEM_EX_RegWrite), .d(EX_MEM_RegWrite), .reset, .clk);
	D_FF MemRead_dff (.q(MEM_MemRead), .d(EX_MemRead), .reset, .clk);

   register #(64) ALU_out_dff (.Din(EX_ALU_output), .Dout(MEM_ALU_output), .enable(1'b1), .clk, .reset);
   register #(5) WriteRegister_dff (.Din(EX_RegWrite), .Dout(MEM_RegWrite), .enable(1'b1), .clk, .reset);
   register #(64) mem_Din_dff (.Din(EX_Data2), .Dout(MEM_Db), .enable(1'b1), .clk, .reset);
	
	/*--------------------------------- Stage 4 - Memory -------------------------------------------*/
	
	MEM stage4 (.clk, .reset, .MemWrite(MEM_MemWrite), .DataMem_in(MEM_Db), .MemAddress(MEM_ALU_output),
			      .WriteBack(MEM_WriteData), .MemRead(MEM_MemRead), .MemToReg(MEM_MemToReg));
	
	// Forwarding Registers between MEM and WB	
	D_FF regWrite_E_dff (.q(MEM_WB_RegWrite), .d(MEM_EX_RegWrite), .reset, .clk);
   register #(64) WriteData_dff (.Din(MEM_WriteData), .Dout(WB_WriteData), .enable(1'b1), .clk, .reset);
   register #(5) regWrite_dff (.Din(MEM_RegWrite), .Dout(WB_RegWrite), .enable(1'b1), .clk, .reset);
	
	// Forwarding Unit
	forwarding_unit unit (.address_A(RF_opcode[9:5]), .address_B(Db), .MEM_RegWrite(MEM_RegWrite),
			.MEM_EX_RegWrite(MEM_EX_RegWrite), .ALU_RegWrite(EX_RegWrite), .EX_MEM_Regwrite(EX_MEM_RegWrite),
			.forwarding1(ForwardingData1), .forwarding2(ForwardingData2), .EX_Flags, .RF_Instr(RF_opcode[31:24]), 
			.forwarding_flags);
			
	// Sets Flags
	flagSetter flagSel (.flagSel(EX_FlagOp), .Flags, .negative, .zero, .overflow, .carryOut(carry_out), .reset, .clk);
	
	// Stage 5 uses Stage 4 write data to set Execute registers
endmodule

`timescale 1ps/1ps
module Pipelined_CPU_testbench();
	logic clk, reset;
	
	parameter ClockDelay = 20000;

	 Pipelined_CPU dut (.*);

   initial begin // Set up the clock
		clk <= 0;
		forever #(ClockDelay/2) clk <= ~clk;
	end
	
	initial begin
		reset <= 1'b1; repeat(2)@(posedge clk);
		reset <= 1'b0; @(posedge clk);
		repeat(100)@(posedge clk);
		$stop;
	end
endmodule

