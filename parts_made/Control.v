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
  output reg [1:0] ALUSrcA, //OK
  output reg [1:0] ALUSrcB, //OK
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
  parameter OPERAR = 7'b0100010; // 34
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
  parameter ADDI_O = 6'b001000;
  parameter ADDIU_O = 6'b001001;
  parameter BEQ_O = 6'b000100;
  parameter BNE_O = 6'b000101;
  parameter BLE_O = 6'b000110;
  parameter BGT_O = 6'b000111;
  parameter BLM_O = 6'b000001;
  parameter LB_O = 6'b100000;
  parameter LH_O = 6'b100001;
  parameter LUI_O = 6'b001111;
  parameter LW_O = 6'b100011;
  parameter SB_O = 6'b101000;
  parameter SH_O = 6'b101001;
  parameter SLTI_O = 6'b001010;
  parameter SW_O = 6'b101011;
  parameter J_O = 6'b000010;
  parameter JAL_O = 6'b000011;

  // parameters do Funct
  parameter ADD_F = 6'b100000;
  parameter AND_F = 6'b100100;
  parameter DIV_F = 6'b011010;
  parameter MULT_F = 6'b011000;
  parameter JR_F = 6'b001000;
  parameter MFHI_F = 6'b010000;
  parameter MFLO_F = 6'b010010;
  parameter SLL_F = 6'b000000;
  parameter SLLV_F = 6'b000100;
  parameter SLT_F = 6'b101010;
  parameter SRA_F = 6'b000011;
  parameter SRAV_F = 6'b000111;
  parameter SRL_F = 6'b000010;
  parameter SUB_F = 6'b100010;
  parameter BREAK_F = 6'b001101;
  parameter RTE_F = 6'b010011;
  parameter XCHG_F = 6'b000101;

