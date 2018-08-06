`include "top.v"
`include "Operand_Prep.v"
`include "Data_Cache.v"
`include "ALU.v"
`include "Decoder_Controller.v"
`include "Multiplexer1.v"
`include "Instruction_Memory.v"
`include "PC_unit.v"


module testbench();


wire [31:0] PC; // input/output PC
wire [31:0] Instruction; //input Instruction_Memory

wire Reg2Loc, Uncondbranch, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite; wire [1:0] ALUOp; //Control bits
wire [4:0] register1, register2, writeRegister; //Registers

reg clock;

//Instantiate an object from the decoder class
decoder_m decoder(register1, register2, writeRegister, immediate, Reg2Loc,
Uncondbranch, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, ALUOp, instruction);

initial begin
        $monitor(
"instruction: %b", instruction, "\tPC: %d", PC);


initial begin 
clock = 0; 
repeat(100) begin 
#1 clock = ~clock;
end
end