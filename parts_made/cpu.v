module cpu(
    input wire clock,
    input wire reset
);

// Control wires

    wire PCWrite;
    wire MemWrite;
    wire IRWrite;
    wire RegWrite;
    wire AWrite;
    wire BWrite;

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
    wire [31:0] RegDst_out;
    wire [31:0] DataSrc_out;
    wire [31:0] Reg_A_out;
    wire [31:0] Reg_B_out;
    
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

    Instr_Reg IR_(
        clock,
        reset,
        IRWrite, // chart notation        
        Memory_out,
        OPCODE,
        RS,
        RT,
        IMMEDIATE
    );

    Banco_reg Reg_Base_(
        clock,
        reset,
        RegWrite, // chart notation
        RS,
        RT,
        RegDst_out,
        DataSrc_out,
        Reg_A_out,
        Reg_B_out
    );

    Memoria A_(
        clock,
        reset,
        AWrite, 
        Reg_A_out,
        A_out
    );

    Memoria B_(
        clock,
        reset,
        BWrite, 
        Reg_B_out,
        B_out
    );

endmodule