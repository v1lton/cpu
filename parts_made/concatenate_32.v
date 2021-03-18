module concatenate_32(
    input   wire   [3:0]    PC,
    input   wire   [27:0]   Shift_left_out,
    output  wire   [32:0]   Concatenated_32
);

    assign Concatenated_26 = {PC, Shift_left_out};

endmodule