module alu(c,a,b,alu_ctrl);
output [31:0] c;
input [31:0] a;
input [31:0] b;
input[5:0]alu_ctrl;

wire[31:0]addu_result,subu_result,add_result,and_result,or_result,slt_result;

assign addu_result=a+b;

assign subu_result=a-b;

assign add_result=a+b;

assign and_result=a&b;

assign or_result=a|b;

assign slt_result=($signed(a)<$signed(b))?32'h1:32'h0;


assign c={32{alu_ctrl[0]}}&addu_result|
        {32{alu_ctrl[1]}}&subu_result|
        {32{alu_ctrl[2]}}&add_result|
        {32{alu_ctrl[3]}}&and_result|
        {32{alu_ctrl[4]}}&or_result|
        {32{alu_ctrl[5]}}&slt_result;

endmodule