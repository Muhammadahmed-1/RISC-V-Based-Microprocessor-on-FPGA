module B(ABLD,dataB, clock, reset, outB);

    input wire [7:0] dataB;
    input wire ABLD;
    input wire clock;
    input wire reset;
    output reg [7:0] outB;

    always @(posedge clk) begin
        if (ABLD)
            outB <= dataB;
    end

endmodule