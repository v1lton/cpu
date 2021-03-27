module sign_extend_1(
    input   wire            Memory_LT_ALU, //LT from ALU
    output  wire   [31:0]   Sign_out_32 
);

    assign Sign_out_32 = {{32{1'b0}}, Memory_LT_ALU};

endmodule