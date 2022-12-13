`timescale 1ps/1ps

// Arnav Mathur & Anthony Pham
// CSE 469
// 11/18/2022

// This is an extender module that takes in a <= 16 bit number and converts it to 64 bit number
module extender #(parameter LENGTH = 16) (in, isSigned, out);
	input logic [LENGTH-1:0] in;
	input logic isSigned; 
	output logic [63:0] out;
	
	logic outputs;
		
	assign out[LENGTH-1:0] = in[LENGTH-1:0];
	
	mux2_1 extender (.out(outputs), .i0(1'b0), .i1(in[LENGTH-1]), .sel(isSigned));
	
	genvar i;
	generate
		for(i=LENGTH; i < 64; i++) begin : MuxInput
			assign out[i] = outputs;
		end
	endgenerate
	
endmodule

module extender_testbench();

	parameter ClockDelay = 5000;

	logic [15:0] in;
	logic [63:0] out;
	logic isSigned;
	logic clk;

	extender dut (.in, .isSigned, .out);
	
	initial begin // Set up the clock
		clk <= 0;
		forever #(ClockDelay/2) clk <= ~clk;
	end
	
	initial begin
			in = 5; isSigned = 0; @(posedge clk); 
			in = 5; isSigned = 1; @(posedge clk); 
			isSigned = 0; @(posedge clk); 
			in = 0; isSigned = 1; @(posedge clk); 
			in = -90; isSigned = 1; @(posedge clk); 
			in = -900; isSigned = 0; @(posedge clk); 
			$stop;
	end
endmodule