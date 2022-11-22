module pc(pc,clock,reset,npc,pc_write);
output reg [31:0] pc;
input clock;
input reset;
input [31:0] npc;
input pc_write;

always @(posedge clock,negedge reset) begin
    if(~reset)
    begin
      pc<=32'h0000_3000;
      //npc<=32'h0000_3000;
    end
    else if(pc_write)
    begin
      pc<=pc;
    end
    else
    begin
      pc<=npc;
    end
end
endmodule
