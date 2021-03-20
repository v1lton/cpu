module I_or_D (
input wire[31:0] PC_out,
input wire[31:0] ALU_out,
input wire[31:0] ALUOut_out,
input wire[31:0] Excp_out,
input wire[31:0] Reg_A_out,
input wire[2:0] IorD,
output reg[31:0] I_or_D_Out
);
parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4;
always @(*) begin
	case(IorD)
		S0:
			I_or_D_Out <= PC_out;
		S1:
			I_or_D_Out <= ALU_out;
		S2:
			I_or_D_Out <= ALUOut_out;
		S3:
			I_or_D_Out <= Excp_out;
		S4:
			I_or_D_Out <= Reg_A_out;
	endcase
end

endmodule