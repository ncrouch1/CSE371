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
	assign LEDR[8:0] = SW[8:0];
	
	logic [10:0] x0, y0, x1, y1, x, y;

	logic [31:0] divided_clocks;
	clock_divider cd(.clock(CLOCK_50), .reset(KEY[0]), .divided_clocks(divided_clocks));

	logic animation_clock;
	assign animation_clock = divided_clocks[13];
	
	VGA_framebuffer fb (
		.clk50			(CLOCK_50), 
		.reset			(1'b0), 
		.x, 
		.y,
		.pixel_color	(1'b1), 
		.pixel_write	(1'b1),
		.VGA_R, 
		.VGA_G, 
		.VGA_B, 
		.VGA_CLK, 
		.VGA_HS, 
		.VGA_VS,
		.VGA_BLANK_n	(VGA_BLANK_N), 
		.VGA_SYNC_n		(VGA_SYNC_N));
				
	logic line_done, done;

	enum {top_left, top_right, bottom_right, bottom_left, clearing} ps, ns;
	always_comb begin
	    x0 = 0; x1 = 0; y0 = 0; y1 = 0;
		case (ps)
			top_left: begin
				x0 = 0;
				y0 = 100;
				x1 = 100;
				y1 = 0;
				ns = line_done ? top_right : top_left;
			end
			top_right: begin
				x0 = 100;
				y0 = 0;
				x1 = 200;
				y1 = 100;
				ns = line_done ? bottom_right : top_right;
			end
			bottom_right: begin
				x0 = 200;
				y0 = 100;
				x1 = 100;
				y1 = 200;
				ns = line_done ? bottom_left : bottom_right;
			end
			bottom_left: begin
				x0 = 100;
				y0 = 200;
				x1 = 0;
				y1 = 100;
				ns = line_done ? clearing : bottom_left;
			end
			clearing: begin
				ns = done ? top_left : clearing;
			end
			default: begin
			    x0 = 0;
			    x1 = 0;
			    y0 = 0;
			    y1 = 0;
			    ns = top_left;
			end
		endcase
	end

	always_ff @(posedge CLOCK_50) begin
		if (KEY[0]) begin
			ps <= top_left;
		end
		else begin
			ps <= ns;
		end
	end
	
	line_drawer lines (.clk(animation_clock), .reset(((ps != clearing) & line_done)),.x0, .y0, .x1, .y1, .x, .y, .done(line_done));
	
	assign LEDR[9] = done;


endmodule  // DE1_SoC
