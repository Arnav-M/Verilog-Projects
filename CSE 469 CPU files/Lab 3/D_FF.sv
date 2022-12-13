`timescale 1ps/1ps

// Arnav Mathur & Anthony Pham
// CSE 469
// 11/18/2022

// DFF module
module D_FF (q, d, reset, clk);   output reg q; 
  input d, reset, clk; 
 
  always_ff @(posedge clk) 
  if (reset) 
    q <= 0;  // On reset, set to 0 
  else 
    q <= d; // Otherwise out = d 
endmodule 

// A DFF with enable
module dff_with_enable(clk, in, reset, enable, out);

	parameter delay = 50;
	
	output logic out;
	input logic clk, reset, in, enable;
	
	logic value;
	
	logic i0;
	logic i1;
	logic i2;
	
	not #delay myNot(i0, enable);
	and #delay myAnd_1(i1, i0, out);
	and #delay myAnd_2(i2, in, enable);
	or #delay myOr(value, i1, i2);

	D_FF dflipflop (.q(out), .d(value), .reset(reset), .clk(clk));	

endmodule