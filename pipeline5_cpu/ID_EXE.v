module ID_EXE(
    input clock,reset,
    input[5:0]ID_alu_ctrl,
    output reg[5:0]EXE_alu_ctrl,
    input[1:0]ID_s_data_write,
    output reg[1:0]EXE_s_data_write,
    input ID_s_b,ID_mem_write,ID_reg_write,
    output reg EXE_s_b,EXE_mem_write,EXE_reg_write,
    input[31:0]ID_pc,ID_a,ID_b,
    output reg[31:0]EXE_pc,EXE_a,EXE_b,
    input[31:0]ID_ex_imm,
    output reg[31:0]EXE_ex_imm,
    input[4:0]ID_num_write,
    output reg[4:0]EXE_num_write
);
always @(posedge clock) begin
    if (reset) begin
        EXE_alu_ctrl<=ID_alu_ctrl;
        EXE_s_data_write<=ID_s_data_write;
        EXE_s_b<=ID_s_b;
        EXE_mem_write<=ID_mem_write;
        EXE_reg_write<=ID_reg_write;
        EXE_pc<=ID_pc;
        EXE_a<=ID_a;
        EXE_b<=ID_b;
        EXE_ex_imm<=ID_ex_imm;
        EXE_num_write<=ID_num_write;
    end
    else begin
        EXE_alu_ctrl<=6'b0;
        EXE_s_data_write<=2'b0;
        EXE_s_b<=1'b0;
        EXE_mem_write<=1'b0;
        EXE_reg_write<=1'b0;
        EXE_pc<=32'b0;
        EXE_a<=32'b0;
        EXE_b<=32'b0;
        EXE_ex_imm<=32'b0;
        EXE_num_write<=5'b0;
    end
end
endmodule