module FSM(clock, reset, RFWrite, MemWrite, MemRead, PCWrite, IRload, MDRload, ABLD, ALUop, ALUA, ALU_B, Addrsel, RASel, RegIn,IR);
    input wire clock;
    input wire reset;
    output reg RFWrite;
    output reg MemWrite;
    output reg MemRead;
    output reg PCWrite;
    output reg IRload;
    output reg MDRload;
    output reg ABLD;
    output reg [2:0] ALUop;
    output reg ALUA;
    output reg [2:0] ALU_B;
    output reg Addrsel;
    output reg RASel;
    output reg RegIn;
    input wire [7:0] IR; // Instruction Register input

 parameter FETCH = 2'b00, DECODE = 2'b01, EXEC = 2'b10, WRITEBACK = 2'b11;
 reg [1:0] state;

 reg [1:0] current_state, next_state;

 always @(posedge clock or posedge reset) 
 begin
    if (reset) begin
        current_state <= FETCH;
    end else begin
        current_state <= next_state;
    end

 end
endmodule