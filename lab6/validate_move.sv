module validate_move (
    input logic [9:0] metaSW,
    input logic [1:0] gamestate [9:0],
    input logic enable,
    output logic valid
);

    always_comb begin : validate_input
        case({enable, metaSW})
            11'b10000000001: begin
                valid = (gamestate[0] == 2'b00) ? 1'b1 : 1'b0;
            end
            11'b10000000010: begin
					 valid = (gamestate[1] == 2'b00) ? 1'b1 : 1'b0;
            end
            11'b10000000100: begin
					 valid = (gamestate[2] == 2'b00) ? 1'b1 : 1'b0;
            end
            11'b10000001000: begin
					 valid = (gamestate[3] == 2'b00) ? 1'b1 : 1'b0;
            end
            11'b10000010000: begin
					 valid = (gamestate[4] == 2'b00) ? 1'b1 : 1'b0;
            end
            11'b10000100000: begin
					 valid = (gamestate[5] == 2'b00) ? 1'b1 : 1'b0;
            end
            11'b10001000000: begin
					 valid = (gamestate[6] == 2'b00) ? 1'b1 : 1'b0;
            end
            11'b10010000000: begin
					 valid = (gamestate[7] == 2'b00) ? 1'b1 : 1'b0;
            end
            11'b10100000000: begin
					 valid = (gamestate[8] == 2'b00) ? 1'b1 : 1'b0;
            end           
            default: valid = 1'b0;                                                                                                                 
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