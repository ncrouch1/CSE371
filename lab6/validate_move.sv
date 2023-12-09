/* 
Noah Crouch 2078812
Henri Lower   2276644
EE/CSE 371
Lab 6 Report
12/08/2023

    Validate move module ensures that only one
    input is taken in per switch per game. 
    
    Inputs
        metaSW      - transitionary switch value
        gamestate   - tracks which values have been asserted from switches
        enable      - start signal
        
    Outputs:
        valid       - single bit value that represents the status of an input
*/
module validate_move (
    input logic [9:0] metaSW,
    input logic [1:0] gamestate [9:0],
    input logic enable,
    output logic valid
);

    // Combinational logic that checks validity of input
    always_comb begin : validate_input
        case({enable, metaSW})
            // if enable is high and metaSW 1 is active
            11'b10000000001: begin
                valid = (gamestate[0] == 2'b00) ? 1'b1 : 1'b0;
            end
            // if enable is high and metaSW 2 is active
            11'b10000000010: begin
					valid = (gamestate[1] == 2'b00) ? 1'b1 : 1'b0;
            end
            // if enable is high and metaSW 3 is active
            11'b10000000100: begin
					valid = (gamestate[2] == 2'b00) ? 1'b1 : 1'b0;
            end
            // if enable is high and metaSW 4 is active
            11'b10000001000: begin
					valid = (gamestate[3] == 2'b00) ? 1'b1 : 1'b0;
            end
            // if enable is high and metaSW 5 is active
            11'b10000010000: begin
					valid = (gamestate[4] == 2'b00) ? 1'b1 : 1'b0;
            end
            // if enable is high and metaSW 6 is active
            11'b10000100000: begin
					valid = (gamestate[5] == 2'b00) ? 1'b1 : 1'b0;
            end
            // if enable is high and metaSW 7 is active
            11'b10001000000: begin
					valid = (gamestate[6] == 2'b00) ? 1'b1 : 1'b0;
            end
            // if enable is high and metaSW 8 is active
            11'b10010000000: begin
					valid = (gamestate[7] == 2'b00) ? 1'b1 : 1'b0;
            end
            // if enable is high and metaSW 9 is active
            11'b10100000000: begin
					valid = (gamestate[8] == 2'b00) ? 1'b1 : 1'b0;
            end  
            // Default case         
            default: valid = 1'b0;                                                                                                                 
        endcase          
    end
endmodule // validate_move

module validate_move_tb ();
    logic [9:0] metaSW;
    logic [1:0] gamestate [9:0];
    logic valid, enable;

    validate_move dut (.*);

    initial begin
        metaSW = 10'd1; enable = 1'b1;
        for (int i = 0; i < 10; i++) begin
            gamestate[i] = 2'b00;
        end
        #10;
        gamestate[0] = 2'b01;
        for (int i = 1; i < 9; i++) begin
            metaSW = (metaSW << 1'b1); #10;
            gamestate[i] = 2'b01; #10;
        end
        enable = 1'b0;          #10;
        metaSW = 10'd1;
        for (int i = 0; i < 10; i++) begin
            metaSW = (metaSW << 1'b1);  #10;
        end
        $stop;
    end
    
endmodule