module IF_ID(
    input clock,reset,IF_ID_write,
    input[31:0] IF_pc,IF_instruction,
    output reg [31:0]ID_pc,ID_instruction
);

always @(posedge clock,negedge reset) begin
    if (IF_ID_write==1'b1) begin
        ID_pc<=ID_pc;
        ID_instruction<=ID_instruction;
    end
    else if (reset) begin
        ID_pc<=IF_pc;
        ID_instruction<=IF_instruction;
    end
    else begin
        ID_pc<=0;
        ID_instruction<=0;
    end
end

endmodule