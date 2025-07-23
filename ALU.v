module ALU(A,B,ALUop,ALUout,Z,N);
        input wire [7:0] A, B;
        input wire [2:0] ALUop;
        output reg [7:0] ALUout;
        output reg Z, N;

        always @(*) begin
            case (ALUop)
                3'b000: ALUout = A + B; // ADD
                3'b001: ALUout = A - B; // SUB
                3'b010: ALUout = A & B; // AND
                3'b011: ALUout = A | B; // OR
                3'b100: ALUout = A ^ B; // XOR
                default: ALUout = 8'b0; 
            endcase
            
            Z = (ALUout == 8'b0); //  check forr zero
            N = ALUout[7]; // Sign bit for negative check MSB=sign (-ve sign)
        end 

endmodule         