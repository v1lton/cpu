module shift_left_16(
    input   wire    [15:0]  Immediate,
    output  wire    [31:0]  Shif_left_16_out
);

    wire [31:0] Aux;

    assign Aux = {{16{1'b0}}, Immediate}; //Extends Immediate from 16bits to 32bits
    assign Shif_left_16_out = Aux << 16;

endmodule