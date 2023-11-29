module validate_move (
    input logic [9:0] metaSW;
    input logic [9:0] gamestate [1:0]
    output logic valid
);

    always_comb begin : validate_input
        case(metaSW)
            10'd1: begin
                valid = (gamestate[0] == 2'b00) ? 1'b1 : 1'b0;
            end
            10'd2: begin
                valid = (gamestate[1] == 2'b00) ? 1'b1 : 1'b0;
            end
            10'd4: begin
                valid = (gamestate[2] == 2'b00) ? 1'b1 : 1'b0;
            end
            10'd8: begin
                valid = (gamestate[3] == 2'b00) ? 1'b1 : 1'b0;
            end
            10'd16: begin
                valid = (gamestate[4] == 2'b00) ? 1'b1 : 1'b0;
            end
            10'd32: begin
                valid = (gamestate[5] == 2'b00) ? 1'b1 : 1'b0;
            end
            10'd64: begin
                valid = (gamestate[6] == 2'b00) ? 1'b1 : 1'b0;
            end
            10'd128: begin
                valid = (gamestate[7] == 2'b00) ? 1'b1 : 1'b0;
            end
            10'd256: begin
                valid = (gamestate[8] == 2'b00) ? 1'b1 : 1'b0;
            end
            10'd512: begin
                valid = 1'b0;
            end           
            default: valid = 1'b0;                                                                                                                 
        endcase          
    end
endmodule

module validate_move_tb ()
    logic [9:0] metaSW;
    logic [9:0] gamestate [1:0];
    logic valid;

    initial begin
        metaSW = 10'b0;
        for (int i = 0; i < 10; i++) begin
            gamestate[i] = 2'b00;
        end
        #10;
        gamestate[0] = 2'b01;
        #10;
    end
    
endmodule