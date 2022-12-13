// Arnav Mathur & Anthony Pham
// CSE 469
// 12/1/2022

// ALU module with addition subtraction and flags
`timescale 1ps/1ps
module alu (A, B, cntrl, result, negative, zero, overflow, carry_out);
	input logic		[63:0]	A, B;
	input logic		[2:0]		cntrl;
	output logic	[63:0]	result;
	output logic				negative, zero, overflow, carry_out;
	
	logic [62:0] outputs;
	
	// ALU for bit 0
	One_Bit_ALU bit0 (.a(A[0]), .b(B[0]), .sel(cntrl), .r(result[0]), .cOut(outputs[0]), .cIn(cntrl[0]));
	
	// ALU for the rest of the bits
	genvar i;
	generate
		for (i = 1; i < 63; i++) begin : ALU_bits
			One_Bit_ALU bits(.a(A[i]), .b(B[i]), .sel(cntrl), .r(result[i]), .cOut(outputs[i]), .cIn(outputs[i-1]));
		end
	endgenerate
	
	// ALU for bit 64
	// CarryOut bit
	One_Bit_ALU bit64 (.a(A[63]), .b(B[63]), .sel(cntrl), .r(result[63]), .cOut(carry_out), .cIn(outputs[62]));
	
	// Assign Negative
	assign negative = result[63];
	
	// Overflow checker
	xor #50 of (overflow, carry_out, outputs[62]);
	
	// Zero Checker
	zeroChecker zerocheck(.in(result), .out(zero));
endmodule

module One_Bit_ALU (a, b, sel, r, cOut, cIn);
	
	input logic [2:0] sel;
	input logic a, b, cIn;
	output logic r, cOut;
	logic sum, ANDoutput, ORoutput, XORoutput, notB, bSel;
	
	not #50 inverter (notB, b);
	
	// 2:1 mux for subtraction control 
	mux2_1 sub0 (.s0(sel[0]), .a(b), .b(notB), .out(bSel));
	
	// Add A + (B or ~B)
	fullAdder adder (.a, .b(bSel), .cIn, .s(sum), .cOut);
	
	// Bitwise AND 
	and #50 and0 (ANDoutput, a, b);
	
	// Bitwise OR
	or #50 or0 (ORoutput, a, b);
	
	// Bitwise XOR
	xor #50 xor0 (XORoutput, a, b);
	
	// 8:1 Mux
	mux8_1 control (.out(r), .d({1'b0, XORoutput, ORoutput, ANDoutput, sum, sum, 1'b0, b}), .sel);
	 
endmodule