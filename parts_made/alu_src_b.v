module alu_src_b (
    input   wire    [1:0]   ALUSrcB,
    input   wire    [31:0]  reg_aux_b,
    input   wire    [31:0]  Sign_out_32,
    input   wire    [31:0]  Shif_left_mult_4_out,
    output  wire    [31:0]  alu_src_b_out
);

    wire [31:0] aux1;
    wire [31:0] aux2;

    assign aux1 = (ALUSrcB[0]) ? 32'd4 : reg_aux_b;
    assign aux2 = (ALUSrcB[0]) ? Shif_left_mult_4_out : Sign_out_32;
    assign alu_src_b_out = (ALUSrcB[1]) ? aux2 : aux1;

endmodule