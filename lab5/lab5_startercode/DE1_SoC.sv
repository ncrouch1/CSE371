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
	
	// Divided clock so output is visible
    logic clk;
    logic [6:0] divided_clocks = 0;
    always_ff @(posedge CLOCK_50) begin
        divided_clocks <= divided_clocks + 7'd1;
    end
    assign clk = divided_clocks[5];
	
	logic [10:0] x0, y0, x1, y1, x, y;
	logic done, reset, rreset;
	
	VGA_framebuffer fb (
		.clk50			(CLOCK_50), 
		.reset			(reset), 
		.x, 
		.y,
		.pixel_color	(done ? 1'b0 : 1'b1), 
		.pixel_write	(1'b1),
		.VGA_R, 
		.VGA_G, 
		.VGA_B, 
		.VGA_CLK, 
		.VGA_HS, 
		.VGA_VS,
		.VGA_BLANK_n	(VGA_BLANK_N), 
		.VGA_SYNC_n		(VGA_SYNC_N));
				
	
	
	always_ff @(posedge CLOCK_50) begin
		rreset <= ~KEY[0];
		reset  <= rreset;
	end

	line_drawer lines (.clk(clk), .reset(reset),.x0, .y0, .x1, .y1, .x, .y, .done);
	
	parameter T = 100;
	assign LEDR[9] = done;
	// 640 x 480
	// 1x = 64
	// 1y = 48
	
	integer i;
	reg [9:0] x_values [0:10], y_values [0:10];
	
	initial begin
		for (i = 0; i <= 640; i = i + 64) begin
        x_values[i / 64] = i;
		end
		
		for (i = 0; i <= 480; i = i + 48) begin
        y_values[i / 48] = i;
		end
	end
	
	reg [3:0] counter;
    reg [1:0] x_line [3:0] = '{default:0};
    reg [1:0] y_line [3:0] = '{default:0};
    
    initial begin
        x_line[0] = x_values[1];
        x_line[1] = x_values[3];
        x_line[2] = x_values[5];
        x_line[3] = x_values[7];
    
        y_line[0] = y_values[2];
        y_line[1] = y_values[4];
        y_line[2] = y_values[6];
        y_line[3] = y_values[8];
    end
    
	always_ff @(posedge clk) begin
	    if (reset) begin
			counter <= 0; // Reset counter
			x0 <= 0;
			y0 <= 0;
		end 
		
		if (done) begin
			if (counter < 5) begin
			    x0 <= x_line[counter];
				y0 <= y_line[counter];
				x1 <= x_line[counter + 1];
				y1 <= y_line[counter + 1];
				counter <= counter + 1;
			end 
			else begin
		        counter <= 0;
		    end
		end 
	end

endmodule  // DE1_SoC
