// Arnav Mathur & Anthony Pham
// CSE 469
// 12/1/2022

// Regfile module that produces 31 registers
module regfile (ReadData1, ReadData2, WriteData, ReadRegister1, ReadRegister2, WriteRegister,
					 RegWrite, clk);
					 
	input logic [4:0] ReadRegister1, ReadRegister2, WriteRegister;
	input logic [63:0] WriteData;
	input logic clk, RegWrite; 
	output logic [63:0] ReadData1, ReadData2;

	logic [31:0][63:0] registers; 
	logic [31:0] regEnable;
	logic [3:0] decodeEnable;
	
	// Sets up decoders
	decoder2_4 dec1 (.i(WriteRegister[4:3]), .d(decodeEnable), .enable(RegWrite));
	decoder3_8 dec2 (.i(WriteRegister[2:0]), .d(regEnable[7:0]), .enable(decodeEnable[0]));
	decoder3_8 dec3 (.i(WriteRegister[2:0]), .d(regEnable[15:8]), .enable(decodeEnable[1]));
	decoder3_8 dec4 (.i(WriteRegister[2:0]), .d(regEnable[23:16]), .enable(decodeEnable[2]));
	decoder3_8 dec5 (.i(WriteRegister[2:0]), .d(regEnable[31:24]), .enable(decodeEnable[3]));
	
	// Creates 30 registers
	genvar i;
	generate 
		for (i = 0; i < 31; i++) begin : Creating_registers
			register register (.Din(WriteData), .Dout(registers[i]), .enable(regEnable[i]), .clk, .reset(1'b0));
		end
	endgenerate
	
	// Creates zero register
	register zeroReg (.Din(64'b0), .Dout(registers[31]), .enable(1'b1), .clk, .reset(1'b0));
	
	//initialize the 64 bit wide 32:1 mux
	mux_64x32_1 mux1 (.data(registers), .readReg(ReadRegister1), .readData(ReadData1));
	mux_64x32_1 mux2 (.data(registers), .readReg(ReadRegister2), .readData(ReadData2));

endmodule 