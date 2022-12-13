`timescale 1ns/1ns

// Arnav Mathur & Anthony Pham
// CSE 469
// 11/18/2022

// This module takes in an input and checks if all the values in a 64 bit number are zero
module zeroChecker #(parameter WIDTH = 64) (in, out);
	parameter delay = 50;

	initial assert (WIDTH > 3);

	input logic [WIDTH-1:0] in;
	output logic out;

	logic [31:0] tempA;
	logic [15:0] tempB;
	logic [7:0] tempC;
	logic [3:0] tempD;
	
	genvar i;
	
	generate
		for(i=0; i < WIDTH; i+=2) begin : firstLoop
			or #delay (tempA[i/2], in[i], in[i+1]);
		end
		for(i=0; i < WIDTH/2; i+=2) begin : secondLoop
			or #delay (tempB[i/2], tempA[i], tempA[i+1]);
		end
		for(i=0; i < WIDTH/4; i+=2) begin : thirdLoop
			or #delay (tempC[i/2], tempB[i], tempB[i+1]);
		end
		for(i=0; i < WIDTH / 8; i+=2) begin : fourthLoop
			or #delay (tempD[i/2], tempC[i], tempC[i+1]);
		end
	endgenerate
		
	nor #delay (out, tempD[0], tempD[1], tempD[2], tempD[3]);

endmodule


module zeroChecker_testbench();

	logic [63:0] in;
	logic out, clk;
	
	parameter ClockDelay = 500000;
	
	initial begin // Set up the clock
		clk = 0;
		forever #(ClockDelay/2) clk <= ~clk;
	end

	zeroChecker dut(.in(in), .out(out));
	
	initial begin 
		@(posedge clk); 
		in = 64'b0; @(posedge clk); 
		@(posedge clk); 
		in = 64'b1; @(posedge clk); 
		@(posedge clk); 
		@(posedge clk); 
		@(posedge clk); 
		$stop;
	end
endmodule