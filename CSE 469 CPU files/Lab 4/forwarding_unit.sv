// Arnav Mathur & Anthony Pham
// CSE 469
// 12/1/2022

// This is the forwarding unit that forwards data and flags
module forwarding_unit(address_A, address_B, MEM_RegWrite, MEM_EX_RegWrite, ALU_RegWrite, EX_MEM_Regwrite, 
                        forwarding1, forwarding2, EX_Flags, RF_Instr, forwarding_flags);
								
    input logic [4:0] address_A, address_B, MEM_RegWrite, ALU_RegWrite;
    input logic MEM_EX_RegWrite, EX_MEM_Regwrite;
    input logic [6:0] EX_Flags;
    input logic [7:0] RF_Instr;

    output logic [1:0] forwarding1, forwarding2;
    output logic forwarding_flags;

    // 3:1 mux for forwarding data
    // sel = 00 ---> not forwarding; mux selects register
    // sel = 01 ---> forwarding from alu output
    // sel = 10 ---> forwarding from memory
	 
    always_comb begin
		  // Forwards ALU output to Address_A
        if ((ALU_RegWrite == address_A) && (EX_MEM_Regwrite == 1'b1) && (ALU_RegWrite != 5'd31)) begin
            forwarding1 = 2'b01;
        end
        // Forwards Memory output to Address_A
        else if ((MEM_RegWrite == address_A) && (MEM_EX_RegWrite == 1'b1) && (MEM_RegWrite != 5'd31)) begin
            forwarding1 = 2'b10;
        end else begin
            forwarding1 = 2'b00;
        end
		  // Forwards ALU output to Address_B
        if ((ALU_RegWrite == address_B) && (EX_MEM_Regwrite == 1'b1) && (ALU_RegWrite != 5'd31)) begin
            forwarding2 = 2'b01;
        end
        // Forwards Memory output to Address_B
        else if ((MEM_RegWrite == address_B) && (MEM_EX_RegWrite == 1'b1) && (MEM_RegWrite != 5'd31)) begin
            forwarding2 = 2'b10;
        end else begin
            forwarding2 = 2'b00;
        end
		  // Forwards flags if ADDS/SUBS or CBZ is used
        if (EX_Flags == 7'h75 && (RF_Instr == 8'h54 || RF_Instr == 8'hB4 || RF_Instr == 8'hB5)) begin
            forwarding_flags = 1'b1;
        end else begin
            forwarding_flags = 1'b0;
        end
    end
endmodule
