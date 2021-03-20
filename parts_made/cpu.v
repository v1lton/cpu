module cpu(
    input wire clock,
    input wire reset
);

// Control wires

    wire PCWrite;
    wire MemWrite;
    wire IRWrite;
    wire RegWrite;
    wire ABWrite;
    wire [1:0] ALU_Control
    wire ALUOutControl;
    wire MDRWrite;
    wire HIWrite; // Se HIWrite e LOWrite tiverem sempre o mesmo valor, dá para criar um controle para os dois
    wire LOWrite; // Se HIWrite e LOWrite tiverem sempre o mesmo valor, dá para criar um controle para os dois
    wire [1:0] SSControl;

// ULA flags

    wire overflow;
    wire NG;
    wire ZR;
    wire EQ;
    wire GT;
    wire LT;

// Instructions subsets

    wire [5:0]  OPCODE;
    wire [4:0]  RS;
    wire [4:0]  RT;
    wire [15:0] IMMEDIATE;

// Data wires 32 bits

    wire [31:0] PCSource_out;
    wire [31:0] PC_out;
    wire [31:0] IorD_out;
    wire [31:0] SS_out;
    wire [31:0] Memory_out;
    wire [31:0] RegDst_out;
    wire [31:0] DataSrc_out;
    wire [31:0] Reg_A_out;
    wire [31:0] Reg_B_out;
    wire [31:0] ALUSrcA_out;
    wire [31:0] ALUSrcB_out;
    wire [31:0] ALU_out;
    wire [31:0] ALUOut_out;
    wire [31:0] EPC_out;
    wire [31:0] MDR_out;
    wire [31:0] Mult_Div_out;
    wire [31:0] HI_out;
    wire [31:0] LO_out;
    wire [31:0] SS_out;
    
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

    ss_control SS_(
        SSControl, // chart notation
        MDR_out,
        B_out,
        SS_out
    );

    Registrador MDR_(
        clock,
        reset,
        MDRWrite,
        Memory_out,
        MDR_out
    );

    Registrador HI_(
        clock,
        reset,
        HIWrite, // chart notation
        Mult_Div_out,
        HI_out
    );

    Registrador LO_(
        clock,
        reset,
        LOWrite, // chart notation
        Mult_Div_out,
        LO_out
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

    Registrador A_(
        clock,
        reset,
        ABWrite, 
        Reg_A_out,
        A_out
    );

    Registrador B_(
        clock,
        reset,
        ABWrite, 
        Reg_B_out,
        B_out
    );

    ula32 ALU_(
        ALUSrcA_out,
        ALUSrcB_out,
        ALU_Control,
        ALU_out, // No chart está como Result
        Overflow, // Sinaliza overflow aritmetico
        NG, // Sinaliza valor negativo
        ZR, // Sinaliza quando for zero 
        EQ, // Sinaliza se A == B
        GT, // Sinaliza de A > B
        LT  // Sinaliza se A < B
    );

    Registrador ALUOut_(
        clock,
        reset,
        ALUOutControl, // chart notation
        ALU_out,
        ALUOut_out
    );

    Registrador EPC_(
        clock,
        reset,
        EPCWrite, // chart notation
        ALU_out,
        EPC_out
    );



endmodule