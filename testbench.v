module cputest();
reg  clock,reset;
pipeline_cpu CPU(
    .clock(clock),
    .reset(reset)
);
initial begin
  clock=0;
  forever begin
    #5 clock=~clock;
  end
end
always @(posedge clock) begin
   // $display("time=%3d",$time);
   $display("clock=%d",CPU.clock);
   //$display("GPR.numwrite=%h,GPR.datawrite=%h,s_data_write=%d,alu_data=%h",CPU.GPR.num_write,CPU.GPR.data_write,CPU.s_data_write,CPU.alu_data);
    $display("pc=%h,ID_instruction=%h",CPU.ID_pc,CPU.ID_instruction);
    //$display("gpr31=%h,beq_pc=%h",CPU.GPR.gp_registers[31],CPU.beq_pc);
    //$display("reg_write=%d,EXE_reg_write=%d,MEM_reg_write=%d,WB_reg_write=%d",CPU.reg_write,CPU.EXE_reg_write,CPU.MEM_reg_write,CPU.WB_reg_write);
    $display("forwardA=%d,forwardB=%d,alusrc1=%h,alusrc=%h,alusrc2=%h",CPU.s_forwardA,CPU.s_forwardB,CPU.alusrc1,CPU.alusrc,CPU.alusrc2);
    end

//导入指令，初始化寄存器
integer i;
initial
begin
    $readmemh("code.txt",CPU.IM.ins_memory);
    for (i=0;i<32 ;i=i+1) begin
        CPU.GPR.gp_registers[i]=i;
    end
end

//产生reset信号
initial begin
    reset=1;
    #1 reset=0;
    #2 reset=1;
end
endmodule