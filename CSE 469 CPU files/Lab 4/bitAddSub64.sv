// Arnav Mathur & Anthony Pham
// CSE 469
// 12/1/2022

// 64 bit adder
`timescale 1ps/1ps
module bitAddSub64 #(parameter WIDTH = 64) (A, B, cIn, s, cOut);
	input logic [WIDTH-1:0] A, B;
	input logic cIn;
	output logic [WIDTH-1:0] s;
	output logic cOut;
	
	logic [63:0] carryOut;
	fullAdder bit_0 (.a(A[0]), .b(B[0]), .cIn, .s(s[0]), .cOut(carryOut[0]));
	
	genvar i;
	generate
		for (i = 1; i < 63; i++) begin : addBit
			fullAdder bit_i (.a(A[i]), .b(B[i]), .cIn(carryOut[i-1]), .s(s[i]), .cOut(carryOut[i]));
		end
	endgenerate
	
	fullAdder bit_64 (.a(A[63]), .b(B[63]), .cIn(carryOut[62]), .s(s[63]), .cOut);
	
endmodule

// One bit adder
module fullAdder (a, b, cIn, s, cOut);
	input logic a, b, cIn;
	output logic cOut, s;
	
	logic t0, t1, t2;
	
	xor #50 sum (s, a, b, cIn);
	
	and #50 and0 (t0, a, cIn);
	and #50 and1 (t1, a, b);
	and #50 and2 (t2, b, cIn);
	or #50 C (cOut, t0, t1, t2);
 
 endmodule
 