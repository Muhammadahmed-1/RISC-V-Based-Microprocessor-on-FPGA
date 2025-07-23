module RF(RFWrite,regA,regB,regw,clock,reset,dataA,dataB,dataW);

    input wire RFWrite;
    input wire [2:0] regA;
    input wire [2:0] regB;
    input wire [2:0] regw;
    input wire clock;
    input wire reset;
    input wire [7:0] dataW;
    output reg [7:0] dataA;
    output reg [7:0] dataB;

    reg [7:0] registers [0:7]; // 8 registers of 8 bits each

    assign dataA = registers[regA];
    assign dataB = registers[regB];

    always @(posedge clk) begin
        if (RFWrite)
            registers[regW] <= dataW;
    end
endmodule
