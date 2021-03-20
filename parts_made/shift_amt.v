  
module shift_amt (
input wire[4:0] Reg_B_out,
input wire[15:0] Offset,
input wire ShiftAmt,
output reg[4:0] shift_amt_out
);
parameter S0 = 0, S1 = 1;
always @(*) begin
	case(ShiftAmt)
		S0:
			shift_amt_out <= Reg_B_out;
		S1:
			shift_amt_out <= Offset[10:6];
	endcase
end

endmodule