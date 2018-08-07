
`timescale 1ns/1ns

module top();

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


module Operand_Prep(input[4:0] Read_register1, Read_register2, Instruction_set3, input[31:0] Write_data, Instruction_set4, input RegWrite, output reg[31:0] Read_data1, Read_data2);

reg [31:0] Register_array [0:31]; 
reg [4:0] i;
initial begin 
for (i=0; i<32; i = i+1) begin
Register_array[i] <= 0;
end
end

  /*Register_array[20] <= 0; 
  Register_array[25] <= 15;
  Register_array[3] <= 3; */
  
always @(*) begin

Read_data1 <= Register_array[Read_register1];
Read_data2 <= Register_array[Read_register2];

end

endmodule 

module Data_Cache( 
output reg [31:0]data,  // Read data
input [31:0]addr,    //ALU_Result 
input [31:0]inputData,  //Write data or Read_data2
input writeData,   //MemWrite     
input readData     //MemRead
);

reg [28:0]setAddress[0:15]; //16 lines
reg [31:0]setData[0:15];

reg [6:0]i;
wire [28:0]blockAddress = addr[31:3]; //tag and index

always@(blockAddress, inputData, writeData, readData) begin : search

	for(i = 0; i < 16; i = i + 1) begin //how many lines there are
		if(blockAddress == setAddress[i]) begin

			if(readData) begin
				data <= setData[i];
			end //if

			else if(writeData) begin

				setData[i] <= inputData;
				data <= setData[i];

			end //else
					
			disable search;

		end //if PC==

		else begin //if miss

			setData[i] <= inputData;
				data <= setData[i];
		end

	end //for
end // always

initial begin
	setAddress[0] <= 29'h00000005; setData[0] <= 32'h00000005; 
	setAddress[1] <= 29'h00000007; setData[1] <= 32'h02020202;
	setAddress[2] <= 29'h00000009; setData[2] <= 32'h03030303;
	setAddress[3] <= 29'h0000000B; setData[3] <= 32'h04040404;
	setAddress[4] <= 29'h0000000D; setData[4] <= 32'h05050505;
	setAddress[5] <= 29'h0000000F; setData[5] <= 32'h06060606;
	setAddress[6] <= 29'h00000201; setData[6] <= 32'h00000000;
	setAddress[7] <= 29'h00000210; setData[7] <= 32'h08080808;
	setAddress[8] <= 29'h00000201; setData[8] <= 32'h99999999;
	setAddress[9] <= 29'h00000203; setData[9] <= 32'hAAAAAAAA;
	setAddress[10] <= 29'h00000205; setData[10] <= 32'hBBBBBBBB;
	setAddress[11] <= 29'h00000207; setData[11] <= 32'hCCCCCCCC;
	setAddress[12] <= 29'h00000209; setData[12] <= 32'hDDDDDDDD;
	setAddress[13] <= 29'h0000020B; setData[13] <= 32'hEEEEEEEE;
	setAddress[14] <= 29'h0000020D; setData[14] <= 32'hFFFFFFFF;
	setAddress[15] <= 29'h0000020F; setData[15] <= 32'h01234567;
end

endmodule //fullAssoociative

module ALU(input[31:0] Read_data1, input [3:0] ALU_control, input ALUSrc, input [31:0] Sign_extend, output reg[31:0] ALU_Result, output reg Zero); 

reg [31:0] Mux_output;
  
always @(*)
begin

if (ALUSrc == 0) begin
Mux_output <= Read_data1;
end

else begin
Mux_output <= Sign_extend;
end

case(ALU_control)

4'b0010: // common procedure for ADD, LDUR, STUR
begin
ALU_Result <= Read_data1 + Mux_output;
Zero <= 1'b0;
end
4'b1010: //SUB
begin
ALU_Result <= Read_data1 - Mux_output;
Zero <= 1'b0;
end
4'b0110: //AND
begin
ALU_Result <= Read_data1 & Mux_output;
Zero <= 1'b0;
end
4'b0100: //ORR- inclusive OR
begin
ALU_Result <= Read_data1 | Mux_output;
Zero <= 1'b0;
end
4'b1001: //EOR- exclusive OR
begin
ALU_Result <= Read_data1 ^ Mux_output;
Zero <= 1'b0;
end
4'b0101: //NOR
begin
ALU_Result <= ~(Read_data1 | Mux_output);
Zero <= 1'b0;
end
4'b1100: //NAND
begin
ALU_Result <= ~(Read_data1 & Mux_output);
Zero <= 1'b0;
end
4'b1101: //MOV
begin
ALU_Result <= Mux_output;
Zero <= 1'b0;
end
4'b0111: //CBZ- Compare and branch on zero
  if (Mux_output == 32'b0) 
begin
Zero <= 1'b1;
ALU_Result <= 32'b0;
end

else 
begin
Zero <= 1'b0;
ALU_Result <= 32'b0;
end

4'b0001: //CBNZ- Compare and branch IF not zero
  if (Mux_output != 32'b0) 
begin
Zero <= 1'b1;
ALU_Result <= 32'b0;
end

else 
begin
Zero <= 1'b0;
ALU_Result <= 32'b0;
end

default: 
begin
ALU_Result <= 32'b0;
Zero <= 1'b0;
end
endcase 
end

endmodule // ending ALU module

module Decoder_Controller(input[31:0] Instruction, output reg Reg2Loc, Uncondbranch, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, output reg[3:0] ALU_control, output reg[4:0] Read_register1, Instruction_set2, Instruction_set3, output reg [31:0] Instruction_set4, output reg[5*8:0] check, output reg [31:0] Sign_extend);

reg [1:0] ALUOp; //2 bit ALUop

always @(*) begin
if(Instruction[30:26] == 5'b00101) begin
	
	Reg2Loc <= 1'bX;
	MemRead <= 1'b0;
	MemtoReg <= 1'bX;
	MemWrite <= 1'b0;
	ALUSrc <= 1'bX;
	RegWrite <= 1'b0;
	ALUOp <= 2'bXX;	// ALUOp = XX for B and BL because no need of 
	Uncondbranch <= 1'b1;
	Branch <= 1'b0;

	if(Instruction[31] == 1'b0)begin
	//Branch 
	check <= "B";
	end

	else begin
	//BL 	
	check <= "BL";
	end

	Instruction_set4 <= Instruction[25:0]; //B-type address is 26 bits long
    Sign_extend[31:0] <= (Instruction[25] == 1) ? {{6{Instruction[25]}}, Instruction[25:0]} : Instruction [25:0];

end

else if(Instruction[29:26] == 4'b1101) begin

	//both CBZ and CBNZ conrols are the same so not double checking
	Reg2Loc <= 1'b1;
	Uncondbranch <= 1'b0;
	Branch <= 1'b1;
	MemRead <= 1'b0;
	MemtoReg <= 1'bX;
	ALUOp <= 2'b01; //ALUOp = 01 for CBZ and CBNZ
	MemWrite <= 1'b0;
	ALUSrc <= 1'b0;
	RegWrite <= 1'b0;

	if(Instruction[24] == 1'b0)begin
	//CBZ
	check <= "CBZ";
	end

	else begin
	//CBNZ 
	check <= "CBNZ";
	end

	Instruction_set4 <= Instruction[23:5]; //CB-type address is 19 bits long
    Sign_extend[31:0] <= (Instruction[23] == 1) ? {{13{Instruction[23]}}, Instruction[23:5]} : Instruction [23:5];
end

else if(Instruction[29:25] == 5'b01000) begin

	//ADDI controls and SUBI controls merged because they are both I-types
	Reg2Loc <= 1'bX;
	Uncondbranch <= 1'b0;
	Branch <= 1'b0;
	MemRead <= 1'b0;
	MemtoReg <= 1'b0;
	ALUOp <= 2'b10; //ALUOp = 10 for I-type
	MemWrite <= 1'b0;
	ALUSrc <= 1'b1;
	RegWrite <= 1'b1;

	if(Instruction[30] == 1'b0)begin
	//ADDI 
	check <= "ADDI";
	end

	else begin
	//SUBI
	check <= "SUBI";
	end

	Instruction_set4 <= Instruction[21:10]; //I-type immediate is 12 bits
    Sign_extend[31:0] <= (Instruction[21] == 1) ? {{20{Instruction[21]}}, Instruction[21:10]} : Instruction [21:10];
end

else if(Instruction[28:25] == 4'b1001) begin

	//ANDI, MOV, EORI controls
	Reg2Loc <= 1'bX;
	Uncondbranch <= 1'b0;
	Branch <= 1'b0;
	MemRead <= 1'b0;
	MemtoReg <= 1'b0;
	ALUOp <= 2'b10; //ALUOp = 10 for I-type
	MemWrite <= 1'b0;
	ALUSrc <= 1'b1;
	RegWrite <= 1'b1;
	
	if(Instruction[30:29] == 2'b00)begin
	//ANDI 
	check <= "ANDI";
	Instruction_set4 <= Instruction[21:10]; //I-type immediate is 12 bits
    Sign_extend[31:0] <= (Instruction[21] == 1) ? {{20{Instruction[21]}}, Instruction[21:10]} : Instruction [21:10];
	end

	else if(Instruction[29] == 1'b1)begin
	//ORRI
	check <= "ORRI";
	Instruction_set4 <= Instruction[21:10]; //I-type immediate is 12 bits
    Sign_extend[31:0] <= (Instruction[21] == 1) ? {{20{Instruction[21]}}, Instruction[21:10]} : Instruction [21:10];
	end

	else if (Instruction[23] == 1'b1) begin
	//MOVZ -- The MOV instruction copies the value of Operand2 into Rd. (assuming Operand2 is an immediate)
	check <= "MOV";
	Instruction_set4 <= Instruction[22:5]; //immediate is 18 bits for MOV
    Sign_extend[31:0] <= (Instruction[22] == 1) ? {{14{Instruction[22]}}, Instruction[22:5]} : Instruction [22:5];
	end 

	else begin
	//EORI 
	check <= "EORI";
	Instruction_set4 <= Instruction[21:10]; //I-type immediate is 12 bits
    Sign_extend[31:0] <= (Instruction[21] == 1) ? {{20{Instruction[21]}}, Instruction[21:10]} : Instruction [21:10];
	end 

end

else if(Instruction[27:25] == 3'b101) begin

	//AND, ADD, ORR, SUB, EOR controls
	Reg2Loc <= 1'b0;
	Uncondbranch <= 1'b0;
	Branch <= 1'b0;
	MemRead <= 1'b0;
	MemtoReg <= 1'b0;
	ALUOp <= 2'b10; //ALUOp = 10 for R-type
	MemWrite <= 1'b0;
	ALUSrc <= 1'b0;
	RegWrite <= 1'b1;
	
	if(Instruction[29] == 1'b0 && Instruction[24] == 1'b0)begin
	//AND controls
	check <= "AND";
	end

	else if (Instruction[30] == 1'b0 && Instruction[24] == 1'b1) begin
	//ADD controls
	check <= "ADD";
	end

	else if (Instruction[30:29] == 2'b01) begin
	//ORR controls
	check <= "ORR";
	end

	else if (Instruction[30] == 1'b1 && Instruction[24] == 1'b1) begin
	//SUB controls
	check <= "SUB";
	end

	else begin
	//EOR controls
	check <= "EOR";
	end

	//Instruction_set4 not needed for R-types

end 

else if(Instruction[31:29] == 3'b111) begin

	if(Instruction[22] == 1'b0)begin
	//STUR controls
	Reg2Loc <= 1'b1;
	Uncondbranch <= 1'b0;
	Branch <= 1'b0;
	MemRead <= 1'b0;
	MemtoReg <= 1'bX;
	ALUOp <= 2'b00; // ALUOp = 00 for STUR
	MemWrite <= 1'b1;
	ALUSrc <= 1'b1;
	RegWrite <= 1'b0;
	check <= "STUR";
	end
	
	else begin
	//LDUR controls
	Reg2Loc <= 1'bX;
	Uncondbranch <= 1'b0;
	Branch <= 1'b0;
	MemRead <= 1'b1;
	MemtoReg <= 1'b1;
	ALUOp <= 2'b00; // ALUOp = 00 for LDUR
	MemWrite <= 1'b0;
	ALUSrc <= 1'b1;
	RegWrite <= 1'b1;
	check <= "LDUR";
	end

Instruction_set4 <= Instruction[20:12]; // address for D-type is 9 bits
Sign_extend[31:0] <= (Instruction[20] == 1) ? {{23{Instruction[20]}}, Instruction[20:12]} : Instruction [20:12];
end

Read_register1 <= Instruction[9:5]; 
Instruction_set2 <= Instruction[20:16]; 
Instruction_set3 <= Instruction[4:0]; 

if(ALUOp == 2'b00)begin
ALU_control <= 4'b0010; //both LDUR and STUR have same ALU control input so need to look at "check" value
end

else if(ALUOp == 2'b10 && check == "AND")begin
ALU_control <= 4'b0110; //AND
end

else if(ALUOp == 2'b10 && check == "ADD")begin
ALU_control <= 4'b0010; //ADD
end

else if(ALUOp == 2'b10 && check == "ORR")begin
ALU_control <= 4'b0100; //ORR
end

else if(ALUOp == 2'b10 && check == "ORRI")begin
ALU_control <= 4'b0100; //same as ORR
end

else if(ALUOp == 2'b10 && check == "SUB")begin
ALU_control <= 4'b1010; //SUB
end

else if(ALUOp == 2'b10 && check == "EOR")begin
ALU_control <= 4'b1001; // EOR
end

else if(ALUOp == 2'b10 && check == "ANDI")begin
ALU_control <= 4'b0110; //same as AND
end

else if(ALUOp == 2'b10 && check == "MOV")begin
ALU_control <= 4'b1101; //for MOV
end

else if(ALUOp == 2'b10 && check == "EORI")begin
ALU_control <= 4'b1001; //same as EOR
end

else if(ALUOp == 2'b10 && check == "ADDI")begin
ALU_control <= 4'b0010; //same as ADD
end

else if(ALUOp == 2'b10 && check == "SUBI")begin
ALU_control <= 4'b1010; //same as SUB
end

else if (ALUOp == 2'b01 && check == "CBZ")begin
ALU_control <= 4'b0111; //CBZ
end

else if (ALUOp == 2'b01 && check == "CBNZ")begin
ALU_control <= 4'b0001; //created a unique ALU_control for CBNZ
end

else begin
ALU_control <= 4'bxxxx;
end


end	
endmodule 


//module Multiplexer1(input[4:0] Input1, Input2, input Select1, output reg[4:0] Mux_output1);
module Multiplexer1(input[4:0] Instruction_set2, Instruction_set3, input Reg2Loc, output reg[4:0] Decoder_Mux_output);
always @(*) begin

if (Reg2Loc == 0) begin
Decoder_Mux_output <= Instruction_set2;
end

else if (Reg2Loc == 1) begin
Decoder_Mux_output <= Instruction_set3;
end

else begin
Decoder_Mux_output <= 5'bxxxxx;
end

end
endmodule 

module Instruction_Memory(input[31:0] PC, output reg[31:0] Instruction);

reg [31:0] PC_array [0:6]; //7 instructions
reg [6:0] i;

initial begin
PC_array[0]<=32'hF8400281;
PC_array[1]<=32'h8B010022;
PC_array[2]<=32'hD1000333;
PC_array[3]<=32'hB40000E3;
PC_array[4]<=32'h91002294;
PC_array[5]<=32'hF81F4281;
PC_array[6]<=32'h17FFFFFA;
end

always@(*) begin

i <= PC/4;
Instruction <= PC_array [i];

end

endmodule

module PC_unit(input[31:0] Sign_extend, input Branch, input Uncondbranch, input Zero, output reg [31:0] PC);

reg [31:0] add;
reg [31:0] offset;
reg [31:0] result;
reg Check_and_Branch;
reg Select_x;

initial begin
PC <= 0;
end

always@(*) begin

add <= PC + 4;

offset <= Sign_extend << 2; //LEFT SHIFT 2 OR (4 times sign-extension or offset)

result <= PC + offset;

Check_and_Branch <= Branch & Zero;

Select_x <= Check_and_Branch | Uncondbranch;

if (Select_x == 0) begin
PC <= add ;
end

else // (Select_x == 1) 
begin
PC <= result;
end

end
endmodule

//declare sign_extend in top



