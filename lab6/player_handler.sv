module player_handler (clk, player, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
    
    input logic clk;
    //input logic switch_flipped; // Signal indicating a switch is flipped
    //input logic screen_logic_processed; // Signal indicating the screen logic is processed
    output logic player;
    output logic [6:0] HEX0;
    output logic [6:0] HEX1;
    output logic [6:0] HEX2;
    output logic [6:0] HEX3;
    output logic [6:0] HEX4;
    output logic [6:0] HEX5;

    // Internal registers
    //logic [2:0] state_counter;

    // Outputs (for demonstration purposes; you can customize as needed)
    assign HEX1 = 7'b1111111;
    assign HEX2 = 7'b1111111;
    assign HEX3 = 7'b1111111;
    assign HEX4 = 7'b1111111;
    assign HEX5 = 7'b1111111;

    // always_ff @(posedge clk) begin
    //     if (switch_flipped || screen_logic_processed) begin
    //         // Toggle the player bit and reset the counter
    //         player <= ~player;
    //         state_counter <= 3'b000;
    //     end else begin
    //         // Increment the counter and toggle the player bit when counter reaches 4
    //         if (state_counter == 3'b100) begin
    //             player <= ~player;
    //             state_counter <= 3'b000;
    //         end else begin
    //             state_counter <= state_counter + 1;
    //         end
    //     end
    // end
	
    // HEX0 signal (you may adjust this logic based on your requirements)
    always_comb begin
        HEX0 = (player) ? 7'b1111110 : 7'b1111111;
    end

endmodule
