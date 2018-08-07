module Decoder_Controller(input[31:0] Instruction, output reg Reg2Loc, Uncondbranch, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, output reg[3:0] ALU_control, output reg[4:0] Read_register1, Instruction_set2, Instruction_set3, output reg [31:0] Instruction_set4, output reg[5*8:0] check, output reg [31:0] Sign_extend);

reg [1:0] ALUOp; //2 bit ALUop

always @(*) begin
if(Instruction[30:26] == 5'b00101) begin
	
	Reg2Loc = 1'bX;
	MemRead = 1'b0;
	MemtoReg = 1'bX;
	MemWrite = 1'b0;
	ALUSrc = 1'bX;
	RegWrite = 1'b0;
	ALUOp = 2'bXX;	// ALUOp = XX for B and BL because no need of 
	Uncondbranch = 1'b1;
	Branch = 1'b0;

	if(Instruction[31] == 1'b0)begin
	//Branch 
	check = "B";
	end

	else begin
	//BL 	
	check = "BL";
	end

	Instruction_set4 = Instruction[25:0]; //B-type address is 26 bits long
    Sign_extend[31:0] = (Instruction[25] == 1) ? {{6{Instruction[25]}}, Instruction[25:0]} : Instruction [25:0];

end

else if(Instruction[29:26] == 4'b1101) begin

	//both CBZ and CBNZ conrols are the same so not double checking
	Reg2Loc = 1'b1;
	Uncondbranch = 1'b0;
	Branch = 1'b1;
	MemRead = 1'b0;
	MemtoReg = 1'bX;
	ALUOp = 2'b01; //ALUOp = 01 for CBZ and CBNZ
	MemWrite = 1'b0;
	ALUSrc = 1'b0;
	RegWrite = 1'b0;

	if(Instruction[24] == 1'b0)begin
	//CBZ
	check = "CBZ";
	end

	else begin
	//CBNZ 
	check = "CBNZ";
	end

	Instruction_set4 = Instruction[23:5]; //CB-type address is 19 bits long
    Sign_extend[31:0] = (Instruction[23] == 1) ? {{13{Instruction[23]}}, Instruction[23:5]} : Instruction [23:5];
end

else if(Instruction[29:25] == 5'b01000) begin

	//ADDI controls and SUBI controls merged because they are both I-types
	Reg2Loc = 1'bX;
	Uncondbranch = 1'b0;
	Branch = 1'b0;
	MemRead = 1'b0;
	MemtoReg = 1'b0;
	ALUOp = 2'b10; //ALUOp = 10 for I-type
	MemWrite = 1'b0;
	ALUSrc = 1'b1;
	RegWrite = 1'b1;

	if(Instruction[30] == 1'b0)begin
	//ADDI 
	check <= "ADDI";
	end

	else begin
	//SUBI
	check <= "SUBI";
	end

	Instruction_set4 = Instruction[21:10]; //I-type immediate is 12 bits
    Sign_extend[31:0] = (Instruction[21] == 1) ? {{20{Instruction[21]}}, Instruction[21:10]} : Instruction [21:10];
end

else if(Instruction[28:25] == 4'b1001) begin

	//ANDI, MOV, EORI controls
	Reg2Loc = 1'bX;
	Uncondbranch <= 1'b0;
	Branch = 1'b0;
	MemRead = 1'b0;
	MemtoReg = 1'b0;
	ALUOp = 2'b10; //ALUOp = 10 for I-type
	MemWrite = 1'b0;
	ALUSrc = 1'b1;
	RegWrite = 1'b1;
	
	if(Instruction[30:29] == 2'b00)begin
	//ANDI 
	check <= "ANDI";
	Instruction_set4 = Instruction[21:10]; //I-type immediate is 12 bits
    Sign_extend[31:0] = (Instruction[21] == 1) ? {{20{Instruction[21]}}, Instruction[21:10]} : Instruction [21:10];
	end

	else if(Instruction[29] == 1'b1)begin
	//ORRI
	check <= "ORRI";
	Instruction_set4 = Instruction[21:10]; //I-type immediate is 12 bits
		Sign_extend[31:0] = (Instruction[21] == 1) ? {{20{Instruction[21]}}, Instruction[21:10]} : Instruction [21:10];
	end

	else if (Instruction[23] == 1'b1) begin
	//MOVZ -- The MOV instruction copies the value of Operand2 into Rd. (assuming Operand2 is an immediate)
	check <= "MOV";
	Instruction_set4 = Instruction[22:5]; //immediate is 18 bits for MOV
    Sign_extend[31:0] = (Instruction[22] == 1) ? {{14{Instruction[22]}}, Instruction[22:5]} : Instruction [22:5];
	end 

	else begin
	//EORI 
	check <= "EORI";
	Instruction_set4 = Instruction[21:10]; //I-type immediate is 12 bits
    Sign_extend[31:0] = (Instruction[21] == 1) ? {{20{Instruction[21]}}, Instruction[21:10]} : Instruction [21:10];
	end 

end

else if(Instruction[27:25] == 3'b101) begin

	//AND, ADD, ORR, SUB, EOR controls
	Reg2Loc = 1'b0;
	Uncondbranch = 1'b0;
	Branch = 1'b0;
	MemRead = 1'b0;
	MemtoReg = 1'b0;
	ALUOp = 2'b10; //ALUOp = 10 for R-type
	MemWrite = 1'b0;
	ALUSrc = 1'b0;
	RegWrite = 1'b1;
	
	if(Instruction[29] == 1'b0 && Instruction[24] == 1'b0)begin
	//AND controls
	check = "AND";
	end

	else if (Instruction[30] == 1'b0 && Instruction[24] == 1'b1) begin
	//ADD controls
	check = "ADD";
	end

	else if (Instruction[30:29] == 2'b01) begin
	//ORR controls
	check = "ORR";
	end

	else if (Instruction[30] == 1'b1 && Instruction[24] == 1'b1) begin
	//SUB controls
	check = "SUB";
	end

	else begin
	//EOR controls
	check = "EOR";
	end

	//Instruction_set4 not needed for R-types

end 

else if(Instruction[31:29] == 3'b111) begin

	if(Instruction[22] == 1'b0)begin
	//STUR controls
	Reg2Loc = 1'b1;
	Uncondbranch = 1'b0;
	Branch = 1'b0;
	MemRead = 1'b0;
	MemtoReg = 1'bX;
	ALUOp = 2'b00; // ALUOp = 00 for STUR
	MemWrite = 1'b1;
	ALUSrc = 1'b1;
	RegWrite = 1'b0;
	check = "STUR";
	end
	
	else begin
	//LDUR controls
	Reg2Loc = 1'bX;
	Uncondbranch = 1'b0;
	Branch = 1'b0;
	MemRead = 1'b1;
	MemtoReg = 1'b1;
	ALUOp = 2'b00; // ALUOp = 00 for LDUR
	MemWrite = 1'b0;
	ALUSrc = 1'b1;
	RegWrite = 1'b1;
	check = "LDUR";
	end

Instruction_set4 = Instruction[20:12]; // address for D-type is 9 bits
Sign_extend[31:0] = (Instruction[20] == 1) ? {{23{Instruction[20]}}, Instruction[20:12]} : Instruction [20:12];
end

Read_register1 = Instruction[9:5]; 
Instruction_set2 = Instruction[20:16]; 
Instruction_set3 = Instruction[4:0]; 

if(ALUOp == 2'b00)begin
ALU_control = 4'b0010; //both LDUR and STUR have same ALU control input so need to look at "check" value
end

else if(ALUOp == 2'b10 && check == "AND")begin
ALU_control = 4'b0110; //AND
end

else if(ALUOp == 2'b10 && check == "ADD")begin
ALU_control = 4'b0010; //ADD
end

else if(ALUOp == 2'b10 && check == "ORR")begin
ALU_control = 4'b0100; //ORR
end

else if(ALUOp == 2'b10 && check == "ORRI")begin
ALU_control = 4'b0100; //same as ORR
end

else if(ALUOp == 2'b10 && check == "SUB")begin
ALU_control = 4'b1010; //SUB
end

else if(ALUOp == 2'b10 && check == "EOR")begin
ALU_control = 4'b1001; // EOR
end

else if(ALUOp == 2'b10 && check == "ANDI")begin
ALU_control = 4'b0110; //same as AND
end

else if(ALUOp == 2'b10 && check == "MOV")begin
ALU_control = 4'b1101; //for MOV
end

else if(ALUOp == 2'b10 && check == "EORI")begin
ALU_control = 4'b1001; //same as EOR
end

else if(ALUOp == 2'b10 && check == "ADDI")begin
ALU_control = 4'b0010; //same as ADD
end

else if(ALUOp == 2'b10 && check == "SUBI")begin
ALU_control = 4'b1010; //same as SUB
end

else if (ALUOp == 2'b01 && check == "CBZ")begin
ALU_control = 4'b0111; //CBZ
end

else if (ALUOp == 2'b01 && check == "CBNZ")begin
ALU_control = 4'b0001; //created a unique ALU_control for CBNZ
end

else begin
ALU_control = 4'bxxxx;
end


end	
endmodule 

