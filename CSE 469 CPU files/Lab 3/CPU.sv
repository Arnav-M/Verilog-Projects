`timescale 1ps/1ps

// Arnav Mathur & Anthony Pham
// CSE 469
// 11/18/2022

// This module is a single cycle CPU that uses ALU, datamem, instructionmem, registers, control logic,
// flags, instructions to run commands such as  B, BL, BLT, CBZ, ADDI, ADDS, BR, LDUR, STUR, SUBS.
module CPU(clock, reset);

input logic clock;
input logic reset;

// Control Logic
logic [31:0] opcode;
logic Reg2Loc, ALUSrc, MemToReg, ImmSel, RegWrite, MemWrite, BrTaken, UncondBr;
logic [2:0] ALUOp;

// Flag Logic
logic zeroFlag, zero, negativeFlag, negative, overflowFlag, overflow, carryoutFlag, carryout;
logic CBZBranch, BLTBranch, BRBranch, BLBranch;

/*------------------------------------------Instructions-------------------------------------------------------- */

logic [63:0] PC;
logic [63:0] CondAddrExtended, BrAddrExtended, Address, ShiftedAddress, NextAddress, NextBranchCount, Count;
logic [18:0] CondAddr19;
logic [25:0] BrAddr26;

assign CondAddr19 =  opcode[23:5];
assign BrAddr26 = opcode[25:0];

// Sign extend CondAddr and BrAddr
extender #(.LENGTH(19))  CondXtend (.in(CondAddr19), .isSigned(1'b1), .out(CondAddrExtended));
extender  #(.LENGTH(26)) BrXtend (.in(BrAddr26), .isSigned(1'b1), .out(BrAddrExtended));

genvar i;

// Branch Address Mux
generate
	for(i = 0; i < 64; i++) begin : eachBrAddrBit
		mux2_1 BrAddrMux (.out(Address[i]), .i0(CondAddrExtended[i]), .i1(BrAddrExtended[i]), .sel(UncondBr));
	end
endgenerate

// Shifts the Address by 2
shifter addressShifter(.value(Address), .direction(1'b0), .distance(6'b000010), .result(ShiftedAddress));

// Updates the program counter and gets next address
adder BranchAdder(.A(ShiftedAddress), .B(PC), .sum(NextBranchCount), .carryOut(), .overflow());
adder CountAdder (.A(PC), .B(4), .sum(Count), .carryOut(), .overflow());

// Branch Selection Mux
generate
	for(i = 0; i < 64; i++) begin : eachB
		mux2_1 Br1SelMux (.out(NextAddress[i]), .i0(Count[i]), .i1(NextBranchCount[i]), .sel(BrTaken));
	end
endgenerate

// Generate registers for PC
register register(.clk(clock), .in(NextAddress), .reset(reset), .enable(1'b1), .out(PC));

// Access instruction memory
instructmem instructionMemory (.address(PC), .instruction(opcode), .clk(clock));

/*-----------------------------------------------Datapath-------------------------------------------------------- */

logic [63:0] DAddrExtended, Imm12Extended, WriteToReg, WriteToRegFinal, MemOrALU, ALU_B, Da, Db, ImmValue, ALUResult, Dout, RdOrX30;
logic [63:0] x30;
logic [4:0] Rd, Rm, Rn, Ab;
logic [8:0] DAddr9;
logic [11:0] Imm12;

assign Rd = opcode[4:0];
assign Rm = opcode[20:16];
assign Rn = opcode[9:5];
assign DAddr9 = opcode[20:12];
assign Imm12 = opcode[21:10];
assign x30 = 64'b0000000000000000000000000000000000000000000000000000000000011110;

and #50 thisAnd(BRBranch, BrTaken, Reg2Loc);

// Mux for BR
generate
	for(i = 0; i < 5; i++) begin : eachRdBit
		mux2_1 aMux (.out(RdOrX30[i]), .i0(Rd[i]), .i1(x30[i]), .sel(BLBranch));
	end
endgenerate

// Mux for the Regfile
generate
	for(i = 0; i < 5; i++) begin : eachRegisterBit
		mux2_1 bMux (.out(Ab[i]), .i0(Rd[i]), .i1(Rm[i]), .sel(Reg2Loc));
	end
endgenerate

// Initializes Regfile
regfile RegisterFile (.clk(clock), .RegWrite(RegWrite), .WriteData(WriteToReg), .WriteRegister(Rd), 
.ReadData1(Da), .ReadData2(Db), .ReadRegister1(Rn), .ReadRegister2(Ab), .reset(reset));

// Sign extending DAddr9 and Imm12
extender #(.LENGTH(9)) DXtend  (.in(DAddr9), .isSigned(1'b1), .out(DAddrExtended));
extender #(.LENGTH(12)) Imm12Xtend (.in(Imm12), .isSigned(1'b0), .out(Imm12Extended));

// Muxes for selection between Imm12 and DAddr9 and then ALU_B
generate
	for(i = 0; i < 64; i++) begin : eachDataBit
		mux2_1 Imm12Mux(.out(ImmValue[i]), .i0(DAddrExtended[i]), .i1(Imm12Extended[i]), .sel(ImmSel));
		mux2_1 ALU_BMux (.out(ALU_B[i]), .i0(Db[i]), .i1(ImmValue[i]), .sel(ALUSrc));
	end
endgenerate

// CBZ checker and B.LT flag assignment
zeroChecker CBZChecker (.in(Db), .out(CBZBranch));
assign BLTBranch = negativeFlag ^ overflowFlag;

// ALU initialization
alu myALU(.A(Da), .B(ALU_B), .cntrl(ALUOp), .result(ALUResult), .negative(negative), .zero(zero), 
.overflow(overflow), .carry_out(carryout));

// Memory initialization with constant xfer (our instructions don't require changes)
datamem DataMemory (.address(ALUResult), .write_enable(MemWrite), .read_enable(1'b1), 
.write_data(Db), .clk(clock), .xfer_size(4'b1000), .read_data(Dout));

// X30 or ALU Mux for BR
generate
	for(i = 0; i < 64; i++) begin : eachALUMEMorX30Bit
		mux2_1 ALUOrX30Mux(.out(WriteToReg[i]), .i0(MemOrALU[i]), .i1(x30[i]), .sel(BLBranch));
	end
endgenerate

// Memory/ALU Mux
generate
	for(i = 0; i < 64; i++) begin : eachMemOrALUBit
		mux2_1 MemOrALUMux(.out(WriteToReg[i]), .i0(ALUResult[i]), .i1(Dout[i]), .sel(MemToReg));
	end
endgenerate

// X30 or ALU Mux for BR
generate
	for(i = 0; i < 64; i++) begin : eachMemOrBit
		mux2_1 MemOrALUMux(.out(WriteToRegFinal[i]), .i0(MemOrALU[i]), .i1(x30[i]), .sel(BLBranch));
	end
endgenerate



/*-----------------------------------------Control Logic--------------------------------------------------*/

typedef enum {RESET, B, BL, BLT, CBZ, ADDI, ADDS, BR, LDUR, STUR, SUBS} opcodes;

opcodes opcodeType;

// Set flags for CBZ and B.LT
always @(CBZBranch, BLTBranch) begin
	if(opcode[31:24] == 8'b10110100) begin
		BrTaken <= CBZBranch; // CBZ flag setter
	end else if(opcode[31:24] == 8'b01010100) begin
		BrTaken <= BLTBranch; // BLT flag setter
	end else if(opcode[31:21] == 11'b11010110000) begin
		BrTaken <= BRBranch;
	end
end

// Set flags for ADDS and SUBS
always @(ALUResult) begin
	case(opcode[31:21]) 
		11'b10101011000 : begin //ADDS
			zeroFlag <= zero;
			carryoutFlag <= carryout;
			negativeFlag <= negative;
			overflowFlag <= overflow;
		end
		11'b11101011000 : begin //SUBS
			zeroFlag <= zero;
			carryoutFlag <= carryout;
			negativeFlag <= negative;
			overflowFlag <= overflow;
		end
	endcase
end


// Main control logic
always @(opcode) begin
	case(reset) 
		1'b1: begin
		opcodeType <= RESET;
		opcode <= 0;
		PC <= 0;
		zeroFlag <= 0;
		negativeFlag <= 0;
		overflowFlag <= 0;
		carryoutFlag <= 0;
		ALUOp <= 3'b0;
		Reg2Loc <= 1'b0;
		ALUSrc <= 1'b0;
		MemToReg <= 1'b0;
		ImmSel <= 1'b0;
		RegWrite <= 1'b0;
		MemWrite <= 1'b0;
		BrTaken <= 1'b0;
		UncondBr <= 1'b0;
	end
	default : begin
		case(opcode[31:26])
			6'b000101 : begin
				//B
				opcodeType <= B;
				RegWrite <= 0;
				MemWrite <= 0;
				BrTaken <= 1;
				UncondBr <= 1;
			end
			6'b100101 : begin
				// BL
				opcodeType <= BL;				
				RegWrite <= 0;
				MemWrite <= 0;
				BrTaken <= 1;
				UncondBr <= 1;
			end
			default: begin
				case(opcode[31:24])
					8'b01010100 : begin
						//B.LT
						opcodeType <= BLT;				
						Reg2Loc <= 0;
						ALUSrc <= 0;
						RegWrite <= 0;
						MemWrite <= 0;
						BrTaken <= BLTBranch;
						UncondBr <= 0;
						ALUOp <= 3'b000;
					end
					8'b10110100 : begin
						//CBZ
						opcodeType <= CBZ;
						Reg2Loc <= 0;
						ALUSrc <= 0;
						RegWrite <= 0;
						MemWrite <= 0;
						BrTaken <= CBZBranch;
						UncondBr <= 0;
						ALUOp <= 3'b000;
					end
					default: begin
						case(opcode[31:22])
						10'b1001000100 : begin
							//ADDI
							opcodeType <= ADDI;
							Reg2Loc <= 1;
							ALUSrc <= 1;
							MemToReg <= 0;
							RegWrite <= 1;
							MemWrite <= 0;
							BrTaken <= 0;
							ImmSel <= 1;
							ALUOp <= 3'b010;
						end
						default: begin
							case(opcode[31:21])
								11'b10101011000 : begin
									//ADDS
									opcodeType <= ADDS;
									Reg2Loc <= 1;
									ALUSrc <= 0;
									MemToReg <= 0;
									RegWrite <= 1;
									MemWrite <= 0;
									BrTaken <= 0;
									ALUOp <= 3'b010;
								end
								11'b11010110000: begin
									// BR
									opcodeType <= BR;				
									Reg2Loc <= 1;
									RegWrite <= 0;
									MemWrite <= 0;
									BrTaken <= 1;
									UncondBr <= 1;
									ALUOp <= 3'b000;
								end
								11'b11111000010 : begin
									//LDUR
									opcodeType <= LDUR;
									ALUSrc <= 1;
									MemToReg <= 1;
									RegWrite <= 1;
									MemWrite <= 0;
									BrTaken <= 0;
									ImmSel <= 0;
									ALUOp <= 3'b010;
								end
								11'b11111000000 : begin
									//STUR
									opcodeType <= STUR;
									Reg2Loc <= 0;
									ALUSrc <= 1;
									RegWrite <= 0;
									MemWrite <= 1;
									BrTaken <= 0;
									UncondBr <= 1;
									ImmSel <= 0;
									ALUOp <= 3'b010;
								end
								11'b11101011000 : begin
									//SUBS
									opcodeType <= SUBS;
									Reg2Loc <= 1;
									ALUSrc <= 0;
									MemToReg <= 0;
									RegWrite <= 1;
									MemWrite <= 0;
									BrTaken <= 0;
									ALUOp <= 3'b011;
								end
							endcase
						end
					endcase
				end
			endcase
		end
	endcase
end
endcase
end
endmodule


module CPU_testbench();

	parameter ClockDelay = 500000;
	logic					clk, reset;
	
	CPU dut (.clock(clk), .reset);
	
	initial begin // Set up the clock
		clk = 0;
		forever #(ClockDelay/2) clk <= ~clk;
	end
	
	integer i;
	initial begin
			reset = 0;@(posedge clk); 
			@(posedge clk); 
			reset = 1; @(negedge clk); 
			@(posedge clk); 
			reset = 0; @(negedge clk); 
			repeat(200) begin
			reset = 0; @(posedge clk); 
			end
		$stop;
		
	end
endmodule

