module pc_source (
input wire[31:0] MDR_Out,
input wire[31:0] ALU_out,
input wire[31:0] Concatenated_28to32_out, 
input wire[31:0] ALUOut_out,
input wire[31:0] EPC_out,
input wire[31:0] Excp_out, 
input wire[2:0] PCSource,
output reg[31:0] PCSource_out
);
parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4, S5 = 5;
always @(*) begin
	case(PCSource)
		S0:
			PCSource_out <= ALU_out;
		S1:
			PCSource_out <= ALUOut_out;
		S2:
			PCSource_out <= Concatenated_28to32_out;
		S3:
			PCSource_out <= MDR_Out;
		S4:
			PCSource_out <= EPC_out;
		S5:
			PCSource_out <= Excp_out;
	endcase
end

endmodule