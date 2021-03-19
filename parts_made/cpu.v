module cpu(
    input wire clock,
    input wire reset
);

// Control wires
    wire PCWrite;
    wire MemWrite;

// Data wires

    wire [31:0] ULA_out;
    wire [31:0] PC_out;
    wire [31:0] IorD_out;
    wire [31:0] SS_out;
    wire [31:0] Memory_out;
    
    Registrador PC_(
        clock,
        reset,
        PCWrite, // chart notation
        PCSource_out,
        PC_out
    );

    Memoria Memory_(
        IorD_out,
        clock,
        MemWrite, // chart notation
        SS_out,
        Memory_out
    );

endmodule