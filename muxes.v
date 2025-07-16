module addrsel_mux (addrsel,PC,OpB,M1); //2 to 1 mux
    input  wire addrsel;
    input  wire [7:0]  PC;     
    input  wire [7:0]  OpB;    
    output wire [7:0]  M1;       

    assign M1 = (addrsel) ? OpB : PC;
endmodule

module OpASel_mux (OpASel,IR6_7,M2);
       input wire OpASel;
       input wire [1:0] IR6_7;
       output wire [1:0] M2;

       assign M2 = (OpASel) ? 2'b01  : IR6_7;
endmodule       

module RegIn_mux (RegIn,MDR,ALUout,M3);
       input wire RegIn;
       input wire  [7:0]  MDR;
       input wire  [7:0] ALUout;
       output wire [7:0] M3;

       assign M3 = (RegIn) ? MDR : ALUout;

endmodule

module ALU1_mux(ALU1,PC,OpB,M4);
       input wire ALU1;
       input wire [7:0] OpA;
       input wire [7:0] PC;
       output wire [7:0] M4;

        assign M4 = (ALU1) ? OpA : PC;
endmodule       
// 5 to 1 mux    
module  ALU2_mux(ALU2,OpB,Imm4, Imm5,Imm3,M5);
        input  wire [2:0]  ALU2;
        input  wire [7:0]  OpB;
        input  wire [7:0]  Imm4;
        input  wire [7:0]  Imm5;
        input  wire [7:0]  Imm3;
        output reg [7:0]  M5;

        always @(*) begin
        case (ALU2)
            3'b000: M5 = OpB;
            3'b001: M5 = 7'b01;
            3'b010: M5 = Imm4;
            3'b011: M5 = Imm5;
            3'b100: M5 = Imm3; 
            default: M5 = 8'bxxxxxxxx;
        endcase
    end
endmodule
         