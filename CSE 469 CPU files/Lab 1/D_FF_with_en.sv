// Arnav Mathur
// EE 469
// 10/12/2022

`timescale 1ns/10ps

// Flip-flip module with enable signal integrated.
module D_FF_with_en (clk, q, d, enable);
    input logic clk, enable, d;
    output logic q;
    logic out;

    mux2_1 sel (.out(out), .in({d,q}), .sel(enable));

    D_FF onebit (.q(q), .d(out), .reset(1'b0), .clk(clk));
endmodule

// Testbench for the module.
module D_FF_with_en_testbench();
    logic q, d, enable, clk;

    D_FF_with_en dut(.clk, .q, .d, .enable);

    parameter CLOCK_PERIOD = 400;
    initial begin
        clk <= 0;
        forever #(CLOCK_PERIOD/2) clk <= ~clk;
    end

    initial begin
        @(posedge clk); d <= 0; enable <= 0;
        @(posedge clk); d <= 0;
        @(posedge clk); d <= 1;
        @(posedge clk); d <= 1; enable <= 1;
        @(posedge clk); d <= 0;
        @(posedge clk); d <= 1;
        @(posedge clk); d <= 0; enable <= 0;
        @(posedge clk); 
        @(posedge clk); enable <= 1;
        @(posedge clk); d <= 1; enable <= 0;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        $stop;
    end
endmodule
