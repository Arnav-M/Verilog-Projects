`timescale 1ps/1ps

// Arnav Mathur & Anthony Pham
// CSE 469
// 11/18/2022

// Adder and fulladder modules
module adder #(parameter WIDTH = 64)(A, B, sum, carryOut, overflow);

	parameter delay = 50;
	
	initial assert (WIDTH >= 2);

	input logic[WIDTH-1:0] A, B;
	output logic[WIDTH-1:0] sum; 
	output logic carryOut, overflow;

	logic [WIDTH-1:0] carryIn;
	logic zero;
	
	assign zero = 0;

	genvar i;
	
	// Adds the first bit
	fullAdder adder1 (.A(A[0]), .B(B[0]), .Cin(zero), .Cout(carryIn[0]), .sum(sum[0]));
	
	// Adds the rest of the values
	generate 
		for(i=1; i < WIDTH-1; i++) begin : eachFullAdder
			fullAdder adder2 (.A(A[i]), .B(B[i]), .Cin(carryIn[i-1]), .Cout(carryIn[i]), .sum(sum[i]));
		end
	endgenerate
	
	// Adds the last bit
	fullAdder adderLast (.A(A[WIDTH-1]), .B(B[WIDTH-1]), .Cin(carryIn[WIDTH-2]), .Cout(carryOut), .sum(sum[WIDTH-1]));
	
	logic NotAXORB, AXOROut;
	
	xnor #delay xnor1(NotAXORB, A[WIDTH-1], B[WIDTH-1]);
	xor #delay xor2(AXOROut, A[WIDTH-1], sum[WIDTH-1]);
	and #delay and1(overflow, AXOROut, NotAXORB);
	
endmodule

module fullAdder (A, B, Cin, Cout, sum);

	parameter delay = 50;

	input logic A, B, Cin;
	output logic Cout, sum;

	logic AXORB, AXORBAndCin, AAndB;

	xor #delay Xor1 (AXORB, A, B);
	xor #delay xor2 (sum, AXORB, Cin);
	and #delay and1 (AXORBAndCin, AXORB, Cin);
	and #delay and2 (AAndB, A, B);
	or #delay or1 (Cout, AAndB, AXORBAndCin);

endmodule
