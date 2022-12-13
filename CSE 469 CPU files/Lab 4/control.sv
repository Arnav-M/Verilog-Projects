// Arnav Mathur & Anthony Pham
// CSE 469
// 12/1/2022

// This is the ControlSignal module with instructions
`timescale 1ps/1ps
module control(opcode, Reg2Loc, ALUSrc, MemToReg, RegWrite, MemWrite, 
					BrTaken, UncondBr, ALUOp, immSize, MemRead, flagSel, zero, negative, overflow);
					
	input logic [31:0] opcode;
	input logic zero, negative, overflow;
	
	output logic Reg2Loc, ALUSrc, MemToReg, RegWrite, MemWrite, BrTaken, UncondBr, immSize, MemRead;
	output logic [2:0] ALUOp;
	output logic flagSel;
	
	always_comb begin
	
		// ADDI
		if (opcode[31:22] == 10'b1001000100) begin
			Reg2Loc = 1'bx;
			ALUSrc = 1'b1;
			MemToReg = 1'b0;
			RegWrite = 1'b1;
			MemWrite = 1'b0;
			BrTaken = 1'b0;
			UncondBr = 1'bx;
			ALUOp = 3'b010;
			immSize = 1'b1;
			MemRead = 1'b0;
			flagSel = 1'b0;
		end

		// ADDS
		else if (opcode[31:21] == 11'b10101011000) begin
			Reg2Loc = 1'b1;
			ALUSrc = 1'b0;
			MemToReg = 1'b0;
			RegWrite = 1'b1;
			MemWrite = 1'b0;
			BrTaken = 1'b0;
			UncondBr = 1'bx;
			ALUOp = 3'b010;
			immSize = 1'bX;
			MemRead = 1'b0;
			flagSel = 1'b1;
		end
		
		// B
		else if (opcode[31:26] == 6'b000101) begin
			Reg2Loc = 1'bx;
			ALUSrc = 1'bx;
			MemToReg = 1'bx;
			RegWrite = 1'b0;
			MemWrite = 1'b0;
			BrTaken = 1'b1;
			UncondBr = 1'b1;
			ALUOp = 3'bx;
			immSize = 1'bX;
			MemRead = 1'b0;
         flagSel = 1'b0;
		end
		
		// BL
		else if (opcode[31:26] == 6'b100101) begin
			Reg2Loc = 1'bx;
			ALUSrc = 1'bx;
			MemToReg = 1'bx;
			RegWrite = 1'b0;
			MemWrite = 1'b0;
			BrTaken = 1'b1;
			UncondBr = 1'b1;
			ALUOp = 3'bx;
			immSize = 1'bX;
			MemRead = 1'b0;
         flagSel = 1'b0;
		end

		// B.LT
		else if ((opcode[31:24] == 8'b01010100) && (opcode[4:0] == 5'b01011) && (negative != overflow)) begin
			Reg2Loc = 1'bx;
			ALUSrc = 1'bx;
			MemToReg = 1'bx;
			RegWrite = 1'b0;
			MemWrite = 1'b0;
			BrTaken = 1'b1; 
			UncondBr = 1'b0;
			ALUOp = 3'bx;
			immSize = 1'bX;
			MemRead = 1'b0;
         flagSel = 1'b0;
		end
		
		// BR
		else if (opcode[31:21] == 11'b11010110000) begin
			Reg2Loc = 1'b1;
			ALUSrc = 1'bx;
			MemToReg = 1'bx;
			RegWrite = 1'b0;
			MemWrite = 1'b0;
			BrTaken = 1'b1;
			UncondBr = 1'b1;
			ALUOp = 3'b000;
			immSize = 1'bX;
			MemRead = 1'b0;
         flagSel = 1'b0;
		end
		
		// CBZ
		else if (opcode[31:24] == 8'b10110100) begin
			Reg2Loc = 1'b0;
			ALUSrc = 1'b0;
			MemToReg = 1'bx;
			RegWrite = 1'b0;
			MemWrite = 1'b0;
			BrTaken = zero; // zero flag
			UncondBr = 1'b0;
			ALUOp = 3'b000;
			immSize = 1'bX;
			MemRead = 1'b0;
         flagSel = 1'b0;
		end
		
		// LDUR
		else if (opcode[31:21] == 11'b11111000010) begin
			Reg2Loc = 1'bx;
			ALUSrc = 1'b1;
			MemToReg = 1'b1;
			RegWrite = 1'b1;
			MemWrite = 1'b0;
			BrTaken = 1'b0;
			UncondBr = 1'bx;
			ALUOp = 3'b010;
			immSize = 1'b0;
			MemRead = 1'b1;
			flagSel = 1'b0;
		end

		// STUR 
		else if (opcode[31:21] == 11'b11111000000) begin
			Reg2Loc = 1'b0;
			ALUSrc = 1'b1;
			MemToReg = 1'bX;
			RegWrite = 1'b0;
			MemWrite = 1'b1;
			BrTaken = 1'b0;
			UncondBr = 1'bx;
			ALUOp = 3'b010;
			immSize = 1'b0;
			MemRead = 1'b1;
			flagSel = 1'b0;
		end

		// SUBS
		else if (opcode[31:21] == 11'b11101011000) begin
			Reg2Loc = 1'b1;
			ALUSrc = 1'b0;
			MemToReg = 1'b0;
			RegWrite = 1'b1;
			MemWrite = 1'b0;
			BrTaken = 1'b0;
			UncondBr = 1'bx;
			ALUOp = 3'b011;
			immSize = 1'bX;
			MemRead = 1'b0;
			flagSel = 1'b1;
		end

		// Default
		else begin 
			Reg2Loc = 1'bX;
			ALUSrc = 1'bX;
			MemToReg = 1'bx;
			RegWrite = 1'b0;
			MemWrite = 1'b0;
			BrTaken = 1'b0;
			UncondBr = 1'bX;
			ALUOp = 3'bXXX;
			immSize = 1'bX;
			MemRead = 1'b0;
         flagSel = 1'b0;
		end
	end
	
endmodule 


