module side(
  input clock,
  input[1:0]MEM_s_data_write,
  input[5:0]op,
  input[4:0]EXE_num_write,rs,rt,MEM_num_write,WB_num_write,
  input EXE_reg_write,WB_reg_write,MEM_reg_write,
  output reg[1:0]  s_forwardA,s_forwardB,
  output reg[1:0] ID_forwardA,ID_forwardB
);
always@(posedge clock)begin
  if (rs==EXE_num_write&&EXE_reg_write==1'b1&&rs!=5'b0) begin
    s_forwardA=2'b00;
  end 
  else begin
      if(rs==MEM_num_write&&MEM_reg_write==1'b1&&rs!=5'b0)begin
      s_forwardA=2'b01;
  end
  else begin
    s_forwardA=2'b10;
  end
  end

  if (rt==EXE_num_write&&EXE_reg_write==1'b1&&rt!=5'b0) begin
    s_forwardB=2'b00;
  end 
  else begin
     if(rt==MEM_num_write&&MEM_reg_write==1'b1&&rt!=5'b0)begin
      s_forwardB=2'b01;
  end
  else begin
    s_forwardB=2'b10;
  end

  end
end


always@(*)begin
  if(MEM_num_write==rs&&MEM_reg_write==1'b1&&rs!=5'b0&&op==6'b000100&&MEM_s_data_write==2'b00)begin
     ID_forwardA=2'b10;
  end
  else if (WB_num_write==rs&&WB_reg_write==1'b1&&rs!=5'b0) begin
    ID_forwardA=2'b00;
  end

  else begin
    ID_forwardA=2'b01;
  end
  if(MEM_num_write==rt&&MEM_reg_write==1'b1&&rt!=5'b0&&op==6'b000100&&MEM_s_data_write==2'b00)begin
     ID_forwardB=2'b10;   
  end
  else if (WB_num_write==rt&&WB_reg_write==1'b1&&rt!=5'b0) begin
    ID_forwardB=2'b00;
  end

  else begin
    ID_forwardB=2'b01;
  end
end
endmodule