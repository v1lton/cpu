module sign_extend_16(
    input   wire   [15:0]   Immediate, //Instruction [15:0] 
    output  wire   [31:0]   Sign_out_32 
);

    assign Sign_out_32 = (Immediate[15]) ? {{16{1'b1}}, Immediate} : {{16{1'b0}}, Immediate};

endmodule