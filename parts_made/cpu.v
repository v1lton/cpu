module cpu(
    input wire clock,
    input wire reset
);

// Control wires
    wire PCWrite;
    wire MemWrite;
    wire IRWrite;

// Data wires

    wire [31:0] ULA_out;
    wire [31:0] PC_out;
    wire [31:0] IorD_out;
    wire [31:0] SS_out;
    wire [31:0] Memory_out;
    wire [5:0]  OPCODE;
    wire [4:0]  RS;
    wire [4:0]  RT;
    wire [15:0] IMMEDIATE;
    
    Registrador PC_(
        clock,
        reset,
        PCWrite, // chaRT notation
        PCSource_out,
        PC_out
    );

    Memoria Memory_(
        IorD_out,
        clock,
        MemWrite, // chaRT notation
        SS_out,
        Memory_out
    );

    Instr_Reg IR_(
        clock,
        reset,
        IRWrite, // chaRT notation        
        Memory_out,
        OPCODE,
        RS,
        RT,
        IMMEDIATE
    );

endmodule