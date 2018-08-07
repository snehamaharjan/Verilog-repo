module PC_unit(input[31:0] Sign_extend, input Branch, input Uncondbranch, input Zero, output reg [31:0] PC);

reg [31:0] add;
reg [31:0] offset;
reg [31:0] result;
reg Check_and_Branch;
reg Select_x;

initial begin
PC = 0;
end

always@(*) begin

add = PC + 4;

offset = Sign_extend << 2; //LEFT SHIFT 2 OR (4 times sign-extension or offset)

result = PC + offset;

Check_and_Branch = Branch & Zero;

Select_x = Check_and_Branch | Uncondbranch;

if (Select_x == 0) begin
PC = add ;
end

else // (Select_x == 1) 
begin
PC = result;
end

end
endmodule
