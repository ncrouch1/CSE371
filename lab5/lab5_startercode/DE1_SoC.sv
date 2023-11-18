/* Top level module of the FPGA that takes the onboard resources 
 * as input and outputs the lines drawn from the VGA port.
 *
 * Inputs:
 *   KEY 			- On board keys of the FPGA
 *   SW 			- On board switches of the FPGA
 *   CLOCK_50 		- On board 50 MHz clock of the FPGA
 *
 * Outputs:
 *   HEX 			- On board 7 segment displays of the FPGA
 *   LEDR 			- On board LEDs of the FPGA
 *   VGA_R 			- Red data of the VGA connection
 *   VGA_G 			- Green data of the VGA connection
 *   VGA_B 			- Blue data of the VGA connection
 *   VGA_BLANK_N 	- Blanking interval of the VGA connection
 *   VGA_CLK 		- VGA's clock signal
 *   VGA_HS 		- Horizontal Sync of the VGA connection
 *   VGA_SYNC_N 	- Enable signal for the sync of the VGA connection
 *   VGA_VS 		- Vertical Sync of the VGA connection
 */
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW, CLOCK_50, 
	VGA_R, VGA_G, VGA_B, VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS);
	
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	input CLOCK_50;
	output [7:0] VGA_R;
	output [7:0] VGA_G;
	output [7:0] VGA_B;
	output VGA_BLANK_N;
	output VGA_CLK;
	output VGA_HS;
	output VGA_SYNC_N;
	output VGA_VS;
	
	assign HEX0 = '1;
	assign HEX1 = '1;
	assign HEX2 = '1;
	assign HEX3 = '1;
	assign HEX4 = '1;
	assign HEX5 = '1;

	// create logic reset
    logic reset;
	// assign reset to inverted button 0
    assign reset = ~KEY[0];
	// given logic
	logic [10:0] x0, y0, x1, y1, x, y;

	// instantiate divided clocks
	logic [31:0] divided_clocks;
	clock_divider cd(.clock(CLOCK_50), .reset(~KEY[0]), .divided_clocks(divided_clocks));

	// create animation clock
	logic animation_clock;
	// assign animation clock
	assign animation_clock = divided_clocks[18];
	// create color container
	logic color;
	// assign color to white if not clearing, black if clearing
	assign color = (ps == clearing) ? 1'b0 : 1'b1;
	// instantiate buffer
	VGA_framebuffer fb (
		.clk50			(CLOCK_50), 
		.reset			(1'b0), 
		.x, 
		.y,
		.pixel_color	(color), 
		.pixel_write	(1'b1),
		.VGA_R, 
		.VGA_G, 
		.VGA_B, 
		.VGA_CLK, 
		.VGA_HS, 
		.VGA_VS,
		.VGA_BLANK_n	(VGA_BLANK_N), 
		.VGA_SYNC_n		(VGA_SYNC_N));
				
	// create line drawer helper logic and clearer done signal container
	logic line_done, line_start, done;
	// assign start to current state as idle
	assign line_start = (ps == idle);
	// create logic clearer reset
	logic clear_reset;
	// assign clearer reset to inverted button 3
	assign clear_reset = ~KEY[3];
	// create counter
    logic [3:0] counter;
	// create enums and state containers
 	enum {idle, draw_line, clearing} ps, ns;
 	
	// state logic
 	always_comb begin
		// put this so no latching error
 	    x0 = 0; y0 = 0; x1 = 1; y1 = 1;
 	    case(ps) 
 	        idle: begin
				// load in next lines coordinates
                x0 = 0 + (counter * 20);
                y0 = 0 + (counter * 20);
                x1 = 50 + (counter * 20);
                y1 = 50 + (counter * 20);
				// traverse to draw line
                ns = draw_line;
 	        end
 	        draw_line: begin
				// assert line coordinates are correct still
 	            x0 = 0 + (counter * 20);
                y0 = 0 + (counter * 20);
                x1 = 50 + (counter * 20);
                y1 = 50 + (counter * 20);
				// if line done move to clearing else continue drawing
                ns = line_done ? clearing : draw_line;
 	        end
 	        clearing: begin
				// if clearer done move to idle, else remain in clearing
 	            ns = done ? idle : clearing;
 	        end
 	        default: begin
				// default load in no latch coords and goto idle
 	            x0 = 0;
 	            y0 = 0;
 	            x1 = 1;
 	            y1 = 1;
 	            ns = idle;
 	       end
 	    endcase
 	end
 	
	// containers for line drawer x,y and clearer x,y
 	logic [10:0] x_cont, y_cont, x_clear, y_clear;
	// declare clearer
 	screen_clearer sc (.clock(CLOCK_50), .done(done), .start(ps == clearing), .reset(reset), .x(x_clear), .y(y_clear));
    
	// on line_start rising edge
    always @(posedge line_start) begin
		// if the reset is high go back to 0
        if (reset)
            counter <= 0;
		// else increment counter
        else
            counter <= counter + 1;
    end
    
	// on animation clock rising edge
 	always_ff @(posedge animation_clock) begin
		// if reset goto idle
 		if (reset) begin
 			ps <= idle;
 		end
		// else if clearer reset goto clearing
 		else if (clear_reset)
 		    ps <= clearing;
		// else goto next state
 		else begin
 			ps <= ns;
 		end
 	end

	// create line drawer
	line_drawer lines (.clk(animation_clock), .reset(line_start),.x0, .y0, .x1, .y1, .x(x_cont), .y(y_cont), .done(line_done));
	// if clearing get coords from clearer else get from drawer
	assign x = (ps == clearing) ? x_clear : x_cont;
	assign y = (ps == clearing) ? y_clear : y_cont;
	// assign LEDR 9 to done, set rest to LOW
	assign LEDR[9] = done;
	assign LEDR[8:0] = 9'b000000000;


endmodule  // DE1_SoC
