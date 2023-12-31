/* 
Noah Crouch 2078812
Henri Lower   2276644
EE/CSE 371
Lab 6 Report
12/08/2023

Set move module that accounts for the player
order within the game 

Inputs: 
    metaSW          - intermediary switch value
    gamestate       - current gamestate represents player turn tied with switch
    player          - single bit value that represents the player
    enable          - start signal 
    reset           - reset signal
    clock           - clock signal to synchronize module

Outputs:
    gamestate_next - value of the next gamestate to process
*/
module set_move (
    input logic [9:0] metaSW,
    input logic [1:0] gamestate [9:0],
    input logic player, enable, reset, clock,
    output logic [1:0] gamestate_next [9:0]
);
    always_comb begin : set_move
        // reset condition
        if (reset) begin
            for (int i = 0; i < 10; i++) begin
                gamestate_next[i] = 2'b00;
            end
        end
		else begin
            // For each switch determine player tied to input
            case(metaSW)
                10'd1: begin
                    if (enable) begin
                        gamestate_next[0] = player? 2'b10 : 2'b01;
                    end    
                end
                10'd2: begin
                    if (enable) begin
                        gamestate_next[1] = player? 2'b10 : 2'b01;
                    end               
                end
                10'd4: begin
                    if (enable) begin
                        gamestate_next[2] = player? 2'b10 : 2'b01;
                    end
                end
                10'd8: begin
                    if (enable) begin
                        gamestate_next[3] = player? 2'b10 : 2'b01;
                    end            
                end
                10'd16: begin
                    if (enable) begin
                        gamestate_next[4] = player? 2'b10 : 2'b01;
                    end
                end
                10'd32: begin
                    if (enable) begin
                        gamestate_next[5] = player? 2'b10 : 2'b01;
                    end                
                end
                10'd64: begin
                    if (enable) begin
                        gamestate_next[6] = player? 2'b10 : 2'b01;
                    end
                end
                10'd128: begin
                    if (enable) begin
                        gamestate_next[7] = player? 2'b10 : 2'b01;
                    end
                end
                10'd256: begin
                    if (enable) begin
                        gamestate_next[8] = player? 2'b10 : 2'b01;
                    end
                end         
                default: gamestate_next = gamestate;
            endcase
        end
    end
endmodule // set_move

module set_move_tb();
    logic [9:0] metaSW;
    logic [1:0] gamestate [9:0];
    logic enable, player, reset, clock;
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
        for (int i = 0; i < 5; i++) begin
            metaSW <= (metaSW << 1); #10;
        end
        enable = 1'b0; player = 1'b0;	#10;
        for (int i = 0; i < 5; i++) begin
            metaSW <= (metaSW << 1); #10;
        end
        $stop;
    end
endmodule