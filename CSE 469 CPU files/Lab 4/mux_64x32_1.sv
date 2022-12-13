// Arnav Mathur & Anthony Pham
// CSE 469
// 12/1/2022

// 64x32_1 muxes with data flipped
`timescale 1ps/1ps
module mux_64x32_1 (data, readReg, readData);

	input logic [31:0][63:0] data;
	input logic [4:0] readReg;
	output logic [63:0] readData;
	
	logic [63:0][31:0] mirror;
	
	genvar i, j;
	generate
		for (i = 0; i < 64; i++) begin: eachCol
			for (j = 0; j < 32; j++) begin: eachRow
				assign mirror[i][j] = data[j][i];
			end
		end
	endgenerate
	
	generate
		for (i = 0; i < 64; i++) begin: muxSelect
			mux_32_1 readPort1 (.inputs(mirror[i]), .out(readData[i]), .readReg(readReg));
		end
	endgenerate
endmodule

