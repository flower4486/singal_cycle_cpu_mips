module mux2to1_5(
    input[4:0] num1,
    input[4:0]  num2,
    input sel,
    output[4:0]  result
);
assign result=(sel==1'b0)?num1:
                num2;
endmodule

module mux3to1_5(
    input[4:0] num1,
    input[4:0]  num2,
    input[4:0] num3,
    input[1:0] sel,
    output[4:0]  result
);
 assign result=(sel==2'b00)?num1:
                                (sel==2'b01)?num2:num3;

endmodule
