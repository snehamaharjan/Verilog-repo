//module Multiplexer1(input[4:0] Input1, Input2, input Select1, output reg[4:0] Mux_output1);
module Multiplexer1(input[4:0] Instruction_set2, Instruction_set3, input Reg2Loc, output reg[4:0] Decoder_Mux_output);
always @(*) begin

if (Reg2Loc == 0) begin
Decoder_Mux_output = Instruction_set2;
end

else if (Reg2Loc == 1) begin
Decoder_Mux_output = Instruction_set3;
end

else begin
Decoder_Mux_output = 5'bxxxxx;
end

end
endmodule 
