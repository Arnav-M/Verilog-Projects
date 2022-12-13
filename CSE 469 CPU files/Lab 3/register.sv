`timescale 1ps/1ps

// Arnav Mathur & Anthony Pham
// CSE 469
// 11/18/2022

// A singular register which uses DFF_with_enable to determine when to write data.
module register #(parameter WIDTH=64) (clk, in, reset, enable, out);
	output logic [WIDTH-1:0] out;
	input logic [WIDTH-1:0] in;
	input logic clk, enable, reset;
	
	initial assert (WIDTH > 0);

	genvar i;
	
	generate
		for(i=0; i<WIDTH; i++) begin : eachDff
			dff_with_enable dflipflop (.clk(clk), .in(in[i]), .reset(reset), .enable(enable), .out(out[i]));
		end
	endgenerate
	
endmodule

module register_testbench(); 

	logic  CLOCK_50; // 50 MHz clock
	logic [63:0] out;
	logic [63:0] in;
	logic enable, reset;
	
	parameter clk_PERIOD = 5000;
	initial begin
		CLOCK_50 <= 0;
		forever #(clk_PERIOD / 2) CLOCK_50 <= ~CLOCK_50;
	end
	
	register dut(.clk(CLOCK_50), .in, .reset, .enable, .out);
	
	initial begin 
		enable = 1; in = 32; reset = 1; @(posedge CLOCK_50);
		reset = 0; in = 43; enable = 1; @(posedge CLOCK_50);  
		@(posedge CLOCK_50);                                                                                                                                                                      
		@(posedge CLOCK_50);
		enable = 0; @(posedge CLOCK_50);
		$stop; 
	end
endmodule