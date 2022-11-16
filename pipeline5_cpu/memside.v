module memside(
input clock,
 input[4:0]MEM_num_write,WB_num_write,
 input[1:0]WB_s_data_write,
 input WB_reg_write,MEM_mem_write,
 output reg MEM_forward
);
always@(*)begin
   if(MEM_num_write==WB_num_write&&WB_s_data_write==2'b01&&MEM_mem_write==1'b1&&WB_reg_write==1) begin
    MEM_forward=1'b1;
   end 
   else begin
    MEM_forward=1'b0;
   end
end

endmodule