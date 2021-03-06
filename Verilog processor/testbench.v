`timescale 1ns/1ps
//`include "top.v"
 `include "Operand_Prep.v"
 `include "Data_Cache.v"
 `include "ALU.v"
 `include "Decoder_Controller.v"
 `include "Multiplexer1.v"
 `include "Instruction_Memory.v"
`include "PC_unit.v" 

module testbench();

// input/output PC
wire [31:0] PC; 
//input Instruction_Memory
wire [31:0] Instruction; 
//outputs for Decoder/Controller
wire Reg2Loc;
wire Uncondbranch;
wire Branch;
wire MemRead;
wire MemtoReg;
wire MemWrite;
wire ALUSrc;
wire RegWrite;
//outputs from Instruction memory
wire [3:0] ALU_control; //output from the ALU control
wire [4:0] Read_register1; //Instruction [9-5] to read register 1
wire [4:0] Instruction_set2; //Instruction [20-16] that becomes Input1 for the MUX at the end of decoder
wire [4:0] Instruction_set3; //Instruction [4-0] that goes to the Write register and becomes Input2 for the MUX at the end of decoder
wire [31:0] Instruction_set4; //Instruction [31-0] which will be manipulated as needed when passing to Sign-extend and ALU control 
//inputs for Operand Prep (Registers and Immediate) 
wire [4:0] Read_register2; //Output from Mux goes into read register 2
wire [31:0] Write_data;
//outputs for Operand Prep (Registers and Immediate)
wire [31:0] Read_data1; //vaule stored in Read_register1
wire [31:0] Read_data2; //value stored in Read_register2
wire [31:0] Sign_extend; //32-bit extended value

wire [4:0] Decoder_Mux_output; //MUX output to Read register 2 in Multiplexer1.v

//Outputs for ALU 
wire [31:0] ALU_Result;
wire Zero;

//Input for Data Cache
reg [31:0] addr;//ALU_Result- Address is the ALU result
reg [31:0] inputData; //Read_data2- Write data gets Read_data2
reg writeData;//MemWrite
reg readData;//MemRead
//output for Data Cache
wire [31:0] data; 


wire [5*8:0] check; //specific instruction determined in the Decoder unit
reg [31:0] add; // is the PC+4 result in the PC unit and the input1 for Multiplexer2 module
wire [31:0] result; // is the ALU result in PC unit and input2 for Multuiplexer2 module
reg [31:0] offset;
wire Select_x;
wire Check_and_Branch;

reg clock;

wire [5*8:0]cache_check;


//Instantiate an object
 PC_unit pc_1(Sign_extend, Branch, Uncondbranch, Zero, clock, PC);
 Instruction_Memory instruction_1(PC, Instruction);
 Decoder_Controller decoder_1(Instruction,Reg2Loc, Uncondbranch, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite,ALU_control,Read_register1, Instruction_set2, Instruction_set3, Instruction_set4,check,Sign_extend);
 Multiplexer1 multiplexer_1(Instruction_set2, Instruction_set3, Reg2Loc, Decoder_Mux_output);
 Operand_Prep operand_1(Read_register1, Decoder_Mux_output, Instruction_set3, Instruction_set4, RegWrite, MemtoReg, data,ALU_Result,Read_data1, Read_data2,Write_data);
 ALU alu_1(Read_data1, Read_data2, ALU_control, ALUSrc,Sign_extend,ALU_Result,Zero);
 Data_Cache cache_1(data, addr, inputData, writeData, readData, cache_check);     

initial begin
// outputs for PC unit 
    $monitor( "\t address of instruction: %h", PC, "\t insruction: %b", Instruction, "\t Reg2Loc: %b", Reg2Loc, "\t Uncondbranch: %b", Uncondbranch, 
    "\t Branch: %b", Branch, "\t MemRead: %b", MemRead,  "\t MemtoReg: %b", MemtoReg, 
    "\t MemWrite: %b ", MemWrite, "\t ALUSrc: %b", ALUSrc, "\t RegWrite: %b", RegWrite, "\t Instruction name : %s", check, "\t Register 1: %d", Read_register1, "\t Instruction 2: %d",Instruction_set2,
    "\t Instruction 3: %d", Instruction_set3,  "\t Instruction 4: %d", Instruction_set4, "\t Decoder mux output: %d", Decoder_Mux_output ,
    "\t\t\t\t\t\t Immediate: %b", Sign_extend, "\t read data 1: %d", Read_data1, "\t read data 2: %d",  Read_data2, 
    "\t ALU Result: %d", ALU_Result, "\t Zero: %d", Zero, 
    "\t Read Data: %d", data, "\t MEMORY check: %s", cache_check, "\t Write back: %d", Write_data ); 

end

initial begin 
clock = 0; 
    repeat(20)
    begin 
    #1 clock = ~clock;
    end
end

endmodule
