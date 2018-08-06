module Operand_Prep(input[4:0] Read_register1, Read_register2, Instruction_set3, input[31:0] Write_data, Instruction_set4, input RegWrite, output reg[31:0] Read_data1);

reg [31:0] Register_array [0:31]; 

reg [31:0] Read_data2;
reg [4:0] i;

always @(*) begin

for (i=0; i<32; i = i+1) begin
Register_array[i] <= 0;
end
  
  Register_array[20] <= 0; 
  Register_array[25] <= 15;
  Register_array[3] <= 3;
  

Read_data1 <= Register_array[Read_register1];
Read_data2 <= Register_array[Read_register2];

end

endmodule 
