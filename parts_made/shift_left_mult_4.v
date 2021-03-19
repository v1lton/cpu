module shift_left_mult_4(
    input   wire    [31:0]  PC,
    output  wire    [31:0]  Shif_left_mult_4_out
);

    assign Shif_left_mult_4_out = PC << 2; //two zeros left = * 4

endmodule