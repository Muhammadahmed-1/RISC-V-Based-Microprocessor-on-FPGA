module PC(PCWrite,ALUout,PC,clock,reset);
    input wire PCWrite;
    input wire [7:0] ALUout;
    input wire clock;
    input wire reset;
    output reg [7:0] PC;

    always @(posedge clock or posedge reset)
     begin
        if (reset) 
        begin
            PC <= 8'b0;
        end else if (PCWrite)
         begin
            PC <= ALUout; 
        end
    end

endmodule