module shift_amt (
	input wire[31:0] Reg_B_out,
	input wire[15:0] IMMEDIATE,
	input wire ShiftAmt,
	output reg[4:0] shift_amt_out
);
parameter S0 = 0, S1 = 1;
always @(*) begin
	case(ShiftAmt)
		S0:
			shift_amt_out <= Reg_B_out[4:0];
		S1:
			shift_amt_out <= IMMEDIATE[10:6];
	endcase
end

endmodule