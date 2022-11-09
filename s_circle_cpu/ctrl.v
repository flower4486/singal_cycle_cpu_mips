

module ctrl(
    input[31:0]instruction,
    output reg[5:0]alu_ctrl
);
always @(*) begin
    
    case (instruction[5:0])
        6'b100001 :begin
            alu_ctrl=6'b000001;
        end 
        6'b100011 :begin
            alu_ctrl=6'b000010;
        end
        6'b100000 :begin
            alu_ctrl=6'b000100;
        end
        6'b100100 :begin
            alu_ctrl=6'b001000;
        end
        6'b100101:begin
            alu_ctrl=6'b010000;
        end
        6'b101010 :begin
            alu_ctrl=6'b100000;
        end
    endcase


end
endmodule