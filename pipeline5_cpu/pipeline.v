module pipeline_cpu(clock, reset);

input clock;
input reset;
wire [31:0] pc,npc,instruction;
wire [31:0]a,b,alusrc;
wire[4:0]rs,rt,num_write;
wire[31:0]data_write,data_read,EXE_c;
wire[31:0]reg_addr,abs_addr,beq_addr,beq_pc;
wire zero;
wire[31:0] ex_imm;
wire[1:0]s_npc;
// assign abs_addr={pc[31:28],instruction[25:0],2'b0};
// assign reg_addr=a;
// assign beq_pc={{16{instruction[15]}},instruction[15:0]<<2}+pc+4;
//ID级的变量
wire [31:0]ID_pc,ID_instruction;
wire[31:0]rs_data,rt_data;
//WB级的变量
wire[31:0]WB_c,WB_pc,WB_data_read,WB_data_write;
wire[1:0]WB_s_data_write;
wire WB_reg_write;
wire[4:0]WB_num_write;

//MEM级的变量
wire[31:0]MEM_pc,MEM_b,MEM_c;
wire[4:0]MEM_num_write;
wire[1:0]MEM_s_data_write;
wire MEM_reg_write,MEM_mem_write;

//EXE级的变量
wire [5:0]EXE_alu_ctrl;
wire[1:0]EXE_s_data_write;
wire EXE_s_b,EXE_mem_write,EXE_reg_write;
wire[31:0]EXE_a,EXE_b,EXE_pc,EXE_ex_imm;
wire[4:0]EXE_num_write,sa,EXE_sa;

//旁路的变量
wire[1:0] ID_forwardA,ID_forwardB;
wire pc_write,IF_ID_write,ID_EXE_flush,IF_ID_flush;
pc PC(
.pc(pc),
.pc_write(pc_write),
.clock(clock),
.reset(reset),
.npc(npc)
);
//assign npc=;

// mux4to1_32 mux_pc(
//     .num1(pc+4),
//     .num2(abs_addr),
//     .num3(reg_addr),
//     .num4(beq_addr),
//     .sel(s_npc),
//     .result(npc)
// );
im IM(
    .instruction(instruction),
    .pc(pc)
);

blockside BLOCKSIDE(
    .EXE_num_write(EXE_num_write),
    .MEM_num_write(MEM_num_write),
    .rs(rs),
    .rt(rt),
    .op(ID_instruction[31:26]),
    .EXE_s_data_write(EXE_s_data_write),
    .EXE_reg_write(EXE_reg_write),
    .MEM_s_data_write(MEM_s_data_write),
    .MEM_reg_write(MEM_reg_write),
    .IF_ID_write(IF_ID_write),
    .ID_EXE_flush(ID_EXE_flush),
    .pc_write(pc_write)
);
//IF_ID寄存器//////////////////////////////////////////////////////////////////////////////////

IF_ID tranIF_ID(
    .clock(clock),
    .reset(reset),
    .IF_ID_write(IF_ID_write),
    .IF_ID_flush(IF_ID_flush),
    .IF_pc(pc),
    .IF_instruction(instruction),
    .ID_pc(ID_pc),
    .ID_instruction(ID_instruction)
);
wire ID_zero;
//pc多选器
assign abs_addr={ID_pc[31:28],ID_instruction[25:0],2'b0};
assign reg_addr=rs_data;
assign zero=(rs_data-rt_data==0)?1'b0:1'b1;
assign beq_pc={{16{ID_instruction[15]}},ID_instruction[15:0]<<2}+ID_pc+4;
mux2to1_32 beq2to1(
    .num1(beq_pc),
    .num2(pc+4),
    .sel(zero),
    .result(beq_addr)
);
mux4to1_32 mux_pc(
    .num1(pc+4),//这么搞是为了lw的阻塞
    .num2(abs_addr),
    .num3(reg_addr),
    .num4(beq_addr),
    .sel(s_npc),
    .result(npc)
);
assign IF_ID_flush=(s_npc==2'b00||(s_npc==2'b11&&zero))?1'b0:1'b1;

//控制信号
wire[5:0]alu_ctrl;
wire s_b,s_ext,mem_write,reg_write;
wire[1:0]s_num_write,s_data_write;
ctrl CTRL(
    .instruction(ID_instruction),
    .reset(reset),
    .alu_ctrl(alu_ctrl),
    .s_ext(s_ext),
    .s_b(s_b),
    .s_num_write(s_num_write),
    .mem_write(mem_write),
    .s_data_write(s_data_write),
    .reg_write(reg_write),
    .s_npc(s_npc)
);
assign rs=ID_instruction[25:21];
assign rt=ID_instruction[20:16];
assign sa=ID_instruction[10:6];
wire [15:0]imm;
assign imm=ID_instruction[15:0];


eximm16 eximm16(
    .num16(imm),
    .num32(ex_imm),
    .sign(s_ext)
);

