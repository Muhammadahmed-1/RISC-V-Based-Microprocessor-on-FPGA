module MDR(data_out, MDRload, clock, reset, MDR);
    input wire [7:0] data_out;
    input wire MDRload;
    input wire clock;
    input wire reset;
    output reg [7:0] MDR;

    always @(posedge clk) begin
        if (MDRload)
            MDR<= data_out;
    end

endmodule