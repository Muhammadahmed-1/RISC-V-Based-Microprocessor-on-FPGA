module A(dataA, ABLD,clock,outA);

    input wire [7:0] dataA;
    input wire ABLD;
    input wire clock;
    output reg [7:0] outA;

    always @(posedge clock)
     begin
        if (ABLD)
         begin
            outA <= dataA; 
        end
    end
endmodule    