mux3to1_5 mux_wreg(
    .num1(rt),
    .num2(ID_instruction[15:11]),
    .num3(5'b11111),
    .sel(s_num_write),
    .result(num_write)
);

gpr GPR(
.a(a),
.b(b),
.clock(clock),
.reg_write(WB_reg_write),
.rs(rs),
.rt(rt),
.num_write(WB_num_write),
.data_write(WB_data_write)
);
mux3to1_32 RSDATA(
    .num1(WB_data_write),
    .num2(a),
    .num3(MEM_c),
    .sel(ID_forwardA),
    .result(rs_data)
);

mux3to1_32 RTDATA(
    .num1(WB_data_write),
    .num2(b),
    .num3(MEM_c),
    .sel(ID_forwardB),
    .result(rt_data)
);

//ID_EXE寄存器////////////////////////////////////////////////////////////////////////////

ID_EXE tarnID_EXE(
    .clock(clock),
    .reset(reset),
    .ID_sa(sa),
    .EXE_sa(EXE_sa),
    .ID_EXE_flush(ID_EXE_flush),
    .ID_alu_ctrl(alu_ctrl),
    .EXE_alu_ctrl(EXE_alu_ctrl),
    .ID_s_data_write(s_data_write),
    .EXE_s_data_write(EXE_s_data_write),
    .ID_s_b(s_b),
    .ID_mem_write(mem_write),
    .ID_reg_write(reg_write),
    .EXE_s_b(EXE_s_b),
    .EXE_mem_write(EXE_mem_write),
    .EXE_reg_write(EXE_reg_write),
    .ID_pc(ID_pc),
    .ID_a(rs_data),
    .ID_b(rt_data),
    .EXE_pc(EXE_pc),
    .EXE_a(EXE_a),
    .EXE_b(EXE_b),
    .ID_ex_imm(ex_imm),
    .EXE_ex_imm(EXE_ex_imm),
    .ID_num_write(num_write),
    .EXE_num_write(EXE_num_write)
);
wire[1:0] s_forwardA,s_forwardB;
wire[31:0]alusrc1,alusrc2;
side SIDE(
    .clock(clock),
    .MEM_s_data_write(MEM_s_data_write),
    .EXE_num_write(EXE_num_write),
    .MEM_num_write(MEM_num_write),
    .WB_num_write(WB_num_write),
    .rs(rs),
    .rt(rt),
    .op(ID_instruction[31:26]),
    .EXE_reg_write(EXE_reg_write),
    .WB_reg_write(WB_reg_write),
    .MEM_reg_write(MEM_reg_write),
    .s_forwardA(s_forwardA),
    .s_forwardB(s_forwardB),
    .ID_forwardA(ID_forwardA),
    .ID_forwardB(ID_forwardB)
);
mux3to1_32 ALUSRC1(
    .num1(MEM_c),
    .num2(WB_data_write),
    .num3(EXE_a),
    .sel(s_forwardA),
    .result(alusrc1)
);
mux3to1_32 ALUSRC2(
    .num1(MEM_c),
    .num2(WB_data_write),
    .num3(EXE_b),
    .sel(s_forwardB),
    .result(alusrc)
);

mux2to1_32 mux_alusrc(
    .num1(alusrc),
    .num2(EXE_ex_imm),
    .sel(EXE_s_b),
    .result(alusrc2)//exe级内部信号
);
alu ALU(
    .sa(EXE_sa),

    .c(EXE_c),
    .a(alusrc1),
    .b(alusrc2),
    .alu_ctrl(EXE_alu_ctrl)
);

////EXE_MEM寄存器////////////////////////////////////////////////////////////////

EXE_MEM tranEXE_MEM(
    .reset(reset),
    .clock(clock),
    .EXE_pc(EXE_pc),
    .EXE_b(alusrc),
    .EXE_c(EXE_c),
    .EXE_num_write(EXE_num_write),
    .MEM_pc(MEM_pc),
    .MEM_b(MEM_b),
    .MEM_c(MEM_c),
    .MEM_num_write(MEM_num_write),
    .EXE_mem_write(EXE_mem_write),
    .EXE_reg_write(EXE_reg_write),
    .MEM_mem_write(MEM_mem_write),
    .MEM_reg_write(MEM_reg_write),
    .EXE_s_data_write(EXE_s_data_write),
    .MEM_s_data_write(MEM_s_data_write)
);
wire[31:0] DM_datain;
memside MEMSIDE(
    .clock(clock),
    .MEM_num_write(MEM_num_write),
    .WB_num_write(WB_num_write),
    .WB_s_data_write(WB_s_data_write),
    .MEM_mem_write(MEM_mem_write),
    .WB_reg_write(WB_reg_write),
    .MEM_forward(MEM_forward)
);

mux2to1_32 DMDATA(
    .num1(MEM_b),
    .num2(WB_data_read),
    .sel(MEM_forward),
    .result(DM_datain)
);

dm DM(
 .data_out(data_read),
 .clock(clock),
 .mem_write(MEM_mem_write),
 .address(MEM_c),
 .data_in(DM_datain)
);

///////////MEM_WB寄存器////////////////////////////////////////
MEM_WB tranMEM_WB(
    .reset(reset),
    .clock(clock),
    .MEM_c(MEM_c),
    .MEM_data_read(data_read),
    .MEM_pc(MEM_pc),
    .WB_c(WB_c),
    .WB_data_read(WB_data_read),
    .WB_pc(WB_pc),
    .MEM_s_data_write(MEM_s_data_write),
    .WB_s_data_write(WB_s_data_write),
    .MEM_num_write(MEM_num_write),
    .WB_num_write(WB_num_write),
    .MEM_reg_write(MEM_reg_write),
    .WB_reg_write(WB_reg_write)
);
mux3to1_32 mux_wb(
    .num1(WB_c),
    .num2(WB_data_read),
    .num3(WB_pc+4),
    .sel(WB_s_data_write),
    .result(WB_data_write)
);
endmodule



