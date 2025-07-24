module top(
    input wire clock,
    input wire reset
);
// Control signals (placeholders, to be connected to FSM when implemented)
wire RFWrite, MemWrite, MemRead, PCWrite, IRload, MDRload, ABLD;
wire [2:0] ALUop;

// Datapath signals
wire [7:0] PC, ALUout, mem_data_out, reg_dataA, reg_dataB;
wire [7:0] A_out, B_out, MDR_out, IR_out;
wire [7:0] M1, M3, M4, M5; // mux outputs
wire Z, N;
wire [7:0] ALUout_reg; // Output of ALUout register
wire ALUoutLD; // Placeholder for ALUout register load control

// Immediate extension logic (stubs)
wire [7:0] Imm4, Imm5, Imm3;
// Example: assign Imm4 = { {4{IR_out[3]}}, IR_out[3:0] }; // sign-extend 4 bits
// assign Imm5 = { 3'b000, IR_out[4:0] }; // zero-extend 5 bits
// assign Imm3 = { 5'b00000, IR_out[2:0] }; // zero-extend 3 bits
assign Imm4 = 8'b0; // TODO: implement SE/ZE logic
assign Imm5 = 8'b0; // TODO: implement SE/ZE logic
assign Imm2 = 8'b0; // TODO: implement SE/ZE logic

// Sign-extend 4 bits (IR_out[3:0]) to 8 bits
assign Imm4 = { {4{IR_out[3]}}, IR_out[3:0] };

// Zero-extend 5 bits (IR_out[4:0]) to 8 bits
assign Imm5 = { 3'b000, IR_out[4:0] };

// Zero-extend 3 bits (IR_out[2:0]) to 8 bits
assign Imm3 = { 5'b00000, IR_out[2:0] };
// Register File
RF rf_inst(
    .RFWrite(RFWrite),
    .regA(IR_out[4:2]),
    .regB(IR_out[7:5]),
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
    .A(A_out),
    .B(M5),
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
    .ALUout(M4),
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

// Muxes (example connections, adjust as needed for your control logic)
// Address select mux: M1 = (addrsel) ? OpB : PC
addrsel_mux addr_mux_inst(
    .addrsel(1'b0), // placeholder, connect to control
    .PC(PC),
    .OpB(B_out),
    .M1(M1)
);
// RegIn mux: M3 = (RegIn) ? MDR : ALUout
RegIn_mux regin_mux_inst(
    .RegIn(1'b0), // placeholder, connect to control
    .MDR(MDR_out),
    .ALUout(ALUout),
    .M3(M3)
);
// ALU1 mux: M4 = (ALU1) ? OpA : PC
ALU1_mux alu1_mux_inst(
    .ALU1(1'b0), // placeholder, connect to control
    .OpA(A_out),
    .PC(PC),
    .M4(M4)
);
// ALU2 mux: M5 = ...
ALU2_mux alu2_mux_inst(
    .ALU2(3'b000), // placeholder, connect to control
    .OpB(B_out),
    .Imm4(Imm4),
    .Imm5(Imm5),
    .Imm3(Imm3),
    .M5(M5)
);

// FSM (not implemented, placeholder)
// FSM fsm_inst(...); // TODO: implement FSM and connect all control signals

endmodule

