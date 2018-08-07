`timescale 1ns/1ns

module test_decoder;
 
//inputs
reg[31:0] Instruction;
 
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

wire[4:0] Decoder_Mux_output;
wire [5*8:0] check;

Decoder_Controller sample(Instruction, Reg2Loc, Uncondbranch, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, ALU_control, Read_register1, Instruction_set2, Instruction_set3, Instruction_set4, check);
 
Multiplexer1 Decoder_mux(Instruction_set2, Instruction_set3, Reg2Loc, Decoder_Mux_output);

initial begin

Instruction = 32'b0001_0100_0000_0000_0000_0000_0100_0001; //B #offset-41
	#5 $display("type = %s",check);
	$display ("B address = %h", Instruction_set4, " ALU control = %b", ALU_control);
	$display ("Reg2Loc= %b", Reg2Loc, " Uncondbranch= %b", Uncondbranch, " Branch= %b", Branch, " MemRead= %b", MemRead,
	    " MemtoReg= %b", MemtoReg, " MemWrite= %b", MemWrite, " ALUSrc= %b", ALUSrc, " RegWrite= %b", RegWrite);
	$display(, ,) ;

Instruction = 32'b1001_0100_0000_0000_0000_0000_0100_0001; //BL #offset-41
	#5 $display("type = %s",check);
	$display ("BL address = %h", Instruction_set4, " ALU control = %b", ALU_control);
	$display ("Reg2Loc= %b", Reg2Loc, " Uncondbranch= %b", Uncondbranch, " Branch= %b", Branch, " MemRead= %b", MemRead,
	    " MemtoReg= %b", MemtoReg, " MemWrite= %b", MemWrite, " ALUSrc= %b", ALUSrc, " RegWrite= %b", RegWrite);
	$display(, ,) ;

Instruction = 32'b1011_0100_0000_0000_0000_1000_0010_0001; //CBZ X1, #offset-41
	#5 $display("type = %s",check);
	$display ("CBZ address = %h", Instruction_set4, " Rt = ", Decoder_Mux_output, " ALU control = %b", ALU_control);
	  $display ("Reg2Loc= %b", Reg2Loc, " Uncondbranch= %b", Uncondbranch, " Branch= %b", Branch, " MemRead= %b", MemRead,
	    " MemtoReg= %b", MemtoReg, " MemWrite= %b", MemWrite, " ALUSrc= %b", ALUSrc, " RegWrite= %b", RegWrite);
	$display(, ,) ;

Instruction = 32'b1011_0101_0000_0000_0000_1000_0010_0001;//CBNZ X1, #offset-41
	#5  $display("type = %s",check);
	  $display ("CBNZ address = %h", Instruction_set4, " Rt = ", Decoder_Mux_output, " ALU control = %b", ALU_control);
	   $display ("Reg2Loc= %b", Reg2Loc, " Uncondbranch= %b", Uncondbranch, " Branch= %b", Branch, " MemRead= %b", MemRead,
	    " MemtoReg= %b", MemtoReg, " MemWrite= %b", MemWrite, " ALUSrc= %b", ALUSrc, " RegWrite= %b", RegWrite);
	$display(, ,) ;

Instruction = 32'b1111_1000_0100_0000_0000_0001_0100_1001; //LDUR X9, [X10, #0]
	#5  $display("type = %s",check);
 $display ("LDUR Write Register, Rt = ", Instruction_set3 ," Read register1, Rn = ", Read_register1, " Immediate = ", Instruction_set4, " ALU control = %b", ALU_control );
	  $display ("Reg2Loc= %b", Reg2Loc, " Uncondbranch= %b", Uncondbranch, " Branch= %b", Branch, " MemRead= %b", MemRead,
	    " MemtoReg= %b", MemtoReg, " MemWrite= %b", MemWrite, " ALUSrc= %b", ALUSrc, " RegWrite= %b", RegWrite);
	$display(, ,) ;

Instruction = 32'b1111_1000_0000_0000_0000_0001_0100_1001; //STUR X9, [X10, #0]
	#5  $display("type = %s",check);
 $display ("STUR Read Register1, Rn = ",Read_register1, " Read Register2, Rt=", Decoder_Mux_output, " Immediate = ", Instruction_set4, " ALU control = %b", ALU_control);
	 $display ("Reg2Loc= %b", Reg2Loc, " Uncondbranch= %b", Uncondbranch, " Branch= %b", Branch, " MemRead= %b", MemRead,
	    " MemtoReg= %b", MemtoReg, " MemWrite= %b", MemWrite, " ALUSrc= %b", ALUSrc, " RegWrite= %b", RegWrite);
	$display(, ,) ;

Instruction = 32'b1000_1011_0001_1000_0000_0001_0010_1011; //ADD X11, X9, X24
	#5  $display("type = %s",check);
 $display ("ADD Write register,  Rd = ",Instruction_set3 , " Read register1, Rn = ",Read_register1, " Read register2, Rm = ", Decoder_Mux_output, " ALU control = %b", ALU_control);
	  $display ("Reg2Loc= %b", Reg2Loc, " Uncondbranch= %b", Uncondbranch, " Branch= %b", Branch, " MemRead= %b", MemRead,
	    " MemtoReg= %b", MemtoReg, " MemWrite= %b", MemWrite, " ALUSrc= %b", ALUSrc, " RegWrite= %b", RegWrite);
	$display(, ,) ;

Instruction = 32'b1000_1010_0001_1000_0000_0001_0010_1011; //AND X11, X9, X24
	#5  $display("type = %s",check);
 $display ("AND Write register,  Rd = ",Instruction_set3 , " Read register1, Rn = ",Read_register1, " Read register2, Rm = ", Decoder_Mux_output, " ALU control = %b", ALU_control);
	    $display ("Reg2Loc= %b", Reg2Loc, " Uncondbranch= %b", Uncondbranch, " Branch= %b", Branch, " MemRead= %b", MemRead,
	    " MemtoReg= %b", MemtoReg, " MemWrite= %b", MemWrite, " ALUSrc= %b", ALUSrc, " RegWrite= %b", RegWrite);
	$display(, ,) ;

Instruction = 32'b1010_1010_0001_1000_0000_0001_0010_1011; //ORR X11, X9, X24
	#5  $display("type = %s",check);
$display ("ORR Write register,  Rd = ",Instruction_set3 , " Read register1, Rn = ",Read_register1, " Read register2, Rm = ", Decoder_Mux_output, " ALU control = %b", ALU_control);
	   $display ("Reg2Loc= %b", Reg2Loc, " Uncondbranch= %b", Uncondbranch, " Branch= %b", Branch, " MemRead= %b", MemRead,
	    " MemtoReg= %b", MemtoReg, " MemWrite= %b", MemWrite, " ALUSrc= %b", ALUSrc, " RegWrite= %b", RegWrite);
	$display(, ,) ;

Instruction = 32'b1110_1010_0001_1000_0000_0001_0010_1011;//EOR X11, X9, X24
	#5  $display("type = %s",check);
 $display ("EOR Write register,  Rd = ",Instruction_set3 , " Read register1, Rn = ",Read_register1, " Read register2, Rm = ", Decoder_Mux_output, " ALU control = %b", ALU_control);
	    $display ("Reg2Loc= %b", Reg2Loc, " Uncondbranch= %b", Uncondbranch, " Branch= %b", Branch, " MemRead= %b", MemRead,
	    " MemtoReg= %b", MemtoReg, " MemWrite= %b", MemWrite, " ALUSrc= %b", ALUSrc, " RegWrite= %b", RegWrite);
	$display(, ,) ;

Instruction = 32'b1100_1011_0001_1000_0000_0001_0010_1011; //SUB X11, X9, X24
	#5  $display("type = %s",check);
 $display ("SUB Write register,  Rd = ",Instruction_set3 , " Read register1, Rn = ",Read_register1, " Read register2, Rm = ", Decoder_Mux_output, " ALU control = %b", ALU_control);
	     $display ("Reg2Loc= %b", Reg2Loc, " Uncondbranch= %b", Uncondbranch, " Branch= %b", Branch, " MemRead= %b", MemRead,
	    " MemtoReg= %b", MemtoReg, " MemWrite= %b", MemWrite, " ALUSrc= %b", ALUSrc, " RegWrite= %b", RegWrite);
	$display(, ,) ;

Instruction = 32'b1001_0001_0000_0000_0000_0110_1101_0110;//ADDI X22, X22, #1
	#5  $display("type = %s",check);
 $display ("ADDI Write register,  Rd = ",Instruction_set3, " Read register1, Rn = ", Read_register1, " Immediate = ", Instruction_set4, " ALU control = %b", ALU_control);
	     $display ("Reg2Loc= %b", Reg2Loc, " Uncondbranch= %b", Uncondbranch, " Branch= %b", Branch, " MemRead= %b", MemRead,
	    " MemtoReg= %b", MemtoReg, " MemWrite= %b", MemWrite, " ALUSrc= %b", ALUSrc, " RegWrite= %b", RegWrite);
	$display(, ,) ;

Instruction = 32'b1001_0010_0000_0000_0000_0110_1101_0110;//ANDI X22, X22, #1
	#5  $display("type = %s",check);
  $display ("ANDI Write register,  Rd = ",Instruction_set3, " Read register1, Rn = ", Read_register1, " Immediate = ", Instruction_set4, " ALU control = %b", ALU_control);
	     $display ("Reg2Loc= %b", Reg2Loc, " Uncondbranch= %b", Uncondbranch, " Branch= %b", Branch, " MemRead= %b", MemRead,
	    " MemtoReg= %b", MemtoReg, " MemWrite= %b", MemWrite, " ALUSrc= %b", ALUSrc, " RegWrite= %b", RegWrite);
	$display(, ,) ;

Instruction = 32'b1011_0010_0000_0000_0000_0110_1101_0110;//ORRI X22, X22, #1
	#5  $display("type = %s",check);
 $display ("ORRI Write register,  Rd = ",Instruction_set3, " Read register1, Rn = ", Read_register1, " Immediate = ", Instruction_set4, " ALU control = %b", ALU_control);
	    $display ("Reg2Loc= %b", Reg2Loc, " Uncondbranch= %b", Uncondbranch, " Branch= %b", Branch, " MemRead= %b", MemRead,
	    " MemtoReg= %b", MemtoReg, " MemWrite= %b", MemWrite, " ALUSrc= %b", ALUSrc, " RegWrite= %b", RegWrite);
	$display(, ,) ;

Instruction = 32'b1101_0010_0000_0000_0000_0110_1101_0110;//EORI X22, X22, #1
	#5 $display("type = %s",check);
  $display ("EORI Write register,  Rd = ",Instruction_set3, " Read register1, Rn = ", Read_register1, " Immediate = ", Instruction_set4, " ALU control = %b", ALU_control);
	    $display ("Reg2Loc= %b", Reg2Loc, " Uncondbranch= %b", Uncondbranch, " Branch= %b", Branch, " MemRead= %b", MemRead,
	    " MemtoReg= %b", MemtoReg, " MemWrite= %b", MemWrite, " ALUSrc= %b", ALUSrc, " RegWrite= %b", RegWrite);
	$display(, ,) ;

Instruction = 32'b1101_0001_0000_0000_0000_0110_1101_0110;//SUBI X22, X22, #1
	#5  $display("type = %s",check);
 $display ("SUBI Write register,  Rd = ",Instruction_set3, " Read register1, Rn = ", Read_register1, " Immediate = ", Instruction_set4, " ALU control = %b", ALU_control);
	   $display ("Reg2Loc= %b", Reg2Loc, " Uncondbranch= %b", Uncondbranch, " Branch= %b", Branch, " MemRead= %b", MemRead,
	    " MemtoReg= %b", MemtoReg, " MemWrite= %b", MemWrite, " ALUSrc= %b", ALUSrc, " RegWrite= %b", RegWrite);
	$display(, ,) ;

Instruction = 32'b1101_0010_1000_0000_0000_0000_0010_0001;//MOV X1, #1
	#5  $display("type = %s",check);
$display ("MOV Write Register, Rd = ", Instruction_set3, " Immediate = ", Instruction_set4, , " ALU control = %b", ALU_control );
	    $display ("Reg2Loc= %b", Reg2Loc, " Uncondbranch= %b", Uncondbranch, " Branch= %b", Branch, " MemRead= %b", MemRead,
	    " MemtoReg= %b", MemtoReg, " MemWrite= %b", MemWrite, " ALUSrc= %b", ALUSrc, " RegWrite= %b", RegWrite);
	$display(, ,) ;

end
endmodule
