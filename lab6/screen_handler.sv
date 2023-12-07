/* Top level module of the FPGA that takes the onboard resources 
 * as input and outputs the lines drawn from the VGA port.
 *
 * Inputs:
 *   KEY 			- On board keys of the FPGA
 *   SW 			- On board switches of the FPGA
 *   CLOCK_50 		- On board 50 MHz clock of the FPGA
 *
 * Outputs:
 *   VGA_R 			- Red data of the VGA connection
 *   VGA_G 			- Green data of the VGA connection
 *   VGA_B 			- Blue data of the VGA connection
 *   VGA_BLANK_N 	- Blanking interval of the VGA connection
 *   VGA_CLK 		- VGA's clock signal
 *   VGA_HS 		- Horizontal Sync of the VGA connection
 *   VGA_SYNC_N 	- Enable signal for the sync of the VGA connection
 *   VGA_VS 		- Vertical Sync of the VGA connection
 */
module screen_handler (clk, reset, gamestate_next, player, done, start, line_draw_done,
                        VGA_R, VGA_G, VGA_B, VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS);
	
	input logic clk, reset;
	input logic [1:0] gamestate_next [9:0];
	input logic player, done, start, line_draw_done;
	
	output [7:0] VGA_R;
	output [7:0] VGA_G;
	output [7:0] VGA_B;
	output VGA_BLANK_N;
	output VGA_CLK;
	output VGA_HS;
	output VGA_SYNC_N;
	output VGA_VS;
	
	logic [10:0] x0, y0, x1, y1, x, y;
	logic rreset;
    logic [3:0] rom_address; 
    logic [87:0] rom_data;

	VGA_framebuffer fb (
		.clk50			(clk), 
		.reset			(reset), 
		.x				(x), 
		.y				(y),
		.pixel_color	(done ? 1'b0 : 1'b1), 
		.pixel_write	(1'b1),
		.VGA_R			(VGA_R), 
		.VGA_G			(VGA_G), 
		.VGA_B			(VGA_B), 
		.VGA_CLK		(VGA_CLK), 
		.VGA_HS			(VGA_HS), 
		.VGA_VS			(VGA_VS),
		.VGA_BLANK_n	(VGA_BLANK_N), 
		.VGA_SYNC_n		(VGA_SYNC_N));
				
	line_drawer lines (.clk(clk), .reset(line_reset), .x0(x0), .y0(y0), .x1(x1), .y1(y1), .x(x), .y(y), .done(line_draw_done));
	rom line_data(.address(rom_address), .clock(clk), .q(rom_data));
    // logic for grid design
	logic grid_done, grid_start;
	
	// line_draw_done signal asserted to input handler
	
	// reset for line_drawer
	logic line_reset;
	
	// enums states and state containers
    enum {idle, grid_line1, grid_line2, grid_line3, grid_line4, state_grid_done} ps, ns;

 	// counter to keep track of the current line
    logic [1:0] grid_counter;   
    logic [3:0] line_counter;

    // coordinate values for the four lines
    logic [10:0] grid_coordinates[3:0][3:0];
    
    initial begin
        grid_coordinates[0] = '{11'd80, 11'd248, 11'd400, 11'd248};   // Grid 1
        grid_coordinates[1] = '{11'd80, 11'd390, 11'd400, 11'd390};   // Grid 2
        grid_coordinates[2] = '{11'd186, 11'd106, 11'd186, 11'd532};  // Grid 3
        grid_coordinates[3] = '{11'd292, 11'd106, 11'd292, 11'd532};  // Grid 4
    end
    
    always_comb begin 
        // Check each switch
        case (gamestate_next[0])
            11'b10000000001 : begin 
                rom_address = 4'b0000;
                x0 = rom_data[10:0];
                y0 = rom_data[21:11];
                x1 = rom_data[32:22];
                y1 = rom_data[43:33];
            end
            default: begin
                x0 = grid_coordinates[grid_counter][0];
                y0 = grid_coordinates[grid_counter][1];
                x1 = grid_coordinates[grid_counter][2];
                y1 = grid_coordinates[grid_counter][3];
            end
        endcase
    end

    // State machine logic
    always_ff @(posedge clk) begin
        if (reset) begin
            ps <= idle;
            grid_counter <= 2'b00;
            line_counter <= 4'b0000;
        end else begin
            ps <= ns;
            grid_counter <= (ns == idle) ? grid_counter + 1 : grid_counter;
            line_counter <= (ns == idle) ? line_counter + 1 : line_counter;
        end
    end

    // State transition logic
    always_ff @(posedge clk) begin
        case (ps)
            idle: begin
                grid_start = start;
                // Need clear screen logic here
                ns = ~grid_start ? ps : grid_line1;
            end
            
            grid_line1: begin
                line_reset <= 1'b1;
                ns = done ? grid_line2 : grid_line1;
            end
            
            grid_line2: begin
                line_reset <= 1'b1;
                ns = done ? grid_line3 : grid_line2;
            end
            
            grid_line3: begin
                line_reset <= 1'b1;
                ns = done ? grid_line4 : grid_line3;
            end
            
            grid_line4: begin
                line_reset <= 1'b1;
                ns = done ? state_grid_done : grid_line4;
            end
            
            state_grid_done: begin
                grid_done <= 1'b1;
                ns = idle;
            end
            
            default: ns = idle;
        endcase
    end
endmodule  // DE1_SoC
