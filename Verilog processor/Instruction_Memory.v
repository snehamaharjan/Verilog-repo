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
