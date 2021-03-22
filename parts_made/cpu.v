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
    wire [2:0] ALU_Control
    wire ALUOutControl;
    wire MDRWrite;
    wire HIWrite; // Se HIWrite e LOWrite tiverem sempre o mesmo valor, dá para criar um controle para os dois
    wire LOWrite; // Se HIWrite e LOWrite tiverem sempre o mesmo valor, dá para criar um controle para os dois
    wire ALUSrcA;
    wire ALUSrcB;
    wire [2:0] RegDst;
    wire [1:0] SSControl;
    wire [2:0] ShiftControl;
    wire [2:0] IorD;
    wire [2:0] PCSource
    wire [1:0] ExcpCtrl;
    wire ShiftAmt;
    wire L5Control;
    wire EPCWrite;
    wire [3:0] DataSrc;
    wire ShiftSrc;

// ULA flags

    wire overflow; // controller /////////////////////////////////////////////
    wire NG;
    wire ZR;
    wire EQ; // controler /////////////////////////////////////////////
    wire GT; // controler /////////////////////////////////////////////
    wire LT; // controler /////////////////////////////////////////////

// Instructions subsets

    wire [5:0]  OPCODE; // controler /////////////////////////////////////////////
    wire [4:0]  RS;
    wire [4:0]  RT;
    wire [15:0] IMMEDIATE; // controler /////////////////////////////////////////////

// Data wires less 32 bits
    wire [25:0] Concatenated_26to28_out;
    wire [27:0] Shift_left_26_out;

// Data wires 32 bits

    wire [31:0] PCSource_out;
    wire [31:0] PC_out;
    wire [31:0] I_or_D_Out;
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
    wire [31:0] Concatenated_28to32_out;
    wire [31:0] Sign_extend_1to32_out;
    wire [31:0] Sign_extend_8to32_out;
    wire [31:0] Sign_extend_16to32_out;
    wire [31:0] Shift_left_16_out;
    wire [31:0] Shift_left_mult_4_out;  
    wire [31:0] Shift_src_out;
    wire [31:0] Shift_amt_out;
    wire [31:0] Shift_reg_out;
    wire [31:0] L5Control_out;
    wire [31:0] Excp_out;

// Memory

    Memoria Memory_(
        I_or_D_Out,
        clock,
        MemWrite, // chart notation
        SS_out,
        Memory_out
    );

// Controls
    ss_control SS_(
        SSControl, // chart notation
        MDR_out,
        B_out,
        SS_out
    );

    L5_control L5_control(
        MDR_out,
        L5Control,
        L5Control_out
    );

// ALU

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

// Concatenations

    concatenate_26to28 Concatenate_26to28_(
        RS,
        RT,
        IMMEDIATE,
        Concatenated_26to28_out
    );

    concatenate_28to32 Concatenate_28to32_(
        PC_out,
        Shift_left_26_out,
        Concatenated_28to32_out
    );

// Sign Extend

    sign_extend_1 Sign_extend_1_(
        LT,
        Sign_extend_1to32_out
    );

    sign_extend_8 Sign_extend_8_(
        Memory_out,
        Sign_extend_8to32_out
    );

    sign_extend_16 Sign_extend_16_(
        IMMEDIATE,
        Sign_extend_16to32_out
    );

// Shifts

    shift_left_16 Shift_left_16_(
        IMMEDIATE,
        Shift_left_16_out
    );

    shift_left_26 Shift_left_26_(
        Concatenated_26to28_out,
        Shift_left_26_out
    );

    shift_left_mult_4 Shift_left_mult_4_(
        PC_out,
        Shift_left_mult_4_out
    );

    shift_reg Shift_reg_(
        ShiftControl, // chart notation
        Shift_src_out,
        Shift_amt_out,
        Shift_reg_out
    );

// Registers

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
    
    Registrador PC_(
        clock,
        reset,
        PCWrite, // chart notation
        PCSource_out,
        PC_out
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

    //Muxes

    alu_src_a Alu_Src_A(
        ALUSrcA,
        PC_Out,
        Reg_A_out,
        MDR_out,
        ALUSrcA_out
    );

    alu_src_b Alu_Src_B(
        ALUSrcB,
        B_out,
        Shift_left_16_out,
        Shift_left_mult_4_out,
        ALUSrcB_out
    );

    data_source DataSource( //Tem que mudar alguma coisa
        DataSrc,
        ALU_out, 
        L5Control_out,
        HI_out,
        LO_out,
        Sign_extend_1to32_out, 
        Sign_extend_16to32_out,
        Shif_left_16_out, 
        Shift_reg_out, 
        ALUSrcA_out,
        ALUSrcB_out,
        DataSrc_out
    );

    I_or_D I_or_D(
        PC_out,
        ALU_out,
        ALUOut_out,
        Excp_out,
        Reg_A_out,
        IorD,
        I_or_D_Out
    );

    ExceptionsCtrl ExceptionsCtrl(
        ExcpCtrl,
        Excp_out
    );

    shift_amt shift_amt(
        Reg_B_out,
        IMMEDIATE,
        ShiftAmt,
        shift_amt_out
    );

    pc_source PCSource(
        MDR_Out,
        ALU_out,
        Concatenated_28to32_out, 
        ALUOut_out,
        EPC_out,
        Excp_out,
        PCSource,
        PCSource_out
    );

    shift_src shift_src(
        ALUSrcA_out,
        ALUSrcB_out,
        ShiftSrc
    );

    reg_dst Reg_Dst(
        RS,
        RT,
        IMMEDIATE, 
        RegDst,
        RegDst_out
    );
    

endmodule