// Arnav Mathur & Anthony Pham
// CSE 469
// 12/1/2022

// Creates one register using mux and D_FF
`timescale 1ps/1ps
module register #(parameter WIDTH = 64)(Din, Dout, enable, clk, reset);

	input logic [WIDTH-1:0] Din;
	input logic enable, clk, reset;
	output logic [WIDTH-1:0] Dout;
	
	logic [WIDTH-1:0] muxOut;
	genvar i;
	generate

		for(i = 0; i < WIDTH; i = i + 1) begin : building_one_register
			mux2_1 selector (.s0(enable), .a(Dout[i]), .b(Din[i]), .out(muxOut[i]));
			D_FF bits (.q(Dout[i]), .d(muxOut[i]), .reset, .clk);
		end
		
	endgenerate

endmodule

// DFF given in lab specs
module D_FF (q, d, reset, clk);
  output reg q; 
  input d, reset, clk; 
 
  always_ff @(posedge clk) 
  if (reset) 
    q <= 0;  // On reset, set to 0 
  else 
    q <= d; // Otherwise out = d 
endmodule

