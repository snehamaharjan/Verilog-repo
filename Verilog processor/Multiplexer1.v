module Multiplexer1(input[4:0] Instruction_set2, Instruction_set3, input Reg2Loc, i output reg[4:0] Decoder_Mux_output);

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
