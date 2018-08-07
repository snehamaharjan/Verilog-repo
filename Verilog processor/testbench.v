`include "Operand_Prep.v"
`include "Data_Cache.v"
`include "ALU.v"
`include "Decoder_Controller.v"
`include "Multiplexer1.v"
`include "Instruction_Memory.v"
`include "PC_unit.v"

module testbench;
//output for PC_unit
wire [31:0] PC;
  
//inputs for Instruction memory - current_PC_output

//outputs for Instruction memory 
wire [31:0] Instruction;

//inputs for Decoder/Controller - Instruction

//outputs for Decoder/Controller
wire Reg2Loc;
wire Uncondbranch;
wire Branch;
wire MemRead;
wire MemtoReg;
wire MemWrite;
wire ALUSrc;
wire RegWrite;
//ALUOp determines the output of ALU control so did not include ALUOp as the final output here
wire [3:0] ALU_control; //output from the ALU control
wire [4:0] Read_register1; //Instruction [9-5] to read register 1
wire [4:0] Instruction_set2; //Instruction [20-16] that becomes Input1 for the MUX at the end of decoder
wire [4:0] Instruction_set3; //Instruction [4-0] that goes to the Write register and becomes Input2 for the MUX at the end of decoder
wire [31:0] Instruction_set4; //Instruction [31-0] which will be manipulated as needed when passing to Sign-extend and ALU control 
//The decoder will tell the hardware what type of instruction, which would then tell how many bits there are to extend

//inputs for Operand Prep (Registers and Immediate) 
reg [4:0] Read_register2; //Output from Mux goes into read register 2
reg [31:0] Write_data;
//Read_register1- Instruction [9-5] to read register 1
//Instruction_set3- Instuction [4-0] to write regsiter
//Instruction_set4- Instruction [31-0] which will be manipulated as needed when passing to Sign-extend and ALU control
//RegWrite

//outputs for Operand Prep (Registers and Immediate)
wire [31:0] Read_data1; //vaule stored in Read_register1
wire [31:0] Read_data2; //value stored in Read_register2
wire [31:0] Sign_extend; //32-bit extended value

//Inputs for ALU
//Read_data1- vaule stored in Read_register1
//ALU_control- output from the ALU control

//Outputs for ALU 
wire [31:0] Mux_output;
wire [31:0] ALU_Result;
wire Zero;

//Input for Data Cache
reg [31:0] addr;//ALU_Result- Address is the ALU result
reg [31:0] inputData; //Read_data2- Write data gets Read_data2
reg writeData;//MemWrite
reg readData;//MemRead

//output for Data Cache
wire [31:0] data; 

//input for Multiplexer1 that selects from 5-bit inputs
reg [4:0] Input1;
reg [4:0] Input2;
reg Select1;

//output for Multiplexer1 that selects from 5-bit inputs
wire [4:0] Decoder_Mux_output;

//input for Multiplexer2 that selects from 32-bit inputs
//reg [31:0] Input3;
//reg [31:0] Input4;
wire Select2;



wire [5*8:0] check; //specific instruction determined in the Decoder unit

reg [31:0] add; // is the PC+4 result in the PC unit and the input1 for Multiplexer2 module
wire [31:0] result; // is the ALU result in PC unit and input2 for Multuiplexer2 module
reg [31:0] offset;

wire Select_x;
wire Check_and_Branch;

reg clock;

//Instantiate an object
PC_unit pc_1(Sign_extend, Branch, Uncondbranch, Zero,PC);
Instruction_Memory instruction_1(PC, Instruction);
Decoder_Controller decoder_1(Instruction,Reg2Loc, Uncondbranch, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite,ALU_control,Read_register1, Instruction_set2, Instruction_set3, Instruction_set4,check,Sign_extend);
Multiplexer1 multiplexer_1(Instruction_set2, Instruction_set3, Reg2Loc, Decoder_Mux_output);
Operand_Prep operand_1(Read_register1, Read_register2, Instruction_set3, Write_data, Instruction_set4, RegWrite, Read_data1, Read_data2);
ALU alu_1(Read_data1, ALU_control, ALUSrc,Sign_extend,ALU_Result,Zero);
Data_Cache cache_1(data, addr, inputData, writeData, readData);     

initial begin
// outputs for PC unit 
    $monitor( "\t address of instruction: %h", PC); 
// outputs for Instruction Memory 
    $monitor( "\t insruction: %b", Instruction); 
// outputs for Decoder Controller 
    $monitor( "\t Reg2Loc: %b", Reg2Loc, " Uncondbranch: %b", Uncondbranch);
    $monitor( "\t Branch: %b", Branch, " MemRead: %b", MemRead,  " MemtoReg: %b", MemtoReg);
    $monitor( "\t MemWrite: %b ", MemWrite, " ALUSrc: %b", ALUSrc, " RegWrite: %b", RegWrite);
    $monitor( "\t Register 1: %d", Read_register1, "Instruction 2: %d",Instruction_set2, "Instruction 3: %d", Instruction_set3);
    $monitor( "\t Instruction 4: %d", Instruction_set4, "Instruction: %s", check, "Immediate: %d", Sign_extend);
// outputs for Multiplexer1 
     $monitor( "\t ALU input: %d", Decoder_Mux_output); 
// outputs for Operand Prep  
     $monitor( "\t read data 1: %d", Read_data1, "\t read data 2: %d", Read_data2); 
// outputs for ALU 
     $monitor( "\t ALU Result: %d", ALU_Result, "Zero: %d", Zero);
// outputs for Data Cache
     $monitor( "\t Read Data: %d", data); 
    
    clock = 0; 

    repeat(100) begin
        #1 $display("hi");
        #1 clock = ~clock;
    end

end

endmodule

