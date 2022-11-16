module side(
  input clock,
  input[4:0]EXE_num_write,rs,rt,
  input EXE_reg_write,
  output reg  s_forwardA,s_forwardB
);
always@(posedge clock)begin
  if (rs==EXE_num_write&&EXE_reg_write==1'b1&&rs!=5'b0) begin
    s_forwardA=1'b0;
  end 
  else begin
    s_forwardA=1'b1;
  end

  if (rt==EXE_num_write&&EXE_reg_write==1'b1&&rt!=5'b0) begin
    s_forwardB=1'b0;
  end 
  else begin
    s_forwardB=1'b1;
  end
end
endmodule