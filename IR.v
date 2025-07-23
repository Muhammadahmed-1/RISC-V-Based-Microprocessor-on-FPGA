module IR(IRload,clock,reset,PC,IR);
    input wire IRload;
    input wire clock;
    input wire reset;
    input wire [7:0] data_in;
    output reg [7:0] IR;

    always @(posedge clock or posedge reset)
     begin
        if (reset) 
        begin
            IR <= 8'b0;
        end else if (IRload)
         begin
            IR <= data_in; 
        end
    end 
endmodule    