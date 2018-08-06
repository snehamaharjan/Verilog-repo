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
