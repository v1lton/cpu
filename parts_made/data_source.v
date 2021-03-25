module data_source (
	input wire [3:0]DataSrc,
	input wire [31:0] ALU_out, 
	input wire [31:0] L5Control_out,
	input wire [31:0] HI_out,
	input wire [31:0] LO_out,
	input wire [31:0] Sign_extend_1to32_out,
	input wire [31:0] Sign_extend_16to32_out,
	input wire [31:0] Shif_left_16_out, 
	input wire [31:0] Shift_reg_out, 
	input wire [31:0] ALUSrcA_out,
	input wire [31:0] ALUSrcB_out,
	output reg [31:0] DataSrc_out
);
parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4, S5 = 5, S6 = 6, S7 = 7, S8 = 8, S9 = 9, S10 = 10;
always @(*) begin
	case(DataSrc)
		S0:
			DataSrc_out <= ALU_out;
		S1:
			DataSrc_out <= L5Control_out;
		S2:
			DataSrc_out <= HI_out;
		S3:
			DataSrc_out <= LO_out;
		S4:
			DataSrc_out <= Sign_extend_1to32_out;
		S5:
			DataSrc_out <= Sign_extend_16to32_out;
		S6:
			DataSrc_out <= Shif_left_16_out;
		S7:
			DataSrc_out <= 32'd227;
		S8:
			DataSrc_out <= Shift_reg_out;
		S9:
			DataSrc_out <= ALUSrcA_out;
		S10:
			DataSrc_out <= ALUSrcB_out;
	endcase
end

endmodule