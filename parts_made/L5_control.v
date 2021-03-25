module L5_control (
input wire[31:0] MDR_out,
input wire[1:0] L5Control,
output reg[31:0] L5Control_out
);
parameter S1 = 1, S2 = 2, S3 = 3;
always @(*) begin
	case(L5Control)
		S1:
			L5Control_out <= MDR_out;//Load Word
		S2:
			L5Control_out <= {16'd0,MDR_out[15:0]};//Load Half
		S3:
			L5Control_out <= {24'd0,MDR_out[7:0]};//Load Byte
	endcase
end

endmodule