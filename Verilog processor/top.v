module top;

//input for PC_unit
reg check_pc; 
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
reg [31:0] Decoder_Mux_output; //MUX chooses sign extended value or Read_data2

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

//input for Multiplexer1 that selects from 5-bit inputs
reg [4:0] Input1;
reg [4:0] Input2;
reg Select1;

//output for Multiplexer1 that selects from 5-bit inputs
wire [4:0] Mux_output1;

//input for Multiplexer2 that selects from 32-bit inputs
//reg [31:0] Input3;
//reg [31:0] Input4;
wire Select2;

//output for Multiplexer2 that selects from 32-bit inputs
wire [31:0] Mux_output2;

wire [5*8:0] check; //specific instruction determined in the Decoder unit

reg [31:0] add; // is the PC+4 result in the PC unit and the input1 for Multiplexer2 module
wire [31:0] result; // is the ALU result in PC unit and input2 for Multuiplexer2 module
reg [31:0] offset;

wire Select_x;
wire Check_and_Branch;

endmodule //ending top module












