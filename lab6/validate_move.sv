module validate_move (
    input logic [9:0] metaSW,
    input logic [1:0] gamestate [9:0],
    input logic enable,
    output logic valid
);

    always_comb begin : validate_input
        case(metaSW)
            10'd1: begin
                if (enable)
                    valid = (gamestate[0] == 2'b00) ? 1'b1 : 1'b0;
            end
            10'd2: begin
                if (enable)
                    valid = (gamestate[1] == 2'b00) ? 1'b1 : 1'b0;
            end
            10'd4: begin
                if (enable)
                    valid = (gamestate[2] == 2'b00) ? 1'b1 : 1'b0;
            end
            10'd8: begin
                if (enable)
                    valid = (gamestate[3] == 2'b00) ? 1'b1 : 1'b0;
            end
            10'd16: begin
                if (enable)
                    valid = (gamestate[4] == 2'b00) ? 1'b1 : 1'b0;
            end
            10'd32: begin
                if (enable)
                    valid = (gamestate[5] == 2'b00) ? 1'b1 : 1'b0;
            end
            10'd64: begin
                if (enable)
                    valid = (gamestate[6] == 2'b00) ? 1'b1 : 1'b0;
            end
            10'd128: begin
                if (enable)
                    valid = (gamestate[7] == 2'b00) ? 1'b1 : 1'b0;
            end
            10'd256: begin
                if (enable)
                    valid = (gamestate[8] == 2'b00) ? 1'b1 : 1'b0;
            end
            10'd512: begin
                if (enable)
                    valid = 1'b0;
            end           
            default: if (enable) valid = 1'b0;                                                                                                                 
        endcase          
    end
endmodule

module validate_move_tb ();
    logic [9:0] metaSW;
    logic [1:0] gamestate [9:0];
    logic valid, enable;

    validate_move dut (.*);

    initial begin
        metaSW = 10'b1; enable = 1'b1;
        for (int i = 0; i < 10; i++) begin
            gamestate[i] = 2'b00;
        end
        #10;
        gamestate[0] = 2'b01;
        #10;
        $stop;
    end
    
endmodule