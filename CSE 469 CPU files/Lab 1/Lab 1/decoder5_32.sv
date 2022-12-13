// Arnav Mathur
// EE 469
// 10/12/2022

`timescale 1ns/10ps

// Decoder for 5 inputs and 32 outputs.
module decoder5_32(in, out, en);
    output logic [31:0] out;
    input logic [4:0] in;
    input logic en;
    logic [3:0] suben;
    
    decoder2_4 enablecontrol (.in(in[4:3]), .out(suben[3:0]), .en(en));
    decoder3_8 subdecoder1 (.in(in[2:0]), .out(out[7:0]), .en(suben[0]));
    decoder3_8 subdecoder2 (.in(in[2:0]), .out(out[15:8]), .en(suben[1]));
    decoder3_8 subdecoder3 (.in(in[2:0]), .out(out[23:16]), .en(suben[2]));
    decoder3_8 subdecoder4 (.in(in[2:0]), .out(out[31:24]), .en(suben[3]));
	 
endmodule

// Testbench for the module.
module decoder5_32_testbench();
    logic [31:0] out;
    logic [4:0] in;
    logic en;
    integer i;
     
    decoder5_32 dut(.in, .out, .en);
    
    initial begin
        en = 1;
        for (i = 0; i < 32; i++) begin
            in[4:0] = i; #500;
        end

        en = 0;
        for (i = 0; i < 32; i++) begin
            in[4:0] = i; #500;
        end
    end
endmodule
