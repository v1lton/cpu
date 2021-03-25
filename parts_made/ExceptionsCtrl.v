module ExceptionsCtrl (
input wire[1:0] ExcpCtrl,
output reg[31:0] Excp_out
);

parameter S0 = 0, S1 = 1, S2 = 2;
always @(*) begin
	case(ExcpCtrl)
		S0:
			Excp_out <= 32'd253;
		S1:
			Excp_out <= 32'd254;
		S2:
			Excp_out <= 32'd255;
	endcase
end

endmodule