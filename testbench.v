module cputest();
reg  clock,reset;
s_cycle_cpu CPU(
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
    $display("pc=%h,s_npc=%d",CPU.pc,CPU.s_npc);
    $display("gpr31=%h,beq_pc=%h",CPU.GPR.gp_registers[31],CPU.beq_pc);
    end

//导入指令，初始化寄存器
integer i;
initial
begin
    $readmemh("code.txt",CPU.IM.ins_memory);
    for (i=0;i<32 ;i=i+1) begin
        CPU.GPR.gp_registers[i]=0;
    end
end

//产生reset信号
initial begin
    reset=1;
    #1 reset=0;
    #2 reset=1;
end
endmodule