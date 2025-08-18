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

    always @(*) begin
        dataA = registers[regA];
        dataB = registers[regB];
    end

    always @(posedge clock or posedge reset) begin
        if (reset) begin
            registers[0] <= 8'b0;
            registers[1] <= 8'b0;
            registers[2] <= 8'b0;
            registers[3] <= 8'b0;
            registers[4] <= 8'b0;
            registers[5] <= 8'b0;
            registers[6] <= 8'b0;
            registers[7] <= 8'b0;
        end else if (RFWrite) begin
            registers[regw] <= dataW;
        end
    end
endmodule
