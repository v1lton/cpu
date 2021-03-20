module ss_control(
    input   wire    [1:0]   SSControl,
    input   wire    [31:0]  Data,
    input   wire    [31:0]  B_out,
    output  wire    [31:0]  ss_control_out
);

always @ (*)
    begin
        if (SSControl == 2'b01) begin // word
            ss_control_out = B_out;
        end
        else if (SSControl == 2'b10) begin // half
            ss_control_out = {Data[31:16], B_out[15:0]};
        end
        else if (SSControl == 2'b11) begin // byte
            ss_control_out = {Data[31:8], B_out[7:0]};
        end
    end

endmodule