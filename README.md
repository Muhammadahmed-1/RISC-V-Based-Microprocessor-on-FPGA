This project implements a basic 8-bit RISC-style pipelined microprocessor on the DE1-SoC FPGA using Verilog HDL. The processor includes core instruction execution logic, memory access, a register file, and ALU control. The design is modular and extensible, making it suitable for future integration with peripherals such as UART, VGA, and SRAM.

<img width="1440" height="730" alt="image" src="https://github.com/user-attachments/assets/05584f9b-0997-4aa3-a132-e7fcfd59a223" />
- 5-stage pipelined datapath
- ALU with multi-input control and flag generation
- Memory-mapped data and instruction access
- Two-port register file with programmable writeback
- Immediate sign and zero extension units
- Modular design for peripheral interfacing (UART, VGA, etc.)
