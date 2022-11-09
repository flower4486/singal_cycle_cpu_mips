module s_cycle_cpu(clock,reset);

input clock;

input reset;

wire [31:0] pc,npc,instruction;

wire [31:0]a,b,alusrc;

wire[4:0]rs,rt,num_write;

wire[31:0]data_write,data_read,alu_data;
wire[31:0]reg_addr,abs_addr,beq_addr,beq_pc;

wire zero;
wire[31:0] ex_imm;
wire[1:0]s_npc;
assign abs_addr={pc[31:28],instruction[25:0],2'b0};
assign reg_addr=a;
assign beq_pc={{16{instruction[15]}},instruction[15:0]<<2}+pc+4;
pc PC(
.pc(pc),
.clock(clock),
.reset(reset),
.npc(npc)
);
mux2to1_32 beq2to1(
    .num1(beq_pc),
    .num2(pc+4),
    .sel(zero),
    .result(beq_addr)
);

mux4to1_32 mux_pc(
    .num1(pc+4),
    .num2(abs_addr),
    .num3(reg_addr),
    .num4(beq_addr),
    .sel(s_npc),
    .result(npc)
);


im IM(
    .instruction(instruction),
    .pc(pc)
);
//控制信号
wire[5:0]alu_ctrl;
wire s_b,s_ext,mem_write,reg_write;
wire[1:0]s_num_write,s_data_write;
ctrl CTRL(
    .instruction(instruction),
    .alu_ctrl(alu_ctrl),
    .s_ext(s_ext),
    .s_b(s_b),
    .s_num_write(s_num_write),
    .mem_write(mem_write),
    .s_data_write(s_data_write),
    .reg_write(reg_write),
    .s_npc(s_npc)
);
assign rs=instruction[25:21];
assign rt=instruction[20:16];
wire [15:0]imm;
assign imm=instruction[15:0];

eximm16 eximm16(
    .num16(imm),
    .num32(ex_imm),
    .sign(s_ext)
);

mux3to1_5 mux_wreg(
    .num1(rt),
    .num2(instruction[15:11]),
    .num3(5'b11111),
    .sel(s_num_write),
    .result(num_write)
);

gpr GPR(
.a(a),
.b(b),
.clock(clock),
.reg_write(reg_write),
.rs(rs),
.rt(rt),
.num_write(num_write),
.data_write(data_write)
);
mux2to1_32 mux_alusrc(
    .num1(b),
    .num2(ex_imm),
    .sel(s_b),
    .result(alusrc)
);
alu ALU(
    .zero(zero),
    .c(alu_data),
    .a(a),
    .b(alusrc),
    .alu_ctrl(alu_ctrl)
);


dm DM(
 .data_out(data_read),
 .clock(clock),
 .mem_write(mem_write),
 .address(alu_data),
 .data_in(b)
);
mux3to1_32 mux_wb(
    .num1(alu_data),
    .num2(data_read),
    .num3(pc+4),
    .sel(s_data_write),
    .result(data_write)
);
endmodule
