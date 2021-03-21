module shift_src (
input wire[31:0] ALUSrcA_out,
input wire[31:0] ALUSrcB_out,
input wire ShiftSrc,
output reg[31:0] Shift_src_out
);

parameter S0 = 0, S1 = 1;
always @(*) begin
	case(ShiftSrc)
		S0:
			Shift_src_out <= ALUSrcA_out;
		S1:
			Shift_src_out <= ALUSrcB_out;
	endcase
end

endmodule