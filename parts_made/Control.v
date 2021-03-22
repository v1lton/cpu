module Control(
  //input clock,
  //input reset,
  output reg PCWrite, // ok
  output reg MemWrite, //ok
  output reg IRWrite, //ok
  output reg RegWrite, //ok
  output reg ABWrite, // PERGUNTAR PARA A WILTON
  output reg [2:0] ALU_Control //OK
  output reg ALUOutControl, //OK
  output reg MDRWrite, // PERGUNTAR PARA A WILTON (N TEM NO DIAGRAMA)
  output reg HIWrite, // Se HIWrite e LOWrite tiverem sempre o mesmo valor, dá para criar um controle para os dois
  output reg LOWrite, // Se HIWrite e LOWrite tiverem sempre o mesmo valor, dá para criar um controle para os dois
  output reg ALUSrcA, //OK
  output reg ALUSrcB, //OK
  output reg [2:0] RegDst, //OK
  output reg [1:0] SSControl, //OK
  output reg [2:0] ShiftControl, //OK
  output reg [2:0] IorD, //OK
  output reg [2:0] PCSource //OK
  output reg [1:0] ExcpCtrl, //OK
  output reg ShiftAmt, //OK
  output reg L5Control, //OK
  output reg EPCWrite, //OK
  output reg [3:0] DataSrc, //OK
  output reg ShiftSrc, //OK

  //inputs
  input wire [5:0] Opcode,
  input wire [5:0] Funct,
  input wire EQ,
  input wire GT,
  input wire LT,
  input wire overflow, // NÃO TEM NO DIAGRAMA

);

  // parameters dos estados (as bolinhas)
  parameter RESET = 7'b0000000; // 0
  parameter FETCH_1 = 7'b0000001; // 1
  parameter FETCH_2 = 7'b0000010; // 2
  parameter FETCH_3 = 7'b0000011; // 3
  parameter DECODE_1 = 7'b0000100; // 4
  parameter DECODE_2 = 7'b0000101; // 5
  parameter ADD = 7'b0000110; // 6
  parameter SUB = 7'b0000111; // 7
  parameter AND = 7'b0001000; // 8
  parameter ADD_SUB_AND = 7'b0001001; // 9
  parameter MULT_1 = 7'b0001010; // 10
  parameter MULT_WAIT = 7'b0001011; // 11
  parameter MULT_2 = 7'b0001100; // 12
  parameter DIV1 = 7'b0001101; // 13
  parameter DIV_WAIT = 7'b0001110; // 14
  parameter DIV2 = 7'b0001111; // 15
  parameter MFHI = 7'b0010000; // 16
  parameter MFLO = 7'b0010001; // 17
  parameter SHIFT_SHAMT = 7'b0010010; // 18
  parameter SLL = 7'b0010011; // 19
  parameter SRA = 7'b0010100; // 20
  parameter SRL = 7'b0010101; // 21
  parameter SLL_SRA_SRL = 7'b0010110; // 22
  parameter SHIFT_REG = 7'b0010111; // 23
  parameter SRAV = 7'b0011000; // 24
  parameter SLLV = 7'b0011001; // 25
  parameter SRAV_SLLV = 7'b0011010; // 26
  parameter JR = 7'b0011011; // 27
  parameter SLT = 7'b0011100; // 28
  parameter BREAK_1 = 7'b0011101; // 29
  parameter BREAK_2 = 7'b0011110; // 30
  parameter RTE = 7'b0011111; // 31
  parameter XCHG_1 = 7'b0100000; // 32
  parameter XCHG_2 = 7'b0100001; // 33
  parameter CLOSE_WRITE = 7'b0100010; // 34
  parameter OVERFLOW_1 = 7'b0100011; // 35
  parameter OVERFLOW_WAIT_1 = 7'b0100100; // 36
  parameter OVERFLOW_WAIT_2 = 7'b0100101; // 37
  parameter OVERFLOW_2 = 7'b0100110; // 38
  parameter OPCODEI = 7'b0100111 //39
  parameter OPCODEI_WAIT_1 = 7'b0101000 //40
  parameter OPCODEI_WAIT_2 = 7'b0101001 //41
  parameter OPCODEI_2 = 7'b0101010 //42
  parameter DIVBY0 = 7'b0101011 //43
  parameter DIVBY0_WAIT_1 = 7'b0101100 //44
  parameter DIVBY0_WAIT_2 = 7'b0101101 //45
  parameter DIVBY0_2 = 7'b0101110 //46
  parameter J = 7'b0101111 //47
  parameter JAL_1 = 7'b0110000 //48
  parameter JAL_2 = 7'b0110001 //49
  parameter JAL_3 = 7'b0110010 //50
  parameter SW_SH_SB_1 = 7'b0110011 //51
  parameter SW_SH_SB_WAIT = 7'b0110100 //52
  parameter SW_SH_SB_WAIT_2 = 7'b0110101 //53
  parameter SW = 7'b0110110 //54
  parameter SH = 7'b0110111 //55
  parameter SB = 7'b0111000 //56
  parameter LW_LH_LB_1 = 7'b0111001 //57
  parameter LW_LH_LB_WAIT_1 = 7'b0111010 //58
  parameter LW_LH_LB_WAIT_2 = 7'b0111011 //59
  parameter LW = 7'b0111100 //60
  parameter LH = 7'b0111101 //61
  parameter LB = 7'b0111110 //62
  parameter LUI = 7'b0111111 //63
  parameter BLM_1 = 7'b1000000 //64
  parameter BLM_2_WAIT = 7'b1000001 //65
  parameter BLM_3_WAIT = 7'b1000010 //66
  parameter BLM_4 = 7'b1000011 //67
  parameter SLTI = 7'b1000100 //68
  parameter BGT_BLE = 7'b1000101 //69
  parameter BGT_BLE_2 = 7'b1000110 //70
  parameter BEQ_BNE = 7'b1000111 //71
  parameter BEQ_BNE_2 = 7'b1001000 //72
  parameter ADDI_ADDIU = 7'b1001001 //73
  parameter ADDI = 7'b1001010 //74
  parameter ADDIU = 7'b1001011 //75
  parameter CLOSE_WRITE = 7'b1001100 //76
  parameter WAIT = 7'b1001101 //77
  
  // parameters do Opcode
  parameter RINSTRUCTION = 6'b000000;
  parameter ADDI = 6'b001000;
  parameter ADDIU = 6'b001001;
  parameter BEQ = 6'b000100;
  parameter BNE = 6'b000101;
  parameter BLE = 6'b000110;
  parameter BGT = 6'b000111;
  parameter BLM = 6'b000001;
  parameter LB = 6'b100000;
  parameter LH = 6'b100001;
  parameter LUI = 6'b001111;
  parameter LW = 6'b100011;
  parameter SB = 6'b101000;
  parameter SH = 6'b101001;
  parameter SLTI = 6'b001010;
  parameter SW = 6'b101011;
  parameter J = 6'b000010;
  parameter JAL = 6'b000011;

  // parameters do Funct
  parameter ADD = 6'b100000;
  parameter AND = 6'b100100;
  parameter DIV = 6'b011010;
  parameter MULT = 6'b011000;
  parameter JR = 6'b001000;
  parameter MFHI = 6'b010000;
  parameter MFLO = 6'b010010;
  parameter SLL = 6'b000000;
  parameter SLLV = 6'b000100;
  parameter SLT = 6'b101010;
  parameter SRA = 6'b000011;
  parameter SRAV = 6'b000111;
  parameter SRL = 6'b000010;
  parameter SUB = 6'b100010;
  parameter BREAK = 6'b001101;
  parameter RTE = 6'b010011;
  parameter XCHG = 6'b000101;

endmodule