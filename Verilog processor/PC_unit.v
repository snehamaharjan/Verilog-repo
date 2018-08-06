module PC_unit(input[31:0] Sign_extend, input Branch, Uncondbranch, check_pc, output [31:0] PC);


initial begin
PC <= 0;
end

always@(*) begin

wire add <= current_PC_output + 4;

wire offset <= sign_extend << 2; //LEFT SHIFT 2 OR (4 times sign-extension or offset)

wire result <= PC + offset;

wire Check_and_Branch <= Branch & check;

wire Select_x <= Check_and_Branch | Uncondbranch;

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
