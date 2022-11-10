module IF_ID(
    input clock,reset,
    input[31:0] IF_pc,IF_instruction,
    output [31:0]ID_pc,ID_instruction,
);

always @(posedge clock,negedge reset) begin
    if (reset) begin
        ID_pc<=IF_pc;
        ID_instruction<=IF_instruction;
    end
    else begin
        ID_pc<=0;
        ID_instruction<=0;
    end
end

endmodule