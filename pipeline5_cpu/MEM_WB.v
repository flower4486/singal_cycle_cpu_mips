module MEM_WB(
    input reset,clock,
    input[31:0]MEM_c,MEM_data_read,MEM_pc,
    output reg[31:0]WB_c,WB_data_read,WB_pc,
    input[1:0]MEM_s_data_write,
    output reg[1:0]WB_s_data_write,
    input[4:0]MEM_num_write,
    output reg[4:0]WB_num_write,
    input MEM_reg_write,
    output reg WB_reg_write
);
 always @(posedge clock) begin
    if (reset) begin
        WB_c<=MEM_c;
        WB_data_read<=MEM_data_read;
        WB_pc<=MEM_pc;
        WB_s_data_write<=MEM_s_data_write;
        WB_num_write<=MEM_num_write;
        WB_reg_write<=MEM_reg_write;
    end
    else begin
         WB_c<=0;
        WB_data_read<=0;
        WB_pc<=0;
        WB_s_data_write<=0;
        WB_num_write<=0;
        WB_reg_write<=0;
    end
 end

endmodule