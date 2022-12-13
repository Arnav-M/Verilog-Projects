// Arnav Mathur & Anthony Pham
// CSE 469
// 12/1/2022

// Sets flag that are sent by the ALU 
// flags[0] - negative
// flags[1] - zero
// flags[2] - overflow
// flags[3] - carryout
module flagSetter(flagSel, Flags, negative, zero, overflow, carryOut, reset, clk);

	input logic flagSel, negative, zero, overflow, carryOut, reset, clk;
	output logic [3:0] Flags;
	
	logic negSel, zeroSel, overSel, cOutSel;
	
	mux2_1 negativeSel (.s0(flagSel), .a(Flags[0]), .b(negative), .out(negSel));
	D_FF negative_DFF (.q(Flags[0]), .d(negSel), .reset, .clk);
	
	mux2_1 zeroSelector (.s0(flagSel), .a(Flags[1]), .b(zero), .out(zeroSel));
	D_FF zero_DFF (.q(Flags[1]), .d(zeroSel), .reset, .clk);
	
	mux2_1 overflowSel (.s0(flagSel), .a(Flags[2]), .b(overflow), .out(overSel));
	D_FF overflow_DFF (.q(Flags[2]), .d(overSel), .reset, .clk);
	
	mux2_1 CoutSel (.s0(flagSel), .a(Flags[3]), .b(carryOut), .out(cOutSel));
	D_FF cOut_DFF (.q(Flags[3]), .d(cOutSel), .reset, .clk);
	
endmodule