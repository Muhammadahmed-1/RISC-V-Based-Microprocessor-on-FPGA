module top(clock,reset);
    input wire clock,
    input wire reset

// Control signals from FSM
wire RFWrite, MemWrite, MemRead, PCWrite, IRload, MDRload, ABLD, ALUoutLD;
wire [2:0] ALUop;
wire ALUA, Addrsel, RASel, RegIn;
wire [2:0] ALU_B;

// Datapath signals
wire [7:0] PC, ALUout, mem_data_out, reg_dataA, reg_dataB;
wire [7:0] A_out, B_out, MDR_out, IR_out, ALUout_reg;
wire [7:0] M1, M3, M4, M5; // mux outputs
wire Z, N;

// Immediate extension logic
wire [7:0] Imm4, Imm5, Imm3;
// Sign-extend 4 bits (IR_out[3:0]) to 8 bits
assign Imm4 = { {4{IR_out[3]}}, IR_out[3:0] };
// Zero-extend 5 bits (IR_out[4:0]) to 8 bits  
assign Imm5 = { 3'b000, IR_out[4:0] };
// Zero-extend 3 bits (IR_out[2:0]) to 8 bits
assign Imm3 = { 5'b00000, IR_out[2:0] };

// FSM instantiation
FSM fsm_inst(
    .clock(clock),
    .reset(reset),
    .RFWrite(RFWrite),
    .MemWrite(MemWrite),
    .MemRead(MemRead),
    .PCWrite(PCWrite),
    .IRload(IRload),
    .MDRload(MDRload),
    .ABLD(ABLD),
    .ALUoutLD(ALUoutLD),
    .ALUop(ALUop),
    .ALUA(ALUA),
    .ALU_B(ALU_B),
    .Addrsel(Addrsel),
    .RASel(RASel),
    .RegIn(RegIn),
    .IR(IR_out)
);

// Register File
RF rf_inst(
    .RFWrite(RFWrite),
    .regA(RASel ? IR_out[5:4] : IR_out[6:7]), // RASel controls regA source
    .regB(IR_out[5:4]),
    .regw(IR_out[10:8]),
    .clock(clock),
    .reset(reset),
    .dataA(reg_dataA),
    .dataB(reg_dataB),
    .dataW(M3)
);

// Register A
A a_inst(
    .dataA(reg_dataA),
    .ABLD(ABLD),
    .clock(clock),
    .outA(A_out)
);

// Register B
B b_inst(
    .ABLD(ABLD),
    .dataB(reg_dataB),
    .clock(clock),
    .reset(reset),
    .outB(B_out)
);

// MDR
MDR mdr_inst(
    .data_out(mem_data_out),
    .MDRload(MDRload),
    .clock(clock),
    .reset(reset),
    .MDR(MDR_out)
);

// IR
IR ir_inst(
    .IRload(IRload),
    .clock(clock),
    .reset(reset),
    .data_in(mem_data_out),
    .IR(IR_out)
);

// ALU
ALU alu_inst(
    .A(M4), // ALU A input from mux
    .B(M5), // ALU B input from mux
    .ALUop(ALUop),
    .ALUout(ALUout),
    .Z(Z),
    .N(N)
);

// ALUout register
ALUout aluout_inst(
    .ALUin(ALUout),
    .ALUoutLD(ALUoutLD),
    .clock(clock),
    .reset(reset),
    .ALUout(ALUout_reg)
);

// PC
PC pc_inst(
    .PCWrite(PCWrite),
    .ALUout(ALUout_reg), // Use ALUout register output
    .PC(PC),
    .clock(clock),
    .reset(reset)
);

// Memory
Memory memory_inst(
    .MemWrite(MemWrite),
    .MemRead(MemRead),
    .address(M1),
    .clock(clock),
    .reset(reset),
    .data_in(B_out),
    .data_out(mem_data_out)
);

// Muxes with FSM control signals
// Address select mux: M1 = (addrsel) ? ALUout_reg : PC
addrsel_mux addr_mux_inst(
    .addrsel(Addrsel),
    .PC(PC),
    .OpB(ALUout_reg),
    .M1(M1)
);

// RegIn mux: M3 = (RegIn) ? MDR : ALUout_reg
RegIn_mux regin_mux_inst(
    .RegIn(RegIn),
    .MDR(MDR_out),
    .ALUout(ALUout_reg),
    .M3(M3)
);

// ALU1 mux: M4 = (ALUA) ? A_out : PC
ALU1_mux alu1_mux_inst(
    .ALU1(ALUA),
    .OpA(A_out),
    .PC(PC),
    .M4(M4)
);

// ALU2 mux: M5 = ALU_B selects from B_out, constants, or immediates
ALU2_mux alu2_mux_inst(
    .ALU2(ALU_B),
    .OpB(B_out),
    .Imm4(Imm4),
    .Imm5(Imm5),
    .Imm3(Imm3),
    .M5(M5)
);

endmodule

