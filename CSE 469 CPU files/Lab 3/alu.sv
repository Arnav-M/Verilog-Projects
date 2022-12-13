// Arnav Mathur & Anthony Pham
// CSE 469
// 11/18/2022

// Module for the ALU

`timescale 1ns/1ns
 
module alu(A, B, cntrl, result, negative, zero, overflow, carry_out);
	input logic		[63:0]	A, B;
	input logic		[2:0]		cntrl;
	output logic	[63:0]	result;
	output logic				negative, zero, overflow, carry_out;
	
	logic [63:0] finalResult;
	logic [63:0] andResult, orResult, xorResult;
	logic [63:0] AddOrSubValue;
	logic [63:0] BNegative;
	
	// Invert values for subtraction
	inverter subtractor(.in(B), .out(BNegative)); 
	
	// Mux to select addition or subtraction
	genvar i;
	generate
		for(i = 0; i < 64; i++) begin : eachAddSubMux
			mux2_1 addSubMux(.out(AddOrSubValue[i]), .i0(B[i]), .i1(BNegative[i]), .sel(cntrl[0]));
		end
	endgenerate 
	
	// Initialize adder
	adder newAdder(.A(A), .B(AddOrSubValue), .sum(finalResult), .carryOut(carry_out), .overflow(overflow));
	bitwiseAnd newAnd(.A, .B, .out(andResult));
	bitwiseOr newOr(.A, .B, .out(orResult));
	bitwiseXor newXor(.A, .B, .out(xorResult));
	
	logic [63:0] zeroes;	
	logic [63:0] muxInput [7:0];
	
	assign muxInput [0] = B;
	assign muxInput [1] = zeroes;
	assign muxInput [2] = finalResult;
	assign muxInput [3] = finalResult;
	assign muxInput [4] = andResult;
	assign muxInput [5] = orResult;
	assign muxInput [6] = xorResult;
	assign muxInput [7] = zeroes;
	
	logic [7:0] muxInput_Flipped [63:0];
	
	genvar j;
	
	// Flip muxInput to put in 8_1 muxes
	generate
		for(i=0; i<8; i++) begin : eachBit_8
			for (j=0; j<64; j++) begin :eachBit_64
				always_comb begin
					muxInput_Flipped[j][i] = muxInput[i][j];
				end
			end
		end
	endgenerate
	
	// Set values of 8_1 muxes
	generate
		for(i = 0; i < 64; i++) begin : eachMux
			mux8_1 mux1(.in(muxInput_Flipped[i][7:0]), .out(result[i]), .sel(cntrl));
		end
	endgenerate
	
	// Set zero and negative flags
	zeroChecker #(.WIDTH(64)) myChecker(.in(result), .out(zero));
	assign negative = result[63]; 

endmodule

// Inverter module
module inverter #(parameter WIDTH=64) (in, out);

	parameter delay = 50;
	input logic [WIDTH-1:0] in;
	output logic [WIDTH-1:0] out;

	genvar i;

	logic [WIDTH-1:0] Nin, internalCarry, sum;
	
	logic zero, one;
	assign zero = 0;
	assign one = 1;
	
	fullAdder firstAdder(.A(Nin[0]), .B(zero), .Cin(one), .Cout(internalCarry[0]), .sum(out[0]));

	generate
		for(i=0; i < WIDTH; i++) begin : invertLoop
			not #delay thisNot(Nin[i], in[i]);
		end
		
		for(i=1; i < WIDTH; i++) begin : addLoop
			fullAdder thisAdder(.A(Nin[i]), .B(zero), .Cin(internalCarry[i-1]), .Cout(internalCarry[i]), .sum(out[i]));
		end
	endgenerate
	
endmodule


// Bitwise XOR module
module bitwiseXor #(parameter WIDTH=64) (A, B, out);
	
	parameter delay = 50;
	
	input logic[WIDTH-1:0] A, B;

	output logic[WIDTH-1:0] out; 
	
	genvar i;
		
	generate 
			for(i=0; i<WIDTH; i++) begin : eachXorGate
				xor #delay thisXor (out[i], A[i], B[i]);
			end
	endgenerate

endmodule

// Bitwise OR module
module bitwiseOr #(parameter WIDTH=64)(A, B, out);

	parameter delay = 50;
	
	input logic[WIDTH-1:0] A, B;

	output logic[WIDTH-1:0] out; 
	
	genvar i;
		
	generate 
			for(i=0; i<WIDTH; i++) begin : eachOrGate
				or #delay thisOr (out[i], A[i], B[i]);
			end
	endgenerate

endmodule

// Bitwise AND
module bitwiseAnd #(parameter WIDTH=64) (A, B, out);

	parameter delay = 50;
	
	input logic[WIDTH-1:0] A, B;

	output logic[WIDTH-1:0] out; 
	

	genvar i;
		
	generate 
			for(i=0; i<WIDTH; i++) begin : eachAndGate
				and #delay thisAnd(out[i], A[i], B[i]);
			end
	endgenerate
endmodule


