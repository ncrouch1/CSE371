module input_handler (clk, reset, SW, button, drawing, player, metaSW, holding, gameover, valid, line_draw_done);

	input logic clk, reset, valid, line_draw_done;
	input logic [9:0] SW;
	input logic button, drawing, player;
	output logic [9:0] metaSW;
	output logic holding, gameover;

	logic [1:0] gamestate [9:0];
    logic [1:0] gamestate_next [9:0];
	enum {reading, hold, hold2} ps, ns;
	assign holding = (ps != reading);
	//assign enable_validation = 

	// State logic
    always_ff begin 
        case(ps)
            reading: begin
                metaSW <= SW;
                ns = reading;
                if (button)
                    ns = hold;
            end
            hold: ns =  valid ? hold2 : reading;
            hold2: ns = drawing ? hold2 : reading;
				default: ns = ps;
        endcase
    end
    
    always_ff @(posedge clk) begin
        if (reset)
            ps <= reading;
        else
            ps <= ns;
        if (ps == hold2)
            gamestate <= gamestate_next;
    end
endmodule

module input_handler_tb();
    logic [9:0] SW, metaSW;
    logic clk, reset, button, holding, valid;
endmodule