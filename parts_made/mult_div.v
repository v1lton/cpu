module mult_div(
  input wire HDControl, // 0 multiplicacao 1 divisão
  input wire [31:0] A,
  input wire [31:0] B,
  input wire clock,
  input wire reset,

  output reg [31:0] HI,
  output reg [31:0] LO,
  output reg DivBy0,
  output reg Done
);
  
  //Valores usados para a multiplicação
  reg Initialize;
  reg [6:0] counter;
  reg signed [64:0] AMultiplicandComparePos;
  reg signed [64:0] Multiplier;
  reg signed [31:0] NegativeBTemp;
  reg signed [64:0] Temp;
  
  //Valores usados na divisão
  reg InitializeDiv;   
  reg [4:0] ciclosDiv; // Serve para o controle da quantidade de ciclos da divisão
  reg [31:0] quociente; 
  reg [31:0] denominador;
  reg [31:0] resto;
  wire [32:0] sub = {resto[30:0], quociente[31]} - denominador; 
  assign DivBy0 = !B; // Caso B == 0, sua negação será 1  
  assign LO = quociente; 
  assign HI = resto;
  
  initial begin
    Initialize = 1'd1;
  end
  
  always @ (posedge clock) begin
    if(reset == 1'd1) begin // reset
      AMultiplicandComparePos[64:0] = 65'd0;
      Multiplier[64:0] = 65'd0;
      counter = 7'd0;
      Initialize = 1'd1;
      NegativeBTemp[31:0] = 32'd0;
      Temp[64:0] = 65'd0;
      Done = 1'd0;
      HI[31:0] = 32'd0;
      LO[31:0] = 32'd0;
      InitializeDiv = 0;  
      ciclosDiv = 0;  
      quociente = 0;  
      denominador = 0;  
      resto = 0;
    end else if (HDControl == 1'd0) begin // multiplicação
      if(Initialize == 1'b1) begin //
        AMultiplicandComparePos = {32'd0, A[31:0], 1'd0};
        Multiplier = {B[31:0], 33'd0};
        NegativeBTemp = ~B + 1'd1;
        Temp = {NegativeBTemp, 33'd0};
        counter = 7'd0;
        Done = 1'd0;
        Initialize = 1'd0;
      end else begin
        if (counter < 7'b0100000) begin // se for menor que 32
          
          if(AMultiplicandComparePos[1] == AMultiplicandComparePos[0])begin
						// não faz nada mesmo
          end else if (AMultiplicandComparePos[1] == 1'd1)begin
            AMultiplicandComparePos = AMultiplicandComparePos + Temp;
          end else if (AMultiplicandComparePos[1] == 1'd0)begin
            AMultiplicandComparePos = AMultiplicandComparePos + Multiplier;
          end
					
          AMultiplicandComparePos = AMultiplicandComparePos >>> 1;
          counter = counter + 1;
          
        end else if (counter == 7'b0100000)begin // se for 32, terminou a multiplicação
          
          HI[31:0] = AMultiplicandComparePos[64:33];
          LO[31:0] = AMultiplicandComparePos[32:1];
          Done = 1'd1;
          Initialize = 1'd1;
					
        end
      end
    end else if(HDControl == 1'd1) begin // Divisão
      if (InitializeDiv) begin // Começo do algoritmo de divisão
      
        if (sub[32] == 0) begin   
          resto = sub[31:0];
          quociente = {quociente[30:0], 1'b1};
        end else begin
          resto = {resto [30:0], quociente[31]};  
          quociente = {quociente[30:0], 1'b0};
        end
        
        if (ciclosDiv == 0) begin // Caso os ciclos tenham chegado em 0, finaliza a divisão
          InitializeDiv = 0;
          Done = 1;
        end else begin
          Done = 0;
        end
        
        ciclosDiv = ciclosDiv - 5'd1; // Diminui um ciclo
      end else begin // Caso InitializeDiv seja 0 e HDControl seja 1, inicializa as variáveis para divisão
        
        if (Done == 0) begin
          ciclosDiv = 5'd31; 
          quociente = A; 
          denominador = B;
          resto = 32'd0; 
          InitializeDiv = 1;
        end else begin
          Done = 0;
        end
        
      end
    end
  end

endmodule