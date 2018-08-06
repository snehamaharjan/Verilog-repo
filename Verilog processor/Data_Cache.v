
// module Data_Cache(input[31:0] ALU_Result, Read_data2, input MemWrite, MemRead, output reg[31:0] ReadData);

module fullAssociative( 
output reg [31:0]data,  // Read data
input [31:0]addr,    //ALU_Result 
input [31:0]inputData,  //Write data or Read_data2
input writeData,   //MemWrite     
input readData     //MemRead
);

reg [28:0]setAddress[0:15]; //16 lines
reg [31:0]setData[0:15];

reg [6:0]i;
wire [28:0]blockAddress = addr[31:3]; //tag and index

always@(blockAddress, inputData, writeData, readData) begin : search

	for(i = 0; i < 16; i = i + 1) begin //how many lines there are
		if(blockAddress == setAddress[i]) begin

			if(readData) begin
				data = setData[i];
			end //if

			else if(writeData) begin

				setData[i] = inputData;
				data = setData[i];

			end //else
					
			disable search;

		end //if PC==

		else begin //if miss

            setData[i] = inputData;
				data = setData[i];
		end

	end //for
end // always

initial begin
	setAddress[0] = 29'h00000202; setData[0] = 32'h01010101;
	setAddress[1] = 29'h00000204; setData[1] = 32'h02020202;
	setAddress[2] = 29'h00000206; setData[2] = 32'h03030303;
	setAddress[3] = 29'h00000208; setData[3] = 32'h04040404;
	setAddress[4] = 29'h0000020A; setData[4] = 32'h05050505;
	setAddress[5] = 29'h0000020C; setData[5] = 32'h06060606;
	setAddress[6] = 29'h0000020E; setData[6] = 32'h07070707;
	setAddress[7] = 29'h00000210; setData[7] = 32'h08080808;
	setAddress[8] = 29'h00000201; setData[8] = 32'h99999999;
	setAddress[9] = 29'h00000203; setData[9] = 32'hAAAAAAAA;
	setAddress[10] = 29'h00000205; setData[10] = 32'hBBBBBBBB;
	setAddress[11] = 29'h00000207; setData[11] = 32'hCCCCCCCC;
	setAddress[12] = 29'h00000209; setData[12] = 32'hDDDDDDDD;
	setAddress[13] = 29'h0000020B; setData[13] = 32'hEEEEEEEE;
	setAddress[14] = 29'h0000020D; setData[14] = 32'hFFFFFFFF;
	setAddress[15] = 29'h0000020F; setData[15] = 32'h01234567;
end

endmodule //fullAssoociative
endmodule 
