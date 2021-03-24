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
  output reg [1:0] L5Control, //OK
  output reg EPCWrite, //OK
  output reg [3:0] DataSrc, //OK
  output reg ShiftSrc, //OK

  //inputs
  input wire [5:0] Opcode,
  input wire [5:0] Funct,
  input wire EQ,
  input wire GT,
  input wire LT,
  input wire Overflow, // NÃO TEM NO DIAGRAMA

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
  parameter DIV_1 = 7'b0001101; // 13
  parameter DIV_WAIT = 7'b0001110; // 14
  parameter DIV_2 = 7'b0001111; // 15
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
      L5Control = 2'b00;
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
          L5Control = 2'b00;
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
          L5Control = 2'b00;
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
          L5Control = 2'b00;
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
          ABWrite = 1'b1;
		  //Inalteradas
          RegDst = 3'b000;
		      DataSrc = 4'b0000;
		      RegWrite = 1'b0;                
          PCWrite = 1'b0;
          MemWrite = 1'b0;
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
          L5Control = 2'b00;
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
          L5Control = 2'b00;
          EPCWrite = 1'b0;
          ShiftSrc = 1'b0;
          case(Opcode)
            RINSTRUCTION: begin
              case(Funct)
                ADD_F: begin
                  state = ADD;
                end
                AND_F: begin
                  state = AND;
                end
                DIV_F: begin
                  state = DIV_1;
                end
                MULT_F: begin
                  state = MULT_1;
                end
                JR_F: begin
                  state = JR;
                end
                MFHI_F: begin
                  state = MFHI;
                end
                MFLO_F: begin
                  state = MFLO;
                end
                SLL_F: begin
                  state = SHIFT_SHAMT;
                end
                SLLV_F: begin
                  state = SHIFT_REG;
                end
                SLT_F: begin
                  state = SLT;
                end
                SRA_F: begin
                  state = SHIFT_SHAMT;
                end
                SRAV_F: begin
                  state = SHIFT_REG;
                end
                SRL_F: begin
                  state = SHIFT_SHAMT;
                end
                SUB_F: begin
                  state = SUB;
                end
                BREAK_F: begin
                  state = BREAK_1;
                end
                RTE_F: begin
                  state = RTE;
                end
                XCHG_F: begin
                  state = XCHG_1;
                end
              endcase
            end;
            ADDI_O: begin
              state = ADDI_ADDIU;
            end
            ADDIU_O: begin
              state = ADDI_ADDIU;
            end
            BEQ_O: begin
              state = BEQ_BNE;
            end
            BNE_O:begin
              state = BEQ_BNE;
            end
            BLE_O: begin
              state = BGT_BLE;
            end
            BGT_O: begin
              state = BGT_BLE;
            end
            BLM_O: begin
              state = BLM_1;
            end
            LB_O: begin
              state = LW_LH_LB_1;
            end
            LH_O: begin
              state = LW_LH_LB_1;
            end
            LUI_O: begin
              state = LUI;
            end
            LW_O: begin
              state = LW_LH_LB_1;
            end
            SB_O: begin
              state = SW_SH_SB_1;
            end
            SH_O: begin
              state = SW_SH_SB_1;
            end
            SLTI_O: begin
              state = SLTI;
            end
            SW_O: begin
              state = SW_SH_SB_1;
            end
            J_O: begin
              state = J;
            end
            JAL_O: begin
              state = JAL_1;
            end
            default: begin
              state = OPCODEI;
            end
          endcase
        end
        ADD: begin
          //Alteradas
          ALUSrcA = 2'b01;
          ALU_Control = 3'b001;
          ALUOutControl = 1'b1;
		      //Inalteradas
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
          SSControl = 2'b00;
          ShiftControl = 3'b000;
          IorD = 3'b000;
          PCSource = 3'b000;
          ExcpCtrl = 2'b00;
          ShiftAmt = 1'b0;
          L5Control = 2'b00;
          EPCWrite = 1'b0;
          ShiftSrc = 1'b0;
          state = ADD_SUB_AND;
        end
        SUB: begin      
          //Alteradas
          ALUSrcA = 2'b01;
          ALU_Control = 3'b010;
          ALUOutControl = 1'b1;
		      //Inalteradas
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
          SSControl = 2'b00;
          ShiftControl = 3'b000;
          IorD = 3'b000;
          PCSource = 3'b000;
          ExcpCtrl = 2'b00;
          ShiftAmt = 1'b0;
          L5Control = 2'b00;
          EPCWrite = 1'b0;
          ShiftSrc = 1'b0;
          state = ADD_SUB_AND;
        end
        AND: begin
          //Alteradas
          ALUSrcA = 2'b01;
          ALU_Control = 3'b011;
          ALUOutControl = 1'b1;
		      //Inalteradas
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
          SSControl = 2'b00;
          ShiftControl = 3'b000;
          IorD = 3'b000;
          PCSource = 3'b000;
          ExcpCtrl = 2'b00;
          ShiftAmt = 1'b0;
          L5Control = 2'b00;
          EPCWrite = 1'b0;
          ShiftSrc = 1'b0;
          state = ADD_SUB_AND;
        end
        ADD_SUB_AND: begin 
          if (Overflow) begin
            state = OVERFLOW_1;
          end
          else begin
          //Alteradas
	        RegWrite = 1'b1;
          RegDst = 3'b001;           
	        //Inalteradas
          ALUOutControl = 1'b0;
          ALU_Control = 3'b000;
          ALUSrcB = 2'b00;
	        DataSrc = 4'b0000;               
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
          L5Control = 2'b00;
          EPCWrite = 1'b0;
          ShiftSrc = 1'b0;
	        state = CLOSE_WRITE;
          end
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
          //Alteradas
          DataSrc = 4'b0010;
          RegDst = 3'b001;
          RegWrite = 1'b1;
	        //Inalteradas
          ALUOutControl = 1'b0;
          ALU_Control = 3'b000;
          ALUSrcB = 2'b00;               
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
          L5Control = 2'b00;
          EPCWrite = 1'b0;
          ShiftSrc = 1'b0;
	        state = CLOSE_WRITE;
        end
        MFLO: begin
          //Alteradas
          DataSrc = 4'b0011;
          RegDst = 3'b001;
          RegWrite = 1'b1;
	        //Inalteradas
          ALUOutControl = 1'b0;
          ALU_Control = 3'b000;
          ALUSrcB = 2'b00;               
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
          L5Control = 2'b00;
          EPCWrite = 1'b0;
          ShiftSrc = 1'b0;
	        state = CLOSE_WRITE;
        end
        SHIFT_SHAMT: begin
          //Alteradas
          ShiftAmt = 1'b1;
          ShiftControl = 3'b001;
          ShiftSrc = 1'b1;
	        //Inalteradas
          ALUOutControl = 1'b0;
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
          IorD = 3'b000;
          PCSource = 3'b000;
          ExcpCtrl = 2'b00;
          L5Control = 2'b00;
          EPCWrite = 1'b0;
	        case(funct)
            SLL_F: begin
              state = SLL;
            end
            SRA_F: begin
              state = SRA;
            end
            SRL_F: begin
              state = SRL;
            end
          endcase
        end
        SLL: begin
          //Alteradas
          ShiftControl = 3'b010;
	        //Inalteradas
          ShiftAmt = 1'b0;
          ShiftSrc = 1'b0;
          ALUOutControl = 1'b0;
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
          IorD = 3'b000;
          PCSource = 3'b000;
          ExcpCtrl = 2'b00;
          L5Control = 2'b00;
          EPCWrite = 1'b0;
          state = SLL_SRA_SRL;
        end
        SRA: begin
          //Alteradas
          ShiftControl = 3'b100;
	        //Inalteradas
          ShiftAmt = 1'b0;
          ShiftSrc = 1'b0;
          ALUOutControl = 1'b0;
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
          IorD = 3'b000;
          PCSource = 3'b000;
          ExcpCtrl = 2'b00;
          L5Control = 2'b00;
          EPCWrite = 1'b0;
          state = SLL_SRA_SRL;
        end
        SRL: begin
          //Alteradas
          ShiftControl = 3'b011;
	        //Inalteradas
          ShiftAmt = 1'b0;
          ShiftSrc = 1'b0;
          ALUOutControl = 1'b0;
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
          IorD = 3'b000;
          PCSource = 3'b000;
          ExcpCtrl = 2'b00;
          L5Control = 2'b00;
          EPCWrite = 1'b0;
          state = SLL_SRA_SRL;
        end
        SLL_SRA_SRL: begin
          //Alteradas
          DataSrc = 4'b1000;
          RegDst = 3'b001;
          RegWrite = 1'b1;
	        //Inalteradas
          ShiftControl = 3'b000;
          ShiftAmt = 1'b0;
          ShiftSrc = 1'b0;
          ALUOutControl = 1'b0;
          ALU_Control = 3'b000;
          ALUSrcB = 2'b00;               
          PCWrite = 1'b0;
          MemWrite = 1'b0;
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          MDRWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          ALUSrcA = 2'b00;
          SSControl = 2'b00;
          IorD = 3'b000;
          PCSource = 3'b000;
          ExcpCtrl = 2'b00;
          L5Control = 2'b00;
          EPCWrite = 1'b0;
          state = CLOSE_WRITE;
        end
        SHIFT_REG: begin
          //Alteradas
          ShiftAmt = 1'b0;
          ShiftControl = 3'b001;
          ShiftSrc = 1'b0;
	        //Inalteradas
          ALUOutControl = 1'b0;
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
          IorD = 3'b000;
          PCSource = 3'b000;
          ExcpCtrl = 2'b00;
          L5Control = 2'b00;
          EPCWrite = 1'b0;
          case(funct)
            SRAV_F: begin
              state = SRAV;
            end
            SLLV_F: begin
              state = SLLV;
            end
          endcase 
        end
        SRAV: begin
          //Alteradas
          ShiftControl = 3'b100;
	        //Inalteradas
          ShiftAmt = 1'b0;
          ShiftSrc = 1'b0;
          ALUOutControl = 1'b0;
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
          IorD = 3'b000;
          PCSource = 3'b000;
          ExcpCtrl = 2'b00;
          L5Control = 2'b00;
          EPCWrite = 1'b0;
          state = SRAV_SLLV;
        end
        SLLV: begin
          //Alteradas
          ShiftControl = 3'b010;
	        //Inalteradas
          ShiftAmt = 1'b0;
          ShiftSrc = 1'b0;
          ALUOutControl = 1'b0;
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
          IorD = 3'b000;
          PCSource = 3'b000;
          ExcpCtrl = 2'b00;
          L5Control = 2'b00;
          EPCWrite = 1'b0;
          state = SRAV_SLLV;
        end
        SRAV_SLLV: begin
          //Alteradas
          RegDst = 3'b001;
          DataSrc = 4'b1000;
          RegWrite = 1'b1; 
	        //Inalteradas
          ShiftAmt = 1'b0;
          ShiftControl = 3'b000;
          ShiftSrc = 1'b0;
          ALUOutControl = 1'b0;
          ALU_Control = 3'b000;
          ALUSrcB = 2'b00;                
          PCWrite = 1'b0;
          MemWrite = 1'b0;
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          MDRWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          ALUSrcA = 2'b00;
          SSControl = 2'b00;
          IorD = 3'b000;
          PCSource = 3'b000;
          ExcpCtrl = 2'b00;
          L5Control = 2'b00;
          EPCWrite = 1'b0;
          state = CLOSE_WRITE;
        end
        JR: begin
          //Alteradas
          ALUSrcA = 2'b01;
          PCSource = 3'b000;
          PCWrite = 1'b1;
          ALU_Control = 3'b000;
	        //Inalteradas
          ShiftAmt = 1'b0;
          ShiftControl = 3'b000;
          ShiftSrc = 1'b0;
          ALUOutControl = 1'b0;
          ALUSrcB = 2'b00;
          RegDst = 3'b000;
	        DataSrc = 4'b0000;
	        RegWrite = 1'b0;
          MemWrite = 1'b0;
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          MDRWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          SSControl = 2'b00;
          IorD = 3'b000;
          ExcpCtrl = 2'b00;
          L5Control = 2'b00;
          EPCWrite = 1'b0;
          state = CLOSE_WRITE;
        end
        SLT: begin
          //Alteradas
          ALUSrcA = 2'b01;
          ALUSrcB = 2'b00;
          ALU_Control = 3'b111;
          RegDst = 3'b001;
          DataSrc = 4'b0100;
          RegWrite = 1'b1;
	        //Inalteradas
          ShiftAmt = 1'b0;
          ShiftControl = 3'b000;
          ShiftSrc = 1'b0;
          ALUOutControl = 1'b0;               
          PCWrite = 1'b0;
          MemWrite = 1'b0;
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          MDRWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          SSControl = 2'b00;
          IorD = 3'b000;
          PCSource = 3'b000;
          ExcpCtrl = 2'b00;
          L5Control = 2'b00;
          EPCWrite = 1'b0;
          state = CLOSE_WRITE;
        end
        BREAK_1: begin
          //Alteradas
          ALUSrcA = 2'b00;
          ALUSrcB = 2'b01;
          ALU_Control = 3'b010;
	        //Inalteradas
          ShiftAmt = 1'b0;
          ShiftControl = 3'b000;
          ShiftSrc = 1'b0;
          ALUOutControl = 1'b0;
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
          IorD = 3'b000;
          PCSource = 3'b000;
          ExcpCtrl = 2'b00;
          L5Control = 2'b00;
          EPCWrite = 1'b0;
          state = BREAK_2;
        end
        BREAK_2: begin
          //Alteradas
          PCSource = 3'b000;
          PCWrite = 1'b1;
	        //Inalteradas
          ShiftAmt = 1'b0;
          ShiftControl = 3'b000;
          ShiftSrc = 1'b0;
          ALUOutControl = 1'b0;
          ALU_Control = 3'b000;
          ALUSrcB = 2'b00;
          RegDst = 3'b000;
	        DataSrc = 4'b0000;
	        RegWrite = 1'b0;                
          MemWrite = 1'b0;
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          MDRWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          ALUSrcA = 2'b00;
          SSControl = 2'b00;
          IorD = 3'b000;
          ExcpCtrl = 2'b00;
          L5Control = 2'b00;
          EPCWrite = 1'b0;
          state = CLOSE_WRITE;
        end
        RTE: begin
          //Alteradas
          PCSource = 3'b100;
          PCWrite = 1'b1;
	        //Inalteradas
          ShiftAmt = 1'b0;
          ShiftControl = 3'b000;
          ShiftSrc = 1'b0;
          ALUOutControl = 1'b0;
          ALU_Control = 3'b000;
          ALUSrcB = 2'b00;
          RegDst = 3'b000;
	        DataSrc = 4'b0000;
	        RegWrite = 1'b0;                
          MemWrite = 1'b0;
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          MDRWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          ALUSrcA = 2'b00;
          SSControl = 2'b00;
          IorD = 3'b000;
          ExcpCtrl = 2'b00;
          L5Control = 2'b00;
          EPCWrite = 1'b0;
          state = CLOSE_WRITE;
        end
        XCHG_1: begin
          //Alteradas
	        DataSrc = 4'b1010;
          RegDst = 3'b100;
          RegWrite = 1'b1; 
          //Inalteradas
          ShiftAmt = 1'b0;
          ShiftControl = 3'b000;
          ShiftSrc = 1'b0;
          ALUOutControl = 1'b0;
          ALU_Control = 3'b000;
          ALUSrcB = 2'b00;               
          PCWrite = 1'b0;
          MemWrite = 1'b0;
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          MDRWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          ALUSrcA = 2'b00;
          SSControl = 2'b00;
          IorD = 3'b000;
          PCSource = 3'b000;
          ExcpCtrl = 2'b00;
          L5Control = 2'b00;
          EPCWrite = 1'b0;
          state = XCHG_2;
        end
        XCHG_2: begin
          //Alteradas
	        DataSrc = 4'b1001;
          RegDst = 3'b000;
          RegWrite = 1'b1; 
          //Inalteradas
          ShiftAmt = 1'b0;
          ShiftControl = 3'b000;
          ShiftSrc = 1'b0;
          ALUOutControl = 1'b0;
          ALU_Control = 3'b000;
          ALUSrcB = 2'b00;               
          PCWrite = 1'b0;
          MemWrite = 1'b0;
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          MDRWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          ALUSrcA = 2'b00;
          SSControl = 2'b00;
          IorD = 3'b000;
          PCSource = 3'b000;
          ExcpCtrl = 2'b00;
          L5Control = 2'b00;
          EPCWrite = 1'b0;
          state = CLOSE_WRITE;
        end
        CLOSE_WRITE: begin
          //Alteradas
          //Inalteradas
          DataSrc = 4'b0000;
          RegDst = 3'b000;
          RegWrite = 1'b0; 
          ShiftAmt = 1'b0;
          ShiftControl = 3'b000;
          ShiftSrc = 1'b0;
          ALUOutControl = 1'b0;
          ALU_Control = 3'b000;
          ALUSrcB = 2'b00;               
          PCWrite = 1'b0;
          MemWrite = 1'b0;
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          MDRWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          ALUSrcA = 2'b00;
          SSControl = 2'b00;
          IorD = 3'b000;
          PCSource = 3'b000;
          ExcpCtrl = 2'b00;
          L5Control = 2'b00;
          EPCWrite = 1'b0;
          state = WAIT;
        end
        OVERFLOW_1: begin
          //Alteradas
          EPCWrite = 1'b1;
          ALUSrcA = 2'b00;
          ALUSrcB = 2'b01;
          ALU_Control = 3'b010;
          ExcpCtrl = 2'b01;
          IorD = 3'b011;
          MemWrite = 1'b0;
          //Inalteradas
          DataSrc = 4'b0000;
          RegDst = 3'b000;
          RegWrite = 1'b0; 
          ShiftAmt = 1'b0;
          ShiftControl = 3'b000;
          ShiftSrc = 1'b0;
          ALUOutControl = 1'b0;      
          PCWrite = 1'b0;
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          MDRWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          SSControl = 2'b00;
          PCSource = 3'b000;
          L5Control = 2'b00;
          state = OVERFLOW_WAIT_1;
        end
        OVERFLOW_WAIT_1: begin
          //Alteradas
          EPCWrite = 1'b0;
          //Inalteradas
          ALUSrcA = 2'b00;
          ALUSrcB = 2'b01;
          ALU_Control = 3'b010;
          ExcpCtrl = 2'b01;
          IorD = 3'b011;
          MemWrite = 1'b0;
          DataSrc = 4'b0000;
          RegDst = 3'b000;
          RegWrite = 1'b0; 
          ShiftAmt = 1'b0;
          ShiftControl = 3'b000;
          ShiftSrc = 1'b0;
          ALUOutControl = 1'b0;      
          PCWrite = 1'b0;
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          MDRWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          SSControl = 2'b00;
          PCSource = 3'b000;
          L5Control = 2'b00;
          state = OVERFLOW_WAIT_2;
        end
        OVERFLOW_WAIT_2: begin
          //Alteradas
          EPCWrite = 1'b0;
          //Inalteradas
          ALUSrcA = 2'b00;
          ALUSrcB = 2'b01;
          ALU_Control = 3'b010;
          ExcpCtrl = 2'b01;
          IorD = 3'b011;
          MemWrite = 1'b0;
          DataSrc = 4'b0000;
          RegDst = 3'b000;
          RegWrite = 1'b0; 
          ShiftAmt = 1'b0;
          ShiftControl = 3'b000;
          ShiftSrc = 1'b0;
          ALUOutControl = 1'b0;      
          PCWrite = 1'b0;
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          MDRWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          SSControl = 2'b00;
          PCSource = 3'b000;
          L5Control = 2'b00;
          state = OVERFLOW_2;  
        end
        OVERFLOW_2: begin
          //Alteradas
          EPCWrite = 1'b0;
          PCSource = 3'b101;
          PCWrite = 1'b1;
          //Inalteradas
          ALUSrcA = 2'b00;
          ALUSrcB = 2'b01;
          ALU_Control = 3'b010;
          ExcpCtrl = 2'b01;
          IorD = 3'b011;
          MemWrite = 1'b0;
          DataSrc = 4'b0000;
          RegDst = 3'b000;
          RegWrite = 1'b0; 
          ShiftAmt = 1'b0;
          ShiftControl = 3'b000;
          ShiftSrc = 1'b0;
          ALUOutControl = 1'b0;
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          MDRWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          SSControl = 2'b00;
          L5Control = 2'b00;
          state = WAIT;
        end
        OPCODEI: begin
          //Alteradas
          EPCWrite = 1'b1;
          ALUSrcA = 2'b00;
          ALUSrcB = 2'b01;
          ALU_Control = 3'b010;
          ExcpCtrl = 2'b00;
          IorD = 3'b011;
          MemWrite = 1'b0;
          //Inalteradas
          DataSrc = 4'b0000;
          RegDst = 3'b000;
          RegWrite = 1'b0; 
          ShiftAmt = 1'b0;
          ShiftControl = 3'b000;
          ShiftSrc = 1'b0;
          ALUOutControl = 1'b0;      
          PCWrite = 1'b0;
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          MDRWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          SSControl = 2'b00;
          PCSource = 3'b000;
          L5Control = 2'b00;
          state = OPCODEI_WAIT_1;
        end
        OPCODEI_WAIT_1: begin
          //Alteradas
          EPCWrite = 1'b0;
          //Inalteradas
          ALUSrcA = 2'b00;
          ALUSrcB = 2'b01;
          ALU_Control = 3'b010;
          ExcpCtrl = 2'b01;
          IorD = 3'b011;
          MemWrite = 1'b0;
          DataSrc = 4'b0000;
          RegDst = 3'b000;
          RegWrite = 1'b0; 
          ShiftAmt = 1'b0;
          ShiftControl = 3'b000;
          ShiftSrc = 1'b0;
          ALUOutControl = 1'b0;      
          PCWrite = 1'b0;
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          MDRWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          SSControl = 2'b00;
          PCSource = 3'b000;
          L5Control = 2'b00;
          state = OPCODEI_WAIT_2;
        end
        OPCODEI_WAIT_2: begin
          //Alteradas
          EPCWrite = 1'b0;
          //Inalteradas
          ALUSrcA = 2'b00;
          ALUSrcB = 2'b01;
          ALU_Control = 3'b010;
          ExcpCtrl = 2'b01;
          IorD = 3'b011;
          MemWrite = 1'b0;
          DataSrc = 4'b0000;
          RegDst = 3'b000;
          RegWrite = 1'b0; 
          ShiftAmt = 1'b0;
          ShiftControl = 3'b000;
          ShiftSrc = 1'b0;
          ALUOutControl = 1'b0;      
          PCWrite = 1'b0;
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          MDRWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          SSControl = 2'b00;
          PCSource = 3'b000;
          L5Control = 2'b00;
          state = OPCODEI_2; 
        end
        OPCODEI_2: begin
          //Alteradas
          EPCWrite = 1'b0;
          PCSource = 3'b101;
          PCWrite = 1'b1;
          //Inalteradas
          ALUSrcA = 2'b00;
          ALUSrcB = 2'b01;
          ALU_Control = 3'b010;
          ExcpCtrl = 2'b01;
          IorD = 3'b011;
          MemWrite = 1'b0;
          DataSrc = 4'b0000;
          RegDst = 3'b000;
          RegWrite = 1'b0; 
          ShiftAmt = 1'b0;
          ShiftControl = 3'b000;
          ShiftSrc = 1'b0;
          ALUOutControl = 1'b0;
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          MDRWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          SSControl = 2'b00;
          L5Control = 2'b00;
          state = WAIT;
        end
        DIVBY0: begin
          //Alteradas
          EPCWrite = 1'b1;
          ALUSrcA = 2'b00;
          ALUSrcB = 2'b01;
          ALU_Control = 3'b010;
          ExcpCtrl = 2'b10;
          IorD = 3'b011;
          MemWrite = 1'b0;
          //Inalteradas
          DataSrc = 4'b0000;
          RegDst = 3'b000;
          RegWrite = 1'b0; 
          ShiftAmt = 1'b0;
          ShiftControl = 3'b000;
          ShiftSrc = 1'b0;
          ALUOutControl = 1'b0;      
          PCWrite = 1'b0;
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          MDRWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          SSControl = 2'b00;
          PCSource = 3'b000;
          L5Control = 2'b00;
          state = DIVBY0_WAIT_1;
        end
        DIVBY0_WAIT_1: begin
          //Alteradas
          EPCWrite = 1'b0;
          //Inalteradas
          ALUSrcA = 2'b00;
          ALUSrcB = 2'b01;
          ALU_Control = 3'b010;
          ExcpCtrl = 2'b01;
          IorD = 3'b011;
          MemWrite = 1'b0;
          DataSrc = 4'b0000;
          RegDst = 3'b000;
          RegWrite = 1'b0; 
          ShiftAmt = 1'b0;
          ShiftControl = 3'b000;
          ShiftSrc = 1'b0;
          ALUOutControl = 1'b0;      
          PCWrite = 1'b0;
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          MDRWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          SSControl = 2'b00;
          PCSource = 3'b000;
          L5Control = 2'b00;
          state = DIVBY0_WAIT_2;
        end
        DIVBY0_WAIT_2: begin
          //Alteradas
          EPCWrite = 1'b0;
          //Inalteradas
          ALUSrcA = 2'b00;
          ALUSrcB = 2'b01;
          ALU_Control = 3'b010;
          ExcpCtrl = 2'b01;
          IorD = 3'b011;
          MemWrite = 1'b0;
          DataSrc = 4'b0000;
          RegDst = 3'b000;
          RegWrite = 1'b0; 
          ShiftAmt = 1'b0;
          ShiftControl = 3'b000;
          ShiftSrc = 1'b0;
          ALUOutControl = 1'b0;      
          PCWrite = 1'b0;
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          MDRWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          SSControl = 2'b00;
          PCSource = 3'b000;
          L5Control = 2'b00;
          state = DIVBY0_2;
        end
        DIVBY0_2: begin
          //Alteradas
          EPCWrite = 1'b0;
          PCSource = 3'b101;
          PCWrite = 1'b1;
          //Inalteradas
          ALUSrcA = 2'b00;
          ALUSrcB = 2'b01;
          ALU_Control = 3'b010;
          ExcpCtrl = 2'b01;
          IorD = 3'b011;
          MemWrite = 1'b0;
          DataSrc = 4'b0000;
          RegDst = 3'b000;
          RegWrite = 1'b0; 
          ShiftAmt = 1'b0;
          ShiftControl = 3'b000;
          ShiftSrc = 1'b0;
          ALUOutControl = 1'b0;
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          MDRWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          SSControl = 2'b00;
          L5Control = 2'b00;
          state = WAIT;
        end
        J: begin
          //Alteradas
          PCSource = 3'b010;
          PCWrite = 1'b1;
          //Inalteradas
          EPCWrite = 1'b0;
          ALUSrcA = 2'b00;
          ALUSrcB = 2'b01;
          ALU_Control = 3'b010;
          ExcpCtrl = 2'b01;
          IorD = 3'b011;
          MemWrite = 1'b0;
          DataSrc = 4'b0000;
          RegDst = 3'b000;
          RegWrite = 1'b0; 
          ShiftAmt = 1'b0;
          ShiftControl = 3'b000;
          ShiftSrc = 1'b0;
          ALUOutControl = 1'b0;
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          MDRWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          SSControl = 2'b00;
          L5Control = 2'b00;
          state = CLOSE_WRITE;
        end
        JAL_1: begin
          //Alteradas
          ALUSrcA = 2'b00;
          ALU_Control = 3'b000;
          ALUOutControl = 1'b1; 
          //Inalteradas
          PCSource = 3'b000;
          PCWrite = 1'b0;
          EPCWrite = 1'b0;
          ALUSrcA = 2'b00;
          ALUSrcB = 2'b01;
          ExcpCtrl = 2'b01;
          IorD = 3'b011;
          MemWrite = 1'b0;
          DataSrc = 4'b0000;
          RegDst = 3'b000;
          RegWrite = 1'b0; 
          ShiftAmt = 1'b0;
          ShiftControl = 3'b000;
          ShiftSrc = 1'b0;
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          MDRWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          SSControl = 2'b00;
          L5Control = 2'b00;
          state = JAL_2;
        end
        JAL_2: begin
          //Alteradas
          DataSrc = 4'b0000;
          RegDst = 3'b011;
          RegWrite = 1'b1; 
          //Inalteradas
          ALUSrcA = 2'b00;
          ALU_Control = 3'b000;
          ALUOutControl = 1'b1; 
          PCSource = 3'b000;
          PCWrite = 1'b0;
          EPCWrite = 1'b0;
          ALUSrcA = 2'b00;
          ALUSrcB = 2'b01;
          ExcpCtrl = 2'b01;
          IorD = 3'b011;
          MemWrite = 1'b0; 
          ShiftAmt = 1'b0;
          ShiftControl = 3'b000;
          ShiftSrc = 1'b0;
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          MDRWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          SSControl = 2'b00;
          L5Control = 2'b00;
          state = JAL_3;
        end
        JAL_3: begin
          //Alteradas
          PCSource = 3'b010;
          PCWrite = 1'b1; 
          //Inalteradas
          DataSrc = 4'b0000;
          RegDst = 3'b000;
          RegWrite = 1'b0; 
          ALUSrcA = 2'b00;
          ALU_Control = 3'b000;
          ALUOutControl = 1'b0;
          EPCWrite = 1'b0;
          ALUSrcA = 2'b00;
          ALUSrcB = 2'b00;
          ExcpCtrl = 2'b00;
          IorD = 3'b011;
          MemWrite = 1'b0; 
          ShiftAmt = 1'b0;
          ShiftControl = 3'b000;
          ShiftSrc = 1'b0;
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          MDRWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          SSControl = 2'b00;
          L5Control = 2'b00;
          state = CLOSE_WRITE;
        end
        SW_SH_SB_1: begin
          //Alteradas
          ALUSrcA = 2'b01;
          ALUSrcB = 2'b10;
          ALU_Control = 3'b001;
          ALUOutControl = 1'b1;
          IorD = 3'b010;
          MemWrite = 1'b0;
          //Inalteradas
          PCSource = 3'b000;
          PCWrite = 1'b0;
          DataSrc = 4'b0000;
          RegDst = 3'b000;
          RegWrite = 1'b0; 
          ALUSrcA = 2'b00;
          EPCWrite = 1'b0;
          ExcpCtrl = 2'b00; 
          ShiftAmt = 1'b0;
          ShiftControl = 3'b000;
          ShiftSrc = 1'b0;     
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          MDRWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          SSControl = 2'b00;
          L5Control = 2'b00;
          state = SW_SH_SB_WAIT;
        end
        SW_SH_SB_WAIT: begin
          //Alteradas
          ALUSrcA = 2'b01;
          ALUSrcB = 2'b10;
          ALU_Control = 3'b001;
          ALUOutControl = 1'b0;
          IorD = 3'b010;
          MemWrite = 1'b0;
          //Inalteradas
          PCSource = 3'b000;
          PCWrite = 1'b0;
          DataSrc = 4'b0000;
          RegDst = 3'b000;
          RegWrite = 1'b0; 
          ALUSrcA = 2'b00;
          EPCWrite = 1'b0;
          ExcpCtrl = 2'b00; 
          ShiftAmt = 1'b0;
          ShiftControl = 3'b000;
          ShiftSrc = 1'b0;     
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          MDRWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          SSControl = 2'b00;
          L5Control = 2'b00;
          state = SW_SH_SB_WAIT_2;
        end
        SW_SH_SB_WAIT_2: begin
          //Alteradas
          ALUSrcA = 2'b01;
          ALUSrcB = 2'b10;
          ALU_Control = 3'b001;
          ALUOutControl = 1'b0;
          IorD = 3'b010;
          MemWrite = 1'b0;
          MDRWrite = 1'b1;
          //Inalteradas
          PCSource = 3'b000;
          PCWrite = 1'b0;
          DataSrc = 4'b0000;
          RegDst = 3'b000;
          RegWrite = 1'b0; 
          ALUSrcA = 2'b00;
          EPCWrite = 1'b0;
          ExcpCtrl = 2'b00; 
          ShiftAmt = 1'b0;
          ShiftControl = 3'b000;
          ShiftSrc = 1'b0;     
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          SSControl = 2'b00;
          L5Control = 2'b00;
          case (Opcode)
            SW_O: begin
              state = SW;
            end
            SH_O: begin
              state = SH;
            end
            SB_O: begin
              state = SB;
            end 
          endcase
        end
        SW: begin
          //Alteradas
          SSControl = 2'b01;
          MemWrite = 1'b1;
          IorD = 3'b010;
          //Inalteradas
          ALUSrcA = 2'b00;
          ALUSrcB = 2'b00;
          ALU_Control = 3'b000;
          ALUOutControl = 1'b0;
          PCSource = 3'b000;
          PCWrite = 1'b0;
          DataSrc = 4'b0000;
          RegDst = 3'b000;
          RegWrite = 1'b0; 
          ALUSrcA = 2'b00;
          EPCWrite = 1'b0;
          ExcpCtrl = 2'b00; 
          ShiftAmt = 1'b0;
          ShiftControl = 3'b000;
          ShiftSrc = 1'b0;     
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          MDRWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          L5Control = 2'b00;
          state = CLOSE_WRITE;
        end
        SH: begin
          //Alteradas
          SSControl = 2'b10;
          MemWrite = 1'b1;
          IorD = 3'b010;
          //Inalteradas
          ALUSrcA = 2'b00;
          ALUSrcB = 2'b00;
          ALU_Control = 3'b000;
          ALUOutControl = 1'b0;
          PCSource = 3'b000;
          PCWrite = 1'b0;
          DataSrc = 4'b0000;
          RegDst = 3'b000;
          RegWrite = 1'b0; 
          ALUSrcA = 2'b00;
          EPCWrite = 1'b0;
          ExcpCtrl = 2'b00; 
          ShiftAmt = 1'b0;
          ShiftControl = 3'b000;
          ShiftSrc = 1'b0;     
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          MDRWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          L5Control = 2'b00;
          state = CLOSE_WRITE;
        end
        SB: begin
          //Alteradas
          SSControl = 2'b11;
          MemWrite = 1'b1;
          IorD = 3'b010;
          //Inalteradas
          ALUSrcA = 2'b00;
          ALUSrcB = 2'b00;
          ALU_Control = 3'b000;
          ALUOutControl = 1'b0;
          PCSource = 3'b000;
          PCWrite = 1'b0;
          DataSrc = 4'b0000;
          RegDst = 3'b000;
          RegWrite = 1'b0; 
          ALUSrcA = 2'b00;
          EPCWrite = 1'b0;
          ExcpCtrl = 2'b00; 
          ShiftAmt = 1'b0;
          ShiftControl = 3'b000;
          ShiftSrc = 1'b0;     
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          MDRWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          L5Control = 2'b00;
          state = CLOSE_WRITE;
        end
        LW_LH_LB_1: begin
          //Alteradas
          ALUSrcA = 2'b01;
          ALUSrcB = 2'b10;
          ALU_Control = 3'b001;
          IorD = 3'b001;
          MemWrite = 1'b0;
          //Inalteradas
          ALUOutControl = 1'b0;
          PCSource = 3'b000;
          PCWrite = 1'b0;
          DataSrc = 4'b0000;
          RegDst = 3'b000;
          RegWrite = 1'b0; 
          ALUSrcA = 2'b00;
          EPCWrite = 1'b0;
          ExcpCtrl = 2'b00; 
          ShiftAmt = 1'b0;
          ShiftControl = 3'b000;
          ShiftSrc = 1'b0;     
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          MDRWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          SSControl = 2'b00;
          L5Control = 2'b00;
          state = LW_LH_LB_WAIT_1;
        end
        LW_LH_LB_WAIT_1: begin
          //Alteradas
          ALUSrcA = 2'b01;
          ALUSrcB = 2'b10;
          ALU_Control = 3'b001;
          IorD = 3'b001;
          MemWrite = 1'b0;
          //Inalteradas
          ALUOutControl = 1'b0;
          PCSource = 3'b000;
          PCWrite = 1'b0;
          DataSrc = 4'b0000;
          RegDst = 3'b000;
          RegWrite = 1'b0; 
          ALUSrcA = 2'b00;
          EPCWrite = 1'b0;
          ExcpCtrl = 2'b00; 
          ShiftAmt = 1'b0;
          ShiftControl = 3'b000;
          ShiftSrc = 1'b0;     
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          MDRWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          SSControl = 2'b00;
          L5Control = 2'b00;
          state = LW_LH_LB_WAIT_2;
        end
        LW_LH_LB_WAIT_2: begin
          //Alteradas
          ALUSrcA = 2'b01;
          ALUSrcB = 2'b10;
          ALU_Control = 3'b001;
          IorD = 3'b001;
          MemWrite = 1'b0;
          MDRWrite = 1'b1;
          //Inalteradas
          ALUOutControl = 1'b0;
          PCSource = 3'b000;
          PCWrite = 1'b0;
          DataSrc = 4'b0000;
          RegDst = 3'b000;
          RegWrite = 1'b0; 
          ALUSrcA = 2'b00;
          EPCWrite = 1'b0;
          ExcpCtrl = 2'b00; 
          ShiftAmt = 1'b0;
          ShiftControl = 3'b000;
          ShiftSrc = 1'b0;     
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          SSControl = 2'b00;
          L5Control = 2'b00;
          case (Opcode)
            LW_O: begin
              state = LW;
            end
            LH_O: begin
              state = LH;
            end
            LB_O: begin
              state = LB;
            end 
          endcase
        end
        LW: begin
          //Alteradas
          DataSrc = 4'b0001;
          RegDst = 3'b000;
          RegWrite = 1'b1;
          L5Control = 2'b01; 
          IorD = 3'b001;
          //Inalteradas
          MemWrite = 1'b0;
          SSControl = 2'b00;
          ALUSrcA = 2'b00;
          ALUSrcB = 2'b00;
          ALU_Control = 3'b000;
          ALUOutControl = 1'b0;
          PCSource = 3'b000;
          PCWrite = 1'b0;
          ALUSrcA = 2'b00;
          EPCWrite = 1'b0;
          ExcpCtrl = 2'b00; 
          ShiftAmt = 1'b0;
          ShiftControl = 3'b000;
          ShiftSrc = 1'b0;     
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          MDRWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          state = CLOSE_WRITE;
        end
        LH: begin
          //Alteradas
          DataSrc = 4'b0001;
          RegDst = 3'b000;
          RegWrite = 1'b1;
          L5Control = 2'b10; 
          IorD = 3'b001;
          //Inalteradas
          MemWrite = 1'b0;
          SSControl = 2'b00;
          ALUSrcA = 2'b00;
          ALUSrcB = 2'b00;
          ALU_Control = 3'b000;
          ALUOutControl = 1'b0;
          PCSource = 3'b000;
          PCWrite = 1'b0;
          ALUSrcA = 2'b00;
          EPCWrite = 1'b0;
          ExcpCtrl = 2'b00; 
          ShiftAmt = 1'b0;
          ShiftControl = 3'b000;
          ShiftSrc = 1'b0;     
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          MDRWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          state = CLOSE_WRITE;
        end
        LB: begin
          //Alteradas
          //Inalteradas
          DataSrc = 4'b0000;
          RegDst = 3'b000;
          RegWrite = 1'b0;
          L5Control = 2'b00; 
          IorD = 3'b000;
          MemWrite = 1'b0;
          SSControl = 2'b00;
          ALUSrcA = 2'b00;
          ALUSrcB = 2'b00;
          ALU_Control = 3'b000;
          ALUOutControl = 1'b0;
          PCSource = 3'b000;
          PCWrite = 1'b0;
          ALUSrcA = 2'b00;
          EPCWrite = 1'b0;
          ExcpCtrl = 2'b00; 
          ShiftAmt = 1'b0;
          ShiftControl = 3'b000;
          ShiftSrc = 1'b0;     
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          MDRWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          state = CLOSE_WRITE;
        end
        LUI: begin
          //Alteradas
          DataSrc = 4'b0110;
          RegDst = 3'b000;
          RegWrite = 1'b1;
          //Inalteradas
          L5Control = 2'b00; 
          IorD = 3'b000;
          MemWrite = 1'b0;
          SSControl = 2'b00;
          ALUSrcA = 2'b00;
          ALUSrcB = 2'b00;
          ALU_Control = 3'b000;
          ALUOutControl = 1'b0;
          PCSource = 3'b000;
          PCWrite = 1'b0;
          ALUSrcA = 2'b00;
          EPCWrite = 1'b0;
          ExcpCtrl = 2'b00; 
          ShiftAmt = 1'b0;
          ShiftControl = 3'b000;
          ShiftSrc = 1'b0;     
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          MDRWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          state = CLOSE_WRITE;
        end
        BLM_1: begin
          //Alteradas
          MemWrite = 1'b0; 
          IorD = 3'b100;
          //Inalteradas
          DataSrc = 4'b0000;
          RegDst = 3'b000;
          RegWrite = 1'b0;
          L5Control = 2'b00;
          SSControl = 2'b00;
          ALUSrcA = 2'b00;
          ALUSrcB = 2'b00;
          ALU_Control = 3'b000;
          ALUOutControl = 1'b0;
          PCSource = 3'b000;
          PCWrite = 1'b0;
          ALUSrcA = 2'b00;
          EPCWrite = 1'b0;
          ExcpCtrl = 2'b00; 
          ShiftAmt = 1'b0;
          ShiftControl = 3'b000;
          ShiftSrc = 1'b0;     
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          MDRWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          state = BLM_2_WAIT;
        end
        BLM_2_WAIT: begin
          //Alteradas
          MemWrite = 1'b0; 
          IorD = 3'b100;
          //Inalteradas
          DataSrc = 4'b0000;
          RegDst = 3'b000;
          RegWrite = 1'b0;
          L5Control = 2'b00;
          SSControl = 2'b00;
          ALUSrcA = 2'b00;
          ALUSrcB = 2'b00;
          ALU_Control = 3'b000;
          ALUOutControl = 1'b0;
          PCSource = 3'b000;
          PCWrite = 1'b0;
          ALUSrcA = 2'b00;
          EPCWrite = 1'b0;
          ExcpCtrl = 2'b00; 
          ShiftAmt = 1'b0;
          ShiftControl = 3'b000;
          ShiftSrc = 1'b0;     
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          MDRWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          state = BLM_3_WAIT;
        end
        BLM_3_WAIT: begin
          //Alteradas
          MemWrite = 1'b0; 
          IorD = 3'b100;
          MDRWrite = 1'b1;
          //Inalteradas
          DataSrc = 4'b0000;
          RegDst = 3'b000;
          RegWrite = 1'b0;
          L5Control = 2'b00;
          SSControl = 2'b00;
          ALUSrcA = 2'b00;
          ALUSrcB = 2'b00;
          ALU_Control = 3'b000;
          ALUOutControl = 1'b0;
          PCSource = 3'b000;
          PCWrite = 1'b0;
          ALUSrcA = 2'b00;
          EPCWrite = 1'b0;
          ExcpCtrl = 2'b00; 
          ShiftAmt = 1'b0;
          ShiftControl = 3'b000;
          ShiftSrc = 1'b0;     
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          state = BLM_4;
        end
        BLM_4: begin
          //Alteradas
          ALUSrcA = 2'b10;
          ALUSrcB = 2'b00;
          ALU_Control = 3'b111;
          PCWrite = 1'b1;
          //Inalteradas
          MemWrite = 1'b0; 
          IorD = 3'b000;
          MDRWrite = 1'b0;
          DataSrc = 4'b0000;
          RegDst = 3'b000;
          RegWrite = 1'b0;
          L5Control = 2'b00;
          SSControl = 2'b00;
          ALUOutControl = 1'b0;
          PCSource = 3'b000;
          ALUSrcA = 2'b00;
          EPCWrite = 1'b0;
          ExcpCtrl = 2'b00; 
          ShiftAmt = 1'b0;
          ShiftControl = 3'b000;
          ShiftSrc = 1'b0;     
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          state = CLOSE_WRITE;
        end
        SLTI: begin
          //Alteradas
          ALUSrcA = 2'b01;
          ALUSrcB = 2'b10;
          ALU_Control = 3'b111;
          DataSrc = 4'b0100;
          RegDst = 3'b000;
          RegWrite = 1'b1;
          //Inalteradas
          PCWrite = 1'b0;
          MemWrite = 1'b0; 
          IorD = 3'b000;
          MDRWrite = 1'b0;
          L5Control = 2'b00;
          SSControl = 2'b00;
          ALUOutControl = 1'b0;
          PCSource = 3'b000;
          ALUSrcA = 2'b00;
          EPCWrite = 1'b0;
          ExcpCtrl = 2'b00; 
          ShiftAmt = 1'b0;
          ShiftControl = 3'b000;
          ShiftSrc = 1'b0;     
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          state = CLOSE_WRITE;
        end
        BGT_BLE: begin
          //Alteradas
          ALUSrcA = 2'b01;
          ALUSrcB = 2'b00;
          ALU_Control = 3'b111;
          PCSource = 3'b001;
          //Inalteradas
          DataSrc = 4'b0000;
          RegDst = 3'b000;
          RegWrite = 1'b0;
          PCWrite = 1'b0;
          MemWrite = 1'b0; 
          IorD = 3'b000;
          MDRWrite = 1'b0;
          L5Control = 2'b00;
          SSControl = 2'b00;
          ALUOutControl = 1'b0;
          ALUSrcA = 2'b00;
          EPCWrite = 1'b0;
          ExcpCtrl = 2'b00; 
          ShiftAmt = 1'b0;
          ShiftControl = 3'b000;
          ShiftSrc = 1'b0;     
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          state = BGT_BLE_2;
        end
        BGT_BLE_2: begin
          //PENSAR MELHOR
        end
        BEQ_BNE: begin
          //Alteradas
          ALUSrcA = 2'b01;
          ALUSrcB = 2'b00;
          ALU_Control = 3'b111;
          PCSource = 3'b001;
          //Inalteradas
          DataSrc = 4'b0000;
          RegDst = 3'b000;
          RegWrite = 1'b0;
          PCWrite = 1'b0;
          MemWrite = 1'b0; 
          IorD = 3'b000;
          MDRWrite = 1'b0;
          L5Control = 2'b00;
          SSControl = 2'b00;
          ALUOutControl = 1'b0;
          ALUSrcA = 2'b00;
          EPCWrite = 1'b0;
          ExcpCtrl = 2'b00; 
          ShiftAmt = 1'b0;
          ShiftControl = 3'b000;
          ShiftSrc = 1'b0;     
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          state = BEQ_BNE_2;
        end
        BEQ_BNE_2: begin
          //PENSAR MELHOR
        end
        ADDI_ADDIU: begin
          //Alteradas
          ALUSrcA = 2'b01;
          ALUSrcB = 2'b10;
          ALU_Control = 3'b001;
          ALUOutControl = 1'b1;
          //Inalteradas
          PCSource = 3'b000;
          DataSrc = 4'b0000;
          RegDst = 3'b000;
          RegWrite = 1'b0;
          PCWrite = 1'b0;
          MemWrite = 1'b0; 
          IorD = 3'b000;
          MDRWrite = 1'b0;
          L5Control = 2'b00;
          SSControl = 2'b00;
          ALUSrcA = 2'b00;
          EPCWrite = 1'b0;
          ExcpCtrl = 2'b00; 
          ShiftAmt = 1'b0;
          ShiftControl = 3'b000;
          ShiftSrc = 1'b0;     
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          case (Opcode)
            ADDI_O: begin
              state = ADDI;
            end
            ADDIU_O: begin
              state = ADDIU;
            end
          endcase
        end
        ADDI: begin
          //Alteradas
          DataSrc = 4'b0000;
          RegDst = 3'b000;
          RegWrite = 1'b1;
          //Inalteradas
          ALUSrcA = 2'b00;
          ALUSrcB = 2'b00;
          ALU_Control = 3'b000;
          PCSource = 3'b000;
          DataSrc = 4'b0000;
          PCWrite = 1'b0;
          MemWrite = 1'b0; 
          IorD = 3'b000;
          MDRWrite = 1'b0;
          L5Control = 2'b00;
          SSControl = 2'b00;
          ALUOutControl = 1'b0;
          ALUSrcA = 2'b00;
          EPCWrite = 1'b0;
          ExcpCtrl = 2'b00; 
          ShiftAmt = 1'b0;
          ShiftControl = 3'b000;
          ShiftSrc = 1'b0;     
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          state = CLOSE_WRITE;
        end
        ADDIU: begin
          //Alteradas
          DataSrc = 4'b0000;
          RegDst = 3'b000;
          RegWrite = 1'b1;
          //Inalteradas
          ALUSrcA = 2'b00;
          ALUSrcB = 2'b00;
          ALU_Control = 3'b000;
          PCSource = 3'b000;
          DataSrc = 4'b0000;
          PCWrite = 1'b0;
          MemWrite = 1'b0; 
          IorD = 3'b000;
          MDRWrite = 1'b0;
          L5Control = 2'b00;
          SSControl = 2'b00;
          ALUOutControl = 1'b0;
          ALUSrcA = 2'b00;
          EPCWrite = 1'b0;
          ExcpCtrl = 2'b00; 
          ShiftAmt = 1'b0;
          ShiftControl = 3'b000;
          ShiftSrc = 1'b0;     
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          state = CLOSE_WRITE;
        end
        WAIT: begin
          //Alteradas
          DataSrc = 4'b0000;
          RegDst = 3'b000;
          RegWrite = 1'b1;
          //Inalteradas
          ALUSrcA = 2'b00;
          ALUSrcB = 2'b00;
          ALU_Control = 3'b000;
          PCSource = 3'b000;
          DataSrc = 4'b0000;
          PCWrite = 1'b0;
          MemWrite = 1'b0; 
          IorD = 3'b000;
          MDRWrite = 1'b0;
          L5Control = 2'b00;
          SSControl = 2'b00;
          ALUOutControl = 1'b0;
          ALUSrcA = 2'b00;
          EPCWrite = 1'b0;
          ExcpCtrl = 2'b00; 
          ShiftAmt = 1'b0;
          ShiftControl = 3'b000;
          ShiftSrc = 1'b0;     
          IRWrite = 1'b0;
          ABWrite = 1'b0;
          HIWrite = 1'b0;
          LOWrite = 1'b0;
          state = FETCH_1;
        end
      endcase
    end
  end

endmodule