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

    logic reset;
    assign reset = ~KEY[0];
	logic [10:0] x0, y0, x1, y1, x, y;

	logic [31:0] divided_clocks;
	clock_divider cd(.clock(CLOCK_50), .reset(~KEY[0]), .divided_clocks(divided_clocks));

	logic animation_clock;
	assign animation_clock = divided_clocks[18];
	logic color;
	assign color = (ps == clearing) ? 1'b0 : 1'b1;
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
				
	logic line_done, line_start, done;
	assign line_start = (ps == idle);
	logic clear_reset;
	assign clear_reset = ~KEY[3];
    logic [3:0] counter;
 	enum {idle, draw_line, clearing} ps, ns;
 	
 	always_comb begin
 	    x0 = 0; y0 = 0; x1 = 1; y1 = 1;
 	    case(ps) 
 	        idle: begin
                x0 = 0 + (counter * 20);
                y0 = 0 + (counter * 20);
                x1 = 50 + (counter * 20);
                y1 = 50 + (counter * 20);
                ns = draw_line;
 	        end
 	        draw_line: begin
 	            x0 = 0 + (counter * 20);
                y0 = 0 + (counter * 20);
                x1 = 50 + (counter * 20);
                y1 = 50 + (counter * 20);
                ns = line_done ? clearing : draw_line;
 	        end
 	        clearing: begin
 	            ns = done ? idle : clearing;
 	        end
 	        default: begin
 	            x0 = 0;
 	            y0 = 0;
 	            x1 = 1;
 	            y1 = 1;
 	            ns = idle;
 	       end
 	    endcase
 	end
 	
 	logic [10:0] x_cont, y_cont, x_clear, y_clear;
 	screen_clearer sc (.clock(CLOCK_50), .done(done), .start(ps == clearing), .reset(reset), .x(x_clear), .y(y_clear));
    
    always @(posedge line_start) begin
        if (reset)
            counter <= 0;
        else
            counter <= counter + 1;
    end
    
    
 	always_ff @(posedge animation_clock) begin
 		if (reset) begin
 			ps <= idle;
 		end
 		else if (clear_reset)
 		    ps <= clearing;
 		else begin
 			ps <= ns;
 		end
 	end

	line_drawer lines (.clk(animation_clock), .reset(line_start),.x0, .y0, .x1, .y1, .x(x_cont), .y(y_cont), .done(line_done));
	assign x = (ps == clearing) ? x_clear : x_cont;
	assign y = (ps == clearing) ? y_clear : y_cont;
	assign LEDR[9] = done;
	assign LEDR[8:0] = 9'b000000000;


endmodule  // DE1_SoC
