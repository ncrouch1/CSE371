module moduleName (
    input logic [9:0] metaSW,
    input logic [9:0] gamestate [1:0],
    input logic valid, player
    output logic [9:0] gamestate_next [1:0]
);

    always_comb begin : validate_input
        case(metaSW)
            10'd1: begin
                if (valid) begin
                    gamestate_next = gamestate;
                    gamestate_next[0] = player? 2'b10 : 2'b01;
                end    
            end
            10'd2: begin
                if (valid) begin
                    gamestate_next = gamestate;
                    gamestate_next[1] = player? 2'b10 : 2'b01;
                end                end
            10'd4: begin
                if (valid) begin
                    gamestate_next = gamestate;
                    gamestate_next[2] = player? 2'b10 : 2'b01;
                end                end
            10'd8: begin
                if (valid) begin
                    gamestate_next = gamestate;
                    gamestate_next[3] = player? 2'b10 : 2'b01;
                end                end
            10'd16: begin
                if (valid) begin
                    gamestate_next = gamestate;
                    gamestate_next[4] = player? 2'b10 : 2'b01;
                end                end
            10'd32: begin
                if (valid) begin
                    gamestate_next = gamestate;
                    gamestate_next[5] = player? 2'b10 : 2'b01;
                end                end
            10'd64: begin
                if (valid) begin
                    gamestate_next = gamestate;
                    gamestate_next[6] = player? 2'b10 : 2'b01;
                end                end
            10'd128: begin
                if (valid) begin
                    gamestate_next = gamestate;
                    gamestate_next[7] = player? 2'b10 : 2'b01;
                end                end
            10'd256: begin
                if (valid) begin
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