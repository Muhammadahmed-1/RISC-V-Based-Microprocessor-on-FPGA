module addrsel_mux (Addrsel,PC,OpB,M1); //2 to 1 mux
    input  wire Addrsel;
    input  wire [7:0]  PC;     
    input  wire [7:0]  OpB;    
    output wire [7:0]  M1;       

    assign M1 = (Addrsel) ? OpB : PC;
endmodule

module RASel_mux (RASel,IR6_7,M2);
       input wire RASel;
       input wire [1:0] IR6_7;
       output wire [1:0] M2;

       assign M2 = (RASel) ? 2'b01  : IR6_7;
endmodule       

module RegIn_mux (RegIn,MDR,ALUout,M3);
       input wire RegIn;
       input wire  [7:0]  MDR;
       input wire  [7:0] ALUout;
       output wire [7:0] M3;

       assign M3 = (RegIn) ? MDR : ALUout;

endmodule

module ALU_A_mux(ALUA,PC,OpB,M4);
       input wire ALUA;
       input wire [7:0] OpA;
       input wire [7:0] PC;
       output wire [7:0] M4;

        assign M4 = (ALUA) ? OpA : PC;
endmodule       
// 5 to 1 mux    
module  ALU_B_mux(ALU_B,OpB,Imm4, Imm5,Imm3,M5);
        input  wire [2:0]  ALU_B;
        input  wire [7:0]  OpB;
        input  wire [7:0]  Imm4;
        input  wire [7:0]  Imm5;
        input  wire [7:0]  Imm3;
        output reg [7:0]  M5;

        always @(*) begin
        case (ALU_B)
            3'b000: M5 = OpB;
            3'b001: M5 = 8'b01;
            3'b010: M5 = Imm4;
            3'b011: M5 = Imm5;
            3'b100: M5 = Imm2; 
            default: M5 = 8'bxxxxxxxx;
        endcase
    end
endmodule
         