module EXE_MEM(
    input reset,clock,
    input[31:0]EXE_pc,EXE_b,EXE_c,
    input[4:0]EXE_num_write,
    output reg[31:0]MEM_pc,MEM_b,MEM_c,
    output reg[4:0]MEM_num_write,
    input EXE_mem_write,EXE_reg_write,
    output reg MEM_mem_write,MEM_reg_write,
    input [1:0]EXE_s_data_write,
    output reg[1:0]MEM_s_data_write
);

always @(clock) begin
    if (reset) begin
        MEM_pc<=EXE_pc;
        MEM_b<=EXE_b;
        MEM_c<=EXE_c;
        MEM_num_write<=EXE_num_write;
        MEM_mem_write<=EXE_mem_write;
        MEM_reg_write<=EXE_reg_write;
        MEM_s_data_write<=EXE_s_data_write;
    end
    else begin
        MEM_pc<=32'b0;
        MEM_b<=32'b0;
        MEM_c<=32'b0;
        MEM_num_write<=1'b0;
        MEM_mem_write<=1'b0;
        MEM_reg_write<=5'b0;
        MEM_s_data_write<=2'b0;
    end
end

endmodule