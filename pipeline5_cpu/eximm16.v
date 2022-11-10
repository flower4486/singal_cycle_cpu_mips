module eximm16(
    input[15:0]num16,
    input sign,
    output[31:0]num32
);
assign num32=(sign==1)?{{16{num16[15]}},num16[15:0]}:
                        {{16{1'b0}},num16[15:0]};
endmodule