module blockside (
    input[4:0]EXE_num_write,rs,rt,
    input[5:0]op,
    input[1:0]EXE_s_data_write,
    input EXE_reg_write,
    output reg IF_ID_write,ID_EXE_flush,pc_write
);
    always@(*)begin
        if(
        (
        (EXE_num_write==rs&&op!=6'b0)//i型指令
        ||((EXE_num_write==rs||EXE_num_write==rt)&&(op==6'b0))//R型指令
        )
        &&EXE_reg_write==1'b1&&EXE_s_data_write==2'b01)begin
            IF_ID_write<=1'b1;
            ID_EXE_flush<=1'b1;
            pc_write<=1'b1;
        end
        else begin
            IF_ID_write<=1'b0;
            ID_EXE_flush<=1'b0;
            pc_write<=1'b0;
        end
    end
endmodule