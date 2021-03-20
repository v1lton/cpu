module concatenate_26to28(
    input   wire   [5:0]    RS,
    input   wire   [5:0]    RT,
    input   wire   [15:0]   Immediate, 
    output  wire   [25:0]   Concatenated_26
);

    assign Concatenated_26 = {RS, RT, Immediate};

endmodule