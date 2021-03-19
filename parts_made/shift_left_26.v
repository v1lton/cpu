module shift_left_26(
    input   wire    [25:0]  Concatenated_28,
    output  wire    [27:0]  Shif_left_26_out
);

    wire [27:0] Aux;

    assign Aux = {{2{1'b0}}, Concatenated_28}; //Extends Concatenated_28 from 26bits to 28bits
    assign Shif_left_26_out = Aux << 2;

endmodule