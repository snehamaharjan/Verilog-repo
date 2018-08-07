module Operand_Prep( input[4:0] Read_register1, Decoder_Mux_output, Instruction_set3, input[31:0] Instruction_set4, input RegWrite, MemtoReg, input [31:0]data, input [31:0] ALU_Result, output reg[31:0] Read_data1, Read_data2, output reg[31:0] Write_data);

reg [31:0] Register_array [0:31]; 
reg [5:0] i;
wire [4:0] Read_register2 = Decoder_Mux_output;

initial begin 
for (i=0; i<32; i = i+1) begin
Register_array[i] = 0;
end

Register_array[1] = 6;
Register_array[20] = 5; 
Register_array[25] = 15;
Register_array[3] = 3; 
end


  
always @(*) begin

 Read_data1 = Register_array[Read_register1];
  
 Read_data2 = Register_array[Read_register2];

if(i!= 31)begin

    if(RegWrite == 1'b1) begin
        if (MemtoReg== 1'b1) 
        begin
          #1
          Write_data = data;
        end
        else if (MemtoReg == 1'b0)
        begin
         #1
          Write_data = ALU_Result;
        end
        else
        begin
        #1
        Write_data = 32'bx;
        end
    end
    else begin
     #1
        Write_data = 32'bx;
    end
  end
end

endmodule 
