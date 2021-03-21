module data_source (
input wire[31:0] ALU_out, 
input wire[31:0] L5Control_out,
input wire[31:0] HI_out,
input wire[31:0] LO_out,
input wire[31:0] Sign_extend_1to32_out, //sign extend 1-32 (mudei nome aqui)
input wire[31:0] Sign_extend_16to32_out,//sign extend 16-32 (o nome tava igual ao sign extend 1, ent mudei)
input wire[31:0] Shif_left_16_out, 
input wire[31:0] Shift_reg_out, //ainda nao foi feito
input wire[31:0] ALUSrcA_out,
input wire[3:0] ALUSrcB_out,
output reg[31:0] DataSrc_out
);
parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4, S5 = 5, S6 = 6, S7 = 7, S8 = 8, S9 = 9, S10 = 10;
always @(*) begin
	case(DataSrc)
		S0:
			data_source_out <= ALU_out;
		S1:
			data_source_out <= L5Control_out;
		S2:
			data_source_out <= HI_out;
		S3:
			data_source_out <= LO_out;
		S4:
			data_source_out <= Sign_extend_1to32_out;
		S5:
			data_source_out <= Sign_extend_16to32_out;
		S6:
			data_source_out <= Shif_left_16_out;
		S7:
			data_source_out <= 32'd227;
		S8:
			data_source_out <= Shift_reg_out;
		S9:
			data_source_out <= ALUSrcA_out;
		S10:
			data_source_out <= ALUSrcB_out;
	endcase
end

endmodule