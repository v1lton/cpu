module reg_dst (
input wire[4:0] RS,
input wire[4:0] RT,
input wire[15:0] Offset, 
input wire[2:0] RegDst,
output reg[4:0] reg_dst_out
);
parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4;
always @(*) begin
	case(RegDst)
		S0:
			reg_dst_out <= RT;
		S1:
			reg_dst_out <= Offset[15:11];
		S2:
			reg_dst_out <= 5'd29;
		S3:
			reg_dst_out <= 5'd31;
		S4:
			reg_dst_out <= RS;
	endcase
end

endmodule