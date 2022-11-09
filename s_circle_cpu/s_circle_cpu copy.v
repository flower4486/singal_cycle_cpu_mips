module s_cycle_cpu(clock,reset);

input clock;

input reset;

wire [31:0] pc,npc,instruction;

wire [31:0]a,b;

wire[4:0]rs,rt,num_write;

wire[31:0]data_write;

wire[5:0]alu_ctrl;
pc PC(
.pc(pc),
.clock(clock),
.reset(reset),
.npc(npc)
);
assign npc=pc+4;

im IM(
    .instruction(instruction),
    .pc(pc)
);

ctrl CTRL(
    .instruction(instruction),
    .alu_ctrl(alu_ctrl)
);
assign rs=instruction[25:21];
assign rt=instruction[20:16];
assign num_write=instruction[15:11];

gpr GPR(
.a(a),
.b(b),
.clock(clock),
.reg_write(1),
.rs(rs),
.rt(rt),
.num_write(num_write),
.data_write(data_write)
);

alu ALU(
    .c(data_write),
    .a(a),
    .b(b),
    .alu_ctrl(alu_ctrl)
);

endmodule
