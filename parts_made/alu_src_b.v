module alu_src_b (
    input   wire    [1:0]   ALUSrcB,
    input   wire    [31:0]  B_out,
    input   wire    [31:0]  Shift_left_16_out,
    input   wire    [31:0]  Shif_left_mult_4_out,
    output  wire    [31:0]  ALUSrcB_out
);

    wire [31:0] aux1;
    wire [31:0] aux2;

    assign aux1 = (ALUSrcB[0]) ? 32'd4 : B_out;
    assign aux2 = (ALUSrcB[0]) ? Shif_left_mult_4_out : Shift_left_16_out;
    assign ALUSrcB_out = (ALUSrcB[1]) ? aux2 : aux1;

endmodule