reg[6:0] state;

  initial begin
    state = FETCH_1;
  end

  always @(posedge clock) begin
    if(reset) begin
    	//Alteradas
			RegDst = 3'b010;
			DataSrc = 4'b0111;
			RegWrite = 1'b1;
			//Inalteradas                
      PCWrite = 1'b0;
      MemWrite = 1'b0;
      IRWrite = 1'b0;
      ABWrite = 1'b0;
      ALU_Control = 3'b000;
      ALUOutControl = 1'b0;
      MDRWrite = 1'b0;
      HIWrite = 1'b0;
      LOWrite = 1'b0;
      ALUSrcA = 2'b00;
      ALUSrcB = 2'b00;
      SSControl = 2'b00;
      ShiftControl = 3'b000;
      IorD = 3'b000;
      PCSource = 3'b000;
      ExcpCtrl = 2'b00;
      ShiftAmt = 1'b0;
      L5Control = 1'b0;
      EPCWrite = 1'b0;
      ShiftSrc = 1'b0;
			state = FETCH_1;
    end else begin
      case (state)
        FETCH_1: begin
        //Alteradas
		 ALUSrcB = 2'b01;
		 ALU_Control = 3'b001;
		//Inalteradas
          RegDst = 3'b000;
		  DataSrc = 4'b0000;
		  RegWrite = 1'b0;                
          PCWrite = 1'b0;
          MemWrite = 1'b0;
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          ALU_Control = 3'b000;
          ALUOutControl = 1'b0;
          MDRWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          ALUSrcA = 2'b00;
          SSControl = 2'b00;
          ShiftControl = 3'b000;
          IorD = 3'b000;
          PCSource = 3'b000;
          ExcpCtrl = 2'b00;
          ShiftAmt = 1'b0;
          L5Control = 1'b0;
          EPCWrite = 1'b0;
          ShiftSrc = 1'b0;
			    state = FETCH_2;
        end
        FETCH_2: begin
           //Alteradas
           PCWrite = 1'b1;
           //Inalteradas
          ALUSrcB = 2'b01;
		  ALU_Control = 3'b001;
          RegDst = 3'b000;
		  DataSrc = 4'b0000;
		  RegWrite = 1'b0;                
          MemWrite = 1'b0;
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          ALU_Control = 3'b000;
          ALUOutControl = 1'b0;
          MDRWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          ALUSrcA = 2'b00;
          SSControl = 2'b00;
          ShiftControl = 3'b000;
          IorD = 3'b000;
          PCSource = 3'b000;
          ExcpCtrl = 2'b00;
          ShiftAmt = 1'b0;
          L5Control = 1'b0;
          EPCWrite = 1'b0;
          ShiftSrc = 1'b0;
          state = FETCH_3;
           
         
            
        end
        FETCH_3: begin
          //Alteradas
          PCWrite = 1'b0;
          IRWrite = 1'b1;
          //Inalteradas
          ALUSrcB = 2'b01;
		  ALU_Control = 3'b001;
          RegDst = 3'b000;
		  DataSrc = 4'b0000;
		  RegWrite = 1'b0;                
          MemWrite = 1'b0; /////////////////////////// REVER ISSO
          ABWrite = 1'b0;
          ALU_Control = 3'b000;
          ALUOutControl = 1'b0;
          MDRWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          ALUSrcA = 2'b00;
          SSControl = 2'b00;
          ShiftControl = 3'b000;
          IorD = 3'b000;
          PCSource = 3'b000;
          ExcpCtrl = 2'b00;
          ShiftAmt = 1'b0;
          L5Control = 1'b0;
          EPCWrite = 1'b0;
          ShiftSrc = 1'b0;
          state = DECODE_1;

        end
        DECODE_1: begin
          //Alteradas
          ALUSrcB = 2'b11;
          ALU_Control = 3'b001;
          ALUOutControl = 1'b1;
          IRWrite = 1'b0;
		  //Inalteradas
          RegDst = 3'b000;
		  DataSrc = 4'b0000;
		  RegWrite = 1'b0;                
          PCWrite = 1'b0;
          MemWrite = 1'b0;
          ABWrite = 1'b0;
          MDRWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          ALUSrcA = 2'b00;
          SSControl = 2'b00;
          ShiftControl = 3'b000;
          IorD = 3'b000;
          PCSource = 3'b000;
          ExcpCtrl = 2'b00;
          ShiftAmt = 1'b0;
          L5Control = 1'b0;
          EPCWrite = 1'b0;
          ShiftSrc = 1'b0;
		  state = DECODE_2;
        end
        DECODE_2: begin
          //Alteradas
          ALUOutControl = 1'b0;
		  //Inalteradas
          ALU_Control = 3'b000;
          ALUSrcB = 2'b00;
          RegDst = 3'b000;
		  DataSrc = 4'b0000;
		  RegWrite = 1'b0;                
          PCWrite = 1'b0;
          MemWrite = 1'b0;
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          MDRWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          ALUSrcA = 2'b00;
          SSControl = 2'b00;
          ShiftControl = 3'b000;
          IorD = 3'b000;
          PCSource = 3'b000;
          ExcpCtrl = 2'b00;
          ShiftAmt = 1'b0;
          L5Control = 1'b0;
          EPCWrite = 1'b0;
          ShiftSrc = 1'b0;
          case(OPCODE)
            RINSTRUCTION: begin
              
            end;
            ADDI_O: begin
              state = ADDI_ADDIU;
            end
            ADDIU_O: begin
              state = ADDI_ADDIU;
            end
            BEQ_O = 6'b000100;
            BNE_O = 6'b000101;
            BLE_O = 6'b000110;
            BGT_O = 6'b000111;
            BLM_O = 6'b000001;
            LB_O = 6'b100000;
            LH_O = 6'b100001;
            LUI_O = 6'b001111;
            LW_O = 6'b100011;
            SB_O = 6'b101000;
            SH_O = 6'b101001;
            SLTI_O = 6'b001010;
            SW_O = 6'b101011;
            J_O = 6'b000010;
            JAL_O = 6'b000011;
          endcase
			    state = OPERAR;
        end
        OPERAR: begin
          case(OPCODE)
            ADDI_O: begin
              //Alteradas
              ALU_Control = 3'b001;
              ALUOutControl = 1'b1;
              ALUSrcB = 2'b10;
              ALUSrcA = 2'b01;
			        //Inalteradas
              RegDst = 3'b000;
			        DataSrc = 4'b0000;
			        RegWrite = 1'b0;                
              PCWrite = 1'b0;
              MemWrite = 1'b0;
              IRWrite = 1'b0;
              ABWrite = 1'b0;
              MDRWrite = 1'b0;
              HIWrite = 1'b0;
              LOWrite = 1'b0;
              SSControl = 2'b00;
              ShiftControl = 3'b000;
              IorD = 3'b000;
              PCSource = 3'b000;
              ExcpCtrl = 2'b00;
              ShiftAmt = 1'b0;
              L5Control = 1'b0;
              EPCWrite = 1'b0;
              ShiftSrc = 1'b0;
			        state = OPERAR;
            end

            
          
          endcase
        end
        ADD: begin
            //Alterdas
            
        end
        SUB: begin
        end
        AND: begin
        end
        ADD_SUB_AND: begin
        end
        MULT_1: begin
        end
        MULT_WAIT: begin
        end
        MULT_2: begin
        end
        DIV1: begin
        end
        DIV_WAIT: begin
        end
        DIV2: begin
        end
        MFHI: begin
        end
        MFLO: begin
        end
        SHIFT_SHAMT: begin
        end
        SLL: begin
        end
        SRA: begin
        end
        SRL: begin
        end
        SLL_SRA_SRL: begin
        end
        SHIFT_REG: begin
        end
        SRAV: begin
        end
        SLLV: begin
        end
        SRAV_SLLV: begin
        end
        JR: begin
        end
        SLT: begin
        end
        BREAK_1: begin
        end
        BREAK_2: begin
        end
        RTE: begin
        end
        XCHG_1: begin
        end
        XCHG_2: begin
        end
        CLOSE_WRITE: begin
        end
        OVERFLOW_1: begin
        end
        OVERFLOW_WAIT_1: begin
        end
        OVERFLOW_WAIT_2: begin
        end
        OVERFLOW_2: begin
        end
        OPCODEI: begin
        end
        OPCODEI_WAIT_1: begin
        end
        OPCODEI_WAIT_2: begin
        end
        OPCODEI_2: begin
        end
        DIVBY0: begin
        end
        DIVBY0_WAIT_1: begin
        end
        DIVBY0_WAIT_2: begin
        end
        DIVBY0_2: begin
        end
        J: begin
        end
        JAL_1: begin
        end
        JAL_2: begin
        end
        JAL_3: begin
        end
        SW_SH_SB_1: begin
        end
        SW_SH_SB_WAIT: begin
        end
        SW_SH_SB_WAIT_2: begin
        end
        SW: begin
        end
        SH: begin
        end
        SB: begin
        end
        LW_LH_LB_1: begin
        end
        LW_LH_LB_WAIT_1: begin
        end
        LW_LH_LB_WAIT_2: begin
        end
        LW: begin
        end
        LH: begin
        end
        LB: begin
        end
        LUI: begin
        end
        BLM_1: begin
        end
        BLM_2_WAIT: begin
        end
        BLM_3_WAIT: begin
        end
        BLM_4: begin
        end
        SLTI: begin
        end
        BGT_BLE: begin
        end
        BGT_BLE_2: begin
        end
        BEQ_BNE: begin
        end
        BEQ_BNE_2: begin
        end
        ADDI_ADDIU: begin
        end
        ADDIU: begin
        end
        WAIT: begin
        end
      endcase
    end
  end

endmodule