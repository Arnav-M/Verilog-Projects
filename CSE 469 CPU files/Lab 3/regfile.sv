`timescale 1ps/1ps

// Arnav Mathur & Anthony Pham
// CSE 469
// 11/18/2022

// This creates registers for the RegFile
module regfile (clk, RegWrite, WriteData, WriteRegister, ReadData1, ReadData2, ReadRegister1, ReadRegister2, reset);
	input  logic  clk;
	input logic RegWrite, reset;
	input logic [4:0] WriteRegister, ReadRegister1, ReadRegister2;
	input logic [63:0] WriteData;
	output logic [63:0] ReadData1, ReadData2;
	logic [31:0] decoderOutput;
	logic [31:0][63:0] registerData ;
	
	genvar i;
	
	// Takes in 5 inputs and gives out a 32 bit output
	decoder5_32 decoder(.in(WriteRegister), .out(decoderOutput), .enable(RegWrite));
	
	// Creates the initial 30 registers.
	generate
		for(i=0; i<31; i++) begin : eachRegister
			register myRegister(.clk(clk), .in(WriteData), .reset(reset), .enable(decoderOutput[i]), .out(registerData[i][63:0]));
		end
	endgenerate
	
	// Creates register 31
	register myRegister(.clk(clk), .in(64'b0), .reset(1'b1), .enable(1'b0), .out(registerData[31][63:0]));
	
	logic [63:0][31:0] registerData_flipped;
	
	genvar j;
	
	// Flips registerData to pass into mux.
	generate
		for(i=0; i<64; i++) begin : eachBit_64
			for (j=0; j<32; j++) begin :eachBit_32
				always_comb begin
					registerData_flipped[i][j] = registerData[j][i];
				end
			end
		end
	endgenerate
	
	// Creates 64 muxes for each set of data
	generate
		for(i=0; i<64; i++) begin : eachMux
			mux32_1 mux32_1(.in(registerData_flipped[i][31:0]), .out(ReadData1[i]), .sel(ReadRegister1));
			mux32_1 mux32_2(.in(registerData_flipped[i][31:0]), .out(ReadData2[i]), .sel(ReadRegister2));
		end
	endgenerate
endmodule

