module set_move (
    input logic [9:0] metaSW,
    input logic [1:0] gamestate [9:0],
    input logic player, enable,
    output logic [1:0] gamestate_next [9:0]
    output logic set
);
	
    always_comb begin : set_move
        case(metaSW)
            10'd1: begin
                if (enable) begin
                    gamestate_next = gamestate;
                    gamestate_next[0] = player? 2'b10 : 2'b01;
                end    
            end
            10'd2: begin
                if (enable) begin
                    gamestate_next = gamestate;
                    gamestate_next[1] = player? 2'b10 : 2'b01;
                end                end
            10'd4: begin
                if (enable) begin
                    gamestate_next = gamestate;
                    gamestate_next[2] = player? 2'b10 : 2'b01;
                end                end
            10'd8: begin
                if (enable) begin
                    gamestate_next = gamestate;
                    gamestate_next[3] = player? 2'b10 : 2'b01;
                end                end
            10'd16: begin
                if (enable) begin
                    gamestate_next = gamestate;
                    gamestate_next[4] = player? 2'b10 : 2'b01;
                end                end
            10'd32: begin
                if (enable) begin
                    gamestate_next = gamestate;
                    gamestate_next[5] = player? 2'b10 : 2'b01;
                end                end
            10'd64: begin
                if (enable) begin
                    gamestate_next = gamestate;
                    gamestate_next[6] = player? 2'b10 : 2'b01;
                end                end
            10'd128: begin
                if (enable) begin
                    gamestate_next = gamestate;
                    gamestate_next[7] = player? 2'b10 : 2'b01;
                end                end
            10'd256: begin
                if (enable) begin
                    gamestate_next = gamestate;
                    gamestate_next[8] = player? 2'b10 : 2'b01;
                end                end
            10'd512: begin
                gamestate_next = gamestate;
            end           
            default: gamestate_next = gamestate;
        endcase          
    end
endmodule

module set_move_tb();
    logic [9:0] metaSW;
    logic [1:0] gamestate [9:0];
    logic enable, player, valid;
    logic [1:0] gamestate_next [9:0];

    set_move dut (.*);

    initial begin
        metaSW = 10'b0; enable = 1'b0; player = 1'b0;
        for (int i = 0; i < 10; i++) begin
            gamestate[i] = 2'b00;
        end
        #10;
        metaSW = 10'd1; enable = 1'b1; player = 1'b1; #10
		metaSW = 10'd1; player = 1'b0; #10;
        $stop;
    end
endmodule