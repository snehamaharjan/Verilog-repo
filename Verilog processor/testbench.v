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

//Instantiate an object
pc_m PC_unit(Sign_extend, Branch, Uncondbranch, Zero,PC);
instruction_m Instruction_Memory(PC, Instruction);
operand_m Operand_Prep(Read_register1, Read_register2, Instruction_set3, Write_data, Instruction_set4, RegWrite,Read_data1, Read_data2);
decoder_m Decoder_Controller(Instruction,Reg2Loc, Uncondbranch, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite,ALU_control,Read_register1, Instruction_set2, Instruction_set3, Instruction_set4,check,Sign_extend);
multiplexer1_m Multiplexer1(Instruction_set2, Instruction_set3, Reg2Loc, Decoder_Mux_output);
alu_m ALU(Read_data1, ALU_control, ALUSrc,Sign_extend,ALU_Result,Zero);
datacache_m Data_Cache(data, addr, Data,writeData,readData);
     


initial begin
        $monitor("instruction: %b", instruction, "\tPC: %d", PC);


initial begin 
clock = 0; 
repeat(100) begin 
#1 clock = ~clock;
end
end
