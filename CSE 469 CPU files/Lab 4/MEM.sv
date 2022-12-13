// Arnav Mathur & Anthony Pham
// CSE 469
// 12/1/2022

// This module is the memory stage where memory is initialized.
module MEM (clk, reset, MemWrite, DataMem_in, MemAddress, WriteBack, MemRead, MemToReg);
    input logic clk, reset, MemWrite, MemRead, MemToReg;
    input logic [63:0] DataMem_in, MemAddress;

    output logic [63:0] WriteBack;
    
    logic [63:0] Memory_Output;
		
	 // Initialize memory
    datamem mem(.address(MemAddress), .write_enable(MemWrite), .read_enable(MemRead),
				 .write_data(DataMem_in), .clk, .xfer_size(4'd8), .read_data(Memory_Output));
	
	 // MemToReg Mux
    dataSel2_1 writeSel (.s0(MemToReg), .A(MemAddress), .B(Memory_Output), .OUT(WriteBack));

endmodule
