module mult_div(
	input wire HDControl, // 0 multiplicacao 1 divisão
	input wire[31:0] A,
	input wire[31:0] B,
	input wire clock,
	input wire reset,

	output wire[31:0] HI,
	output wire[31:0] LO,
	output wire DivBy0,
	output wire Done,
);

	reg Initialize;
	reg [6:0] counter;
	reg signed [64:0] AMultiplicandComparePos;
	reg signed [64:0] Multiplier;
	reg signed [31:0] NegativeBTemp;
	reg signed [64:0] Temp;

	reg signA;
	reg signB;
	reg signed[31:0] AuxA;
	reg signed[31:0] AuxB;
	reg signed[31:0] Contador;

	initial begin
		Initialize = 1'b1;
	end

	always @ (posedge clock) begin
		if (HDControl == 1'd0) begin // multiplicação
			if(reset == 1'd1) begin
				AMultiplicandComparePos[64:0] = 65'b0;
				Multiplier[64:0] = 65'b0;
				counter = 7'b0;
				Initialize = 1'b1;
				NegativeBTemp[31:0] = 32'b0;
				Temp[64:0] = 65'b0;
				Done = 1'b0;
				HI[31:0] = 32'b0;
				LO[31:0] = 32'b0;
			end else if(Initialize == 1'b1) begin
				AMultiplicandComparePos = {32'b0, A[31:0], 1'b0};
				Multiplier = {B[31:0], 33'b0};
				NegativeBTemp = ~B + 1'b1;
				Temp = {NegativeBTemp, 33'b0};
				counter = 7'b0;
				Done = 1'b0;
				Initialize = 1'b0;
			end else begin
				if (counter < 7'b0100000) begin
					if(AMultiplicandComparePos[1] == AMultiplicandComparePos[0])begin
					end
					else if (AMultiplicandComparePos[1] == 1'b1)begin
						AMultiplicandComparePos = AMultiplicandComparePos + Temp;
					end
					else if (AMultiplicandComparePos[1] == 1'b0)begin
						AMultiplicandComparePos = AMultiplicandComparePos + Multiplier;
					end
					AMultiplicandComparePos = AMultiplicandComparePos >>> 1;
					counter = counter + 1;
				end else if (counter == 7'b0100000)begin
					HI[31:0] = AMultiplicandComparePos[64:33];
					LO[31:0] = AMultiplicandComparePos[32:1];
					Done = 1'b1;
					Initialize = 1'b1;
				end
			end
		end else begin // divisão
			if(reset == 1'd1) begin
					Contador = 32'b0;
					Initialize = 1'b1;
					HI = 32'b0;
					LO = 32'b0;
					DivBy0 = 1'b0;
					AuxA = 32'b0;
					AuxB = 32'b0;
					Done = 1'b0;
					signA = 1'b0;
					signB = 1'b0;
			end
			else if(Initialize == 1'b1) begin
					Contador = 32'b0;
					Initialize = 1'b0;//muda o valor de Initialize para nao resetar no clock seguinte
					HI = 32'b0;
					LO = 32'b0;
					DivBy0 = 1'b0;
					Done = 1'b0;
					signA = 1'b0;
					signB = 1'b0;
					if(A[31] == 1'b1) begin//Se for negativo, guarda informacao e faz complemento 2
						signA = 1'b1;
						AuxA = ~A + 1;
					end
					else begin
						AuxA = A;//Se n�o, pega o valor na tora
					end
					if(B[31] == 1'b1)begin//Realiza mesmo processo com B
						signB = 1'b1;
						AuxB = ~B + 1;
					end
					else begin
						AuxB = B;
					end
					
					if(AuxB == 32'b0) begin
						DivBy0 = 1'b1;//Coloca o maior valor possivel, facilitar debug, e foi o mais logico da DivBy0
						Done = 1'b1;
						HI = 32'b01111111111111111111111111111111;
						LO = 32'b01111111111111111111111111111111;
					end
			end
			else begin
				if(AuxA < AuxB) begin
					//Se o resto for menor que o valor a ser dividido, para de dividir
					//7   3| 2  1
					//7  -3|-2  1
					//-7  3|-2 -1
					//-7 -3| 2 -1
					//Estes Ifs seguem este padrao
					if(signA == 1'b1)begin
						//Transforma negativo
						HI = ~AuxA + 1;
					end
					else begin
						HI = AuxA;
					end
					if(signB == 1'b1 && signA == 1'b1)begin
						//Transforma negativo, se A tiver sido negativo
						//vai colocar de volta para positivo
						LO = Contador;
					end
					else if(signA == 1'b1)begin
						//Transforma negativo
						LO = ~Contador + 1;
					end
					else if(signB == 1'b1)begin
						//Transforma negativo
						LO = ~Contador + 1;
					end
					else begin
						LO = Contador;
					end
					Done = 1'b1;//Informa que o Div foi finalizado
				end 
				else begin
					AuxA = AuxA - AuxB;//Salva a subtracao para poder ver qual o resto
					Contador = Contador + 1;//Incrementa resultado
				end
			end else begin
				Initialize = 1'b1;
			end
		end
	end

endmodule