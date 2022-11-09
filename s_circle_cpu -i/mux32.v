
module mux2to1_32(
    input[31:0] num1,
    input[31:0]  num2,
    input sel,
    output[31:0]  result
);
assign result=(sel==1'b0)?num1:
                num2;

endmodule

module mux3to1_32(
    input[31:0] num1,
    input[31:0]  num2,
    input[31:0] num3,
    input[1:0] sel,
    output reg[31:0]  result
);
always@*begin
    case (sel)
        2'b00:result=num1;
        2'b01:result=num2; 
        2'b10:result=num3; 
        2'b11:result=32'b0; 
    endcase
end
endmodule

module mux4to1_32(
    input[31:0] num1,
    input[31:0]  num2,
    input[31:0] num3,
    input[31:0]num4,
    input[1:0] sel,
    output reg[31:0]  result
);
always@*begin
    case (sel)
        2'b00:result=num1;
        2'b01:result=num2; 
        2'b10:result=num3; 
        2'b11:result=num4; 
    endcase
end
endmodule