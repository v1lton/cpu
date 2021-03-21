module alu_src_a
(
    input wire [1:0] ALUSrcA,
    input wire [31:0] PC_Out,
    input wire [31:0] Reg_A_out,
    input wire [31:0] MDR_out,
    output wire [31:0] ALUSrcA_out

);

    wire [31:0] auxiliar;

    assign auxiliar = (ALUSrcA[0]) ? Reg_A_out : PC_Out;
    assign ALUSrcA_out = (ALUSrcA[1]) ? MDR_out : auxiliar;

endmodule


