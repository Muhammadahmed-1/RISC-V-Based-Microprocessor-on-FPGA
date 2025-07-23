module Memory(MemWrite, MemRead, address, clock, reset, data_in, data_out);
    input wire MemWrite;
    input wire MemRead;
    input wire [7:0] address;
    input wire clock;
    input wire [7:0] data_in;
    output reg [7:0] data_out;
    input wire reset;

    reg [7:0] mem [0:255]; // Memory array

        always @(posedge clk) begin
        if (MemWrite)
            mem[address] <= data_in;
        if (MemRead)
            data_out <= mem[address];
    end

endmodule