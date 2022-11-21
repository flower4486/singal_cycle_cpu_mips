 `include "include.v"
module alu(c,a,b,alu_ctrl,sa);
output reg[31:0] c;
input [31:0] a;
input [31:0] b;
input[5:0]alu_ctrl;
input[4:0]sa;
wire[31:0]addu_result,subu_result,add_result,and_result,or_result,slt_result,lui_result,sll_result;

assign addu_result=a+b;

assign subu_result=a-b;

assign add_result=a+b;

assign and_result=a&b;

assign or_result=a|b;

assign slt_result=($signed(a)<$signed(b))?32'h1:32'h0;
assign sll_result=b<<sa;

assign lui_result={b[15:0],{16{1'b0}}};



always @* begin
        case (alu_ctrl)
                `add_op:c=add_result;
                `subu_op:c=subu_result;
                `addu_op:c=addu_result;
                `and_op:c=and_result;
                `or_op:c=or_result;
                `slt_op:c=slt_result;
                `lui_op:c=lui_result; 
                `sll_op:c=sll_result;
                default: c=0;
        endcase
end


endmodule