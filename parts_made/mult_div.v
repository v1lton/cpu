module Mult (
input wire[31:0] RegAOut,
input wire[31:0] RegBOut,
input wire clock,
input wire reset,
input wire MultCtrl,
output reg MultDone,
output reg[31:0] MultHIOut,
output reg[31:0] MultLOOut
);

//64:33 = A
//32:1 = Multiplier
//0:0 = Comparing Pos
reg Initialize;
reg [6:0] counter;
reg signed [64:0] AMultiplicandComparePos;
reg signed [64:0] Multiplier;
reg signed [31:0] NegativeBTemp;
reg signed [64:0] Temp;
initial begin
	Initialize = 1'b1;
end

always @ (posedge clock) begin
	if(reset == 1'd1) begin
		AMultiplicandComparePos[64:0] = 65'b0;
		Multiplier[64:0] = 65'b0;
		counter = 7'b0;
		Initialize = 1'b1;
		NegativeBTemp[31:0] = 32'b0;
		Temp[64:0] = 65'b0;
		MultDone = 1'b0;
		MultHIOut[31:0] = 32'b0;
		MultLOOut[31:0] = 32'b0;
	end else if(MultCtrl == 1'd1 && Initialize == 1'b1) begin
		AMultiplicandComparePos = {32'b0, RegAOut[31:0], 1'b0};
		Multiplier = {RegBOut[31:0], 33'b0};
		NegativeBTemp = ~RegBOut + 1'b1;
		Temp = {NegativeBTemp, 33'b0};
		counter = 7'b0;
		MultDone = 1'b0;
		Initialize = 1'b0;
	end else if(MultCtrl == 1'd1) begin
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
			MultHIOut[31:0] = AMultiplicandComparePos[64:33];
			MultLOOut[31:0] = AMultiplicandComparePos[32:1];
			MultDone = 1'b1;
			Initialize = 1'b1;
		end
	end
	
end

endmodule

module Div (
input wire[31:0] RegAOut,
input wire[31:0] RegBOut,
input wire clock,
input wire reset,
input wire DivCtrl,
output reg DivDone,
output reg Div0,
output reg[31:0] DivHIOut,
output reg[31:0] DivLOOut
);

reg Initialize;
reg signA;
reg signB;
reg signed[31:0] AuxA;
reg signed[31:0] AuxB;
reg signed[31:0] Contador;

initial begin//setar variaveis
	Initialize = 1'b1;
end

always @(posedge clock) begin
	if(reset == 1'd1) begin
			Contador = 32'b0;
			Initialize = 1'b1;
			DivHIOut = 32'b0;
			DivLOOut = 32'b0;
			Div0 = 1'b0;
			AuxA = 32'b0;
			AuxB = 32'b0;
			DivDone = 1'b0;
			signA = 1'b0;
			signB = 1'b0;
	end
	else if(DivCtrl == 1'd1 && Initialize == 1'b1) begin
			Contador = 32'b0;
			Initialize = 1'b0;//muda o valor de Initialize para nao resetar no clock seguinte
			DivHIOut = 32'b0;
			DivLOOut = 32'b0;
			Div0 = 1'b0;
			DivDone = 1'b0;
			signA = 1'b0;
			signB = 1'b0;
			if(RegAOut[31] == 1'b1) begin//Se for negativo, guarda informacao e faz complemento 2
				signA = 1'b1;
				AuxA = ~RegAOut + 1;
			end
			else begin
				AuxA = RegAOut;//Se n�o, pega o valor na tora
			end
			if(RegBOut[31] == 1'b1)begin//Realiza mesmo processo com B
				signB = 1'b1;
				AuxB = ~RegBOut + 1;
			end
			else begin
				AuxB = RegBOut;
			end
			
			if(AuxB == 32'b0) begin
				Div0 = 1'b1;//Coloca o maior valor possivel, facilitar debug, e foi o mais logico da Div0
				DivDone = 1'b1;
				DivHIOut = 32'b01111111111111111111111111111111;
				DivLOOut = 32'b01111111111111111111111111111111;
			end
	end
	else if(DivCtrl == 1'd1) begin
		if(AuxA < AuxB) begin
			//Se o resto for menor que o valor a ser dividido, para de dividir
			//7   3| 2  1
			//7  -3|-2  1
			//-7  3|-2 -1
			//-7 -3| 2 -1
			//Estes Ifs seguem este padrao
			if(signA == 1'b1)begin
				//Transforma negativo
				DivHIOut = ~AuxA + 1;
			end
			else begin
				DivHIOut = AuxA;
			end
			if(signB == 1'b1 && signA == 1'b1)begin
				//Transforma negativo, se A tiver sido negativo
				//vai colocar de volta para positivo
				DivLOOut = Contador;
			end
			else if(signA == 1'b1)begin
				//Transforma negativo
				DivLOOut = ~Contador + 1;
			end
			else if(signB == 1'b1)begin
				//Transforma negativo
				DivLOOut = ~Contador + 1;
			end
			else begin
				DivLOOut = Contador;
			end
			DivDone = 1'b1;//Informa que o Div foi finalizado
		end 
		else begin
			AuxA = AuxA - AuxB;//Salva a subtracao para poder ver qual o resto
			Contador = Contador + 1;//Incrementa resultado
		end
	end else begin
		Initialize = 1'b1;
	end
end

endmodule



module mult_div(

);



