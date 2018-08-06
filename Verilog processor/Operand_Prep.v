module Operand_Prep(input[4:0] Read_register1, Read_register2, Instruction_set3, input[31:0] Write_data, Instruction_set4, input RegWrite, output reg[31:0] Read_data1, Read_data2);

reg [31:0] Register_array [0:31]; 

wire [31:0] Read_data2;

for (i=0; i<32; i++) begin
Register_array[i] <= 0;
end

always (*) begin

Read_data1 <= Read_array[Read_register1];

Read_data2 <= Read_array[Read_register2];

end

endmodule 