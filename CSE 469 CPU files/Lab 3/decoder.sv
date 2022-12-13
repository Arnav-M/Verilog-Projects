`timescale 1ps/1ps

// Arnav Mathur & Anthony Pham
// CSE 469
// 11/18/2022

// Decoder for 5 inputs and 32 outputs
module decoder5_32(in, out, enable);
    output logic [31:0] out;
    input logic [4:0] in;
    input logic enable;
    logic [3:0] suben;
    
    decoder2_4 enablecontrol (.in(in[4:3]), .out(suben[3:0]), .en(enable));
    decoder3_8 subdecoder1 (.in(in[2:0]), .out(out[7:0]), .en(suben[0]));
    decoder3_8 subdecoder2 (.in(in[2:0]), .out(out[15:8]), .en(suben[1]));
    decoder3_8 subdecoder3 (.in(in[2:0]), .out(out[23:16]), .en(suben[2]));
    decoder3_8 subdecoder4 (.in(in[2:0]), .out(out[31:24]), .en(suben[3]));
	 
endmodule

// Testbench for the module.
module decoder5_32_testbench();
    logic [31:0] out;
    logic [4:0] in;
    logic enable;
    integer i;
     
    decoder5_32 dut(.in, .out, .enable);
    
    initial begin
        enable = 1;
        for (i = 0; i < 32; i++) begin
            in[4:0] = i; #500;
        end

        enable = 0;
        for (i = 0; i < 32; i++) begin
            in[4:0] = i; #500;
        end
    end
endmodule

// Decoder for 3 inputs and 8 outputs.
module decoder3_8(in, out, en);
    output logic[7:0] out;
    input logic [2:0] in;
    input logic en;
    logic nt, no, nz;
    parameter delay = 50;

    not #delay n1 (nz, in[0]); // nz is !zero (00)
    not #delay n2 (no, in[1]); // no is !one (01)
    not #delay n3 (nt, in[2]); // nt is !two (02)

    and #delay a1 (out[0], nt, no, nz, en);
    and #delay a2 (out[1], nt, no, in[0], en);
    and #delay a3 (out[2], nt, in[1], nz, en);
    and #delay a4 (out[3], nt, in[1], in[0], en);
    and #delay a5 (out[4], in[2], no, nz, en);
    and #delay a6 (out[5], in[2],no, in[0], en);
    and #delay a7 (out[6], in[2], in[1], nz, en);
    and #delay a8 (out[7], in[2], in[1], in[0], en);
endmodule

// Testbench for the module.
module decoder3_8_testbench();
    logic [7:0] out;
    logic [2:0] in;
    logic en;
    integer i;
     
    decoder3_8 dut(.in, .out, .en);
    
    initial begin
        en = 1;
        for (i = 0; i < 8; i++) begin
            in[2:0] = i; #500;
        end

        en = 0;
        for (i = 0; i < 8; i++) begin
            in[2:0] = i; #500;
        end
    end
endmodule

// Decoder with 2 inputs and 4 outputs.
module decoder2_4(in, out, en);
    output logic [3:0] out;
    input logic [1:0] in;
    input logic en;
    logic no, nz;
    parameter delay = 50;

	 not #delay n1 (nz, in[0]); // nz is !zero
    not #delay n2 (no, in[1]); // no is !one 
    
    and #delay a1 (out[0], no, nz, en);
    and #delay a2 (out[1], no, in[0], en);
    and #delay a3 (out[2], in[1], nz, en);
    and #delay a4 (out[3], in[1], in[0], en);
endmodule

// Testbench for the module.
module decoder2_4_testbench();
    logic [3:0] out;
    logic [1:0] in;
    logic en;
    integer i;
     
    decoder2_4 dut(.in, .out, .en);
    
    initial begin
        en = 1;
        for (i = 0; i < 4; i++) begin
            in[1:0] = i; #200;
        end

        en = 0;
        for (i = 0; i < 4; i++) begin
            in[1:0] = i; #200;
        end
    end
endmodule
