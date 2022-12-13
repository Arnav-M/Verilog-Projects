// Arnav Mathur & Anthony Pham
// CSE 469
// 12/1/2022

// Checks if a value is zero or not
`timescale 1ps/1ps
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