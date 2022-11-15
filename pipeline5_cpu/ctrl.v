 `include "include.v"
module ctrl(
    input[31:0]instruction,
    input reset,
    output reg[5:0]alu_ctrl,
    output reg s_ext,s_b,mem_write,reg_write,
    output reg[1:0]s_num_write,s_data_write,s_npc
);
always @(*) begin
    if(~reset)begin
         s_b=1'b0;
        s_ext=1'b1;
        s_num_write=2'b00;
        alu_ctrl=`add_op;
        mem_write=0;
        s_data_write=2'b01;
        reg_write=0;
        s_npc=2'b11;
    end
    else if (instruction[31:26]==6'b000000) begin
        s_b=1'b0;
        s_ext=1'b0;
        s_num_write=2'b01;
        mem_write=0;
        s_data_write=2'b00;
        reg_write=1;
        s_npc=2'b00;
        case (instruction[5:0])
        //addu
        6'b100001 :begin
            alu_ctrl=`addu_op;
        end 
        //subu
        6'b100011 :begin
            alu_ctrl=`subu_op;
        end
        //add
        6'b100000 :begin
            alu_ctrl=`add_op;
        end
        //and
        6'b100100 :begin
            alu_ctrl=`and_op;
        end
        //or
        6'b100101:begin
            alu_ctrl=`or_op;
        end
        //slt
        6'b101010 :begin
            alu_ctrl=`slt_op;
        end
        //jr
        6'b001000 :begin
            alu_ctrl=6'b0;
            mem_write=1'b0;
            reg_write=1'b0;
            s_npc=2'b10;
        end
        default:begin
            alu_ctrl=6'b000000;
            s_b=1'b0;
            s_ext=1'b1;
            s_num_write=2'b00;
            alu_ctrl=`add_op;
            mem_write=0;
            s_data_write=2'b01;
            reg_write=1;
            s_npc=2'b11;
        end
    endcase
    end
    //addi
    else if(instruction[31:26]==6'b001000)
    begin
        s_b=1'b1;
        s_ext=1'b1;
        s_num_write=2'b00;
        alu_ctrl=`add_op;
        mem_write=0;
        s_data_write=2'b00;
        reg_write=1;
        s_npc=2'b00;
    end
        //addiu
    else if(instruction[31:26]==6'b001001)
    begin
        s_b=1'b1;
        s_ext=1'b1;
        s_num_write=2'b00;
        alu_ctrl=`addu_op;
        mem_write=0;
        s_data_write=2'b00;
        reg_write=1;
        s_npc=2'b00;
    end

    //andi
    else if(instruction[31:26]==6'b001100)
    begin
        s_b=1'b1;
        s_ext=1'b0;
        s_num_write=2'b00;
        alu_ctrl=`and_op;
        mem_write=0;
        s_data_write=2'b00;
        reg_write=1;
        s_npc=2'b00;
    end

    //ori
    else if(instruction[31:26]==6'b001101)
    begin
        s_b=1'b1;
        s_ext=1'b0;
        s_num_write=2'b00;
        alu_ctrl=`or_op;
        mem_write=0;
        s_data_write=2'b00;
        reg_write=1;
        s_npc=2'b00;
    end

    //lui
    else if(instruction[31:26]==6'b001111)
    begin
        s_b=1'b1;
        s_ext=1'b0;
        s_num_write=2'b00;
        alu_ctrl=`lui_op;
        mem_write=0;
        s_data_write=2'b00;
        reg_write=1;
        s_npc=2'b00;
    end
    //sw
    else if(instruction[31:26]==6'b101011)
    begin
        s_b=1'b1;
        s_ext=1'b1;
        s_num_write=2'b00;
        alu_ctrl=`add_op;
        mem_write=1;
        s_data_write=2'b00;
        reg_write=0;
        s_npc=2'b00;
    end
    //lw
    else if(instruction[31:26]==6'b100011)
    begin
        s_b=1'b1;
        s_ext=1'b1;
        s_num_write=2'b00;
        alu_ctrl=`add_op;
        mem_write=0;
        s_data_write=2'b01;
        reg_write=1;
        s_npc=2'b00;
    end
        //j
    else if(instruction[31:26]==6'b000010)
    begin
        s_b=1'b1;
        s_ext=1'b1;
        s_num_write=2'b00;
        alu_ctrl=`add_op;
        mem_write=0;
        s_data_write=2'b01;
        reg_write=0;
        s_npc=2'b01;
    end
        //jal
    else if(instruction[31:26]==6'b000011)
    begin
        s_b=1'b1;
        s_ext=1'b1;
        s_num_write=2'b10;
        alu_ctrl=`add_op;
        mem_write=0;
        s_data_write=2'b10;
        reg_write=1;
        s_npc=2'b01;
    end
            //jr
    else if(instruction[31:26]==6'b000010)
    begin
        s_b=1'b1;
        s_ext=1'b1;
        s_num_write=2'b00;
        alu_ctrl=`add_op;
        mem_write=0;
        s_data_write=2'b01;
        reg_write=0;
        s_npc=2'b10;
    end
              //beq
    else if(instruction[31:26]==6'b000100)
    begin
        s_b=1'b0;
        s_ext=1'b1;
        s_num_write=2'b00;
        alu_ctrl=`add_op;
        mem_write=0;
        s_data_write=2'b01;
        reg_write=0;
        s_npc=2'b11;
    end
    else begin
            s_b=1'b0;
        s_ext=1'b1;
        s_num_write=2'b00;
        alu_ctrl=`add_op;
        mem_write=0;
        s_data_write=2'b01;
        reg_write=0;
        s_npc=2'b11;
    end
end
endmodule