module shift_reg(
    input   wire    [2:0]   ShiftControl,
    input   wire    [31:0]  Shift_source,
    input   wire    [31:0]  Shift_amount,
    output  wire    [31:0]  Shift_reg_out
);

    always @(*) begin
        if (ShiftControl == 3'b001) begin
            //Não entendi o que é para fazer. A gente colocou que dá load no registrador
        end
        else if (ShiftControl == 3'b010) begin // shift left
            Shift_reg_out = Shift_source << Shift_amount
        end
        else if (ShiftControl == 3'b011) begin // shift right logical
            Shift_reg_out = Shift_source >> Shift_amount
        end
        else if (ShiftControl == 3'b100) begin // shift right arithmetic
            Shift_reg_out = Shift_source >>> Shift_amount
        end
    end

endmodule