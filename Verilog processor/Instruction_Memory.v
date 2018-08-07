module Instruction_Memory(input[31:0] PC, output reg[31:0] Instruction);

reg [31:0] PC_array [0:8]; //9 instructions
reg [8:0] i;

initial begin
PC_array[0]=32'h8B010022; 
PC_array[1]=32'hF8400281;
PC_array[2]=32'hF8400149;
PC_array[3]=32'h91002294;
PC_array[4]=32'hF81F4281;
PC_array[5]=32'h8B150289;
PC_array[6]=32'hD1000333;
PC_array[7]=32'h8A100671;
PC_array[8]=32'h8B010022;

end

always@(*) begin

i = PC/4;
Instruction = PC_array [i];

end

endmodule
