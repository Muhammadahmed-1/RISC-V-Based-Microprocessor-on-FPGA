module ALUout(
    input wire [7:0] ALUin,
    input wire ALUoutLD,
    input wire clock,
    input wire reset,
    output reg [7:0] ALUout
);
    always @(posedge clock or posedge reset)
     begin
        if (reset)
            ALUout <= 8'b0;
        else if (ALUoutLD)
            ALUout <= ALUin;
    end
endmodule 