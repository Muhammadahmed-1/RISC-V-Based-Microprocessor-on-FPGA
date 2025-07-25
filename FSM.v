module FSM(clock, reset, RFWrite, MemWrite, MemRead, PCWrite, IRload, MDRload, ABLD, ALUoutLD, ALUop, ALUA, ALU_B, Addrsel, RASel, RegIn,IR);
    input wire clock;
    input wire reset;
    output reg RFWrite;
    output reg MemWrite;
    output reg MemRead;
    output reg PCWrite;
    output reg IRload;
    output reg MDRload;
    output reg ABLD;
    output reg ALUoutLD;  // Added ALUoutLD control
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
 always @(*) begin
    case (current_state)
        FETCH:     next_state = DECODE;
        DECODE:    next_state = EXEC;
        EXEC:      next_state = WRITEBACK;
        WRITEBACK: next_state = FETCH;
        default:   next_state = FETCH;
    endcase
end

always @(*) begin

    RFWrite   = 0;
    MemWrite  = 0;
    MemRead   = 0;
    PCWrite   = 0;
    IRload    = 0;
    MDRload   = 0;
    ABLD      = 0;
    ALUoutLD  = 0;  
    ALUop     = 3'b000;
    ALUA      = 0;
    ALU_B     = 3'b000;
    Addrsel   = 0;
    RASel     = 0;  // Will be set based on instruction
    RegIn     = 0;

    case (current_state)
        FETCH: begin
            MemRead = 1;      // Read instruction from memory
            Addrsel = 0;      // Use PC as address
            IRload  = 1;      // Load instruction into IR
            PCWrite = 1;      // Increment PC
        end

        DECODE: begin
            ABLD = 1;         // Load dataA and dataB into A and B registers
            RASel = 0;        // Use IR[6:7] for regA (adjust as needed)
        end

        EXEC: begin
            case (IR[7:6])  // Simple 2-bit opcode decode
                2'b00: begin // ADD
                    ALUA   = 1;      // Use register A
                    ALU_B  = 3'b000; // Use register B
                    ALUop  = 3'b000; // ADD operation
                    ALUoutLD = 1;    // Load ALU result into ALUout register
                end
                2'b01: begin // SUB
                    ALUA   = 1;      // Use register A
                    ALU_B  = 3'b000; // Use register B
                    ALUop  = 3'b001; // SUB operation
                    ALUoutLD = 1;    // Load ALU result into ALUout register
                end
                2'b10: begin // LOAD
                    Addrsel = 1;     // Use ALUout as address
                    MemRead = 1;     // Read from memory
                    MDRload = 1;     // Load memory data into MDR
                end
                2'b11: begin // STORE
                    Addrsel = 1;     // Use ALUout as address
                    MemWrite = 1;    // Write to memory
                end
            endcase
        end

        WRITEBACK: begin
            if (IR[7:6] == 2'b00 || IR[7:6] == 2'b01) begin
                RegIn   = 0;     // Select ALU result for register write
                RFWrite = 1;     // Write to register file
            end else if (IR[7:6] == 2'b10) begin
                RegIn   = 1;     // Select MDR for register write
                RFWrite = 1;     // Write to register file
            end
        end
    endcase
end
// State transition logic
always @(posedge clock or posedge reset) begin
    if (reset) begin
        current_state <= FETCH; // Reset to initial state
    end else begin
        current_state <= next_state; // Transition to next state
    end

end
endmodule