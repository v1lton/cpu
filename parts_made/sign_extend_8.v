module sign_extend_8(
    input   wire   [7:0]   Memory_data, //Memory output
    output  wire   [31:0]   Sign_out_32 
);

    assign Sign_out_32 = (Memory_data[7]) ? {{24{1'b1}}, Memory_data} : {{24{1'b0}}, Memory_data}; //Extending with signal

endmodule