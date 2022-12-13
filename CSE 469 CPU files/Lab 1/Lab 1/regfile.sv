`timescale 1ns/10ps
// Arnav Mathur
// EE 469
// 10/12/2022

// The full register module.
module regfile (ReadData1, ReadData2, WriteData, ReadRegister1, ReadRegister2, WriteRegister, RegWrite, clk);
    input logic [63:0] WriteData;
    input logic [4:0] ReadRegister1, ReadRegister2, WriteRegister;
    input logic RegWrite, clk;
    output logic [63:0] ReadData1, ReadData2;
    logic [31:0] decoderOut;
    logic [63:0][31:0] registerOut;

    decoder5_32 decode (.in(WriteRegister[4:0]), .out(decoderOut[31:0]), .en(RegWrite));

    genvar i;

    // For the 64 pairs of mux.
    generate
        for (i = 0; i < 64; i++) begin : eachMux
            mux32_1 readDataMux1 (.in(registerOut[i][31:0]), .out(ReadData1[i]), .sel(ReadRegister1[4:0]));
            mux32_1 readDataMux2 (.in(registerOut[i][31:0]), .out(ReadData2[i]), .sel(ReadRegister2[4:0]));
        end
    endgenerate

    genvar j;

    // For generating the first 31 registers.
    generate
        for (i = 0; i < 31; i++) begin : eachRegs
            for (j = 0; j < 64; j++) begin : eachBit
                D_FF_with_en oneBit (.clk(clk), .q(registerOut[j][i]), .d(WriteData[j]), .enable(decoderOut[i]));
            end
        end
    endgenerate
    
    // For generating the last register with a 0.
    generate
            for (j = 0; j < 64; j++) begin : eachBit31
                assign registerOut[j][31] = 1'b0;
            end
    endgenerate

endmodule