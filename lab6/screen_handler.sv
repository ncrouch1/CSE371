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
module screenhandler (
	input logic clock, reset;
	input logic [9:0] gamestate_next [1:0];
	input logic valid, player;
	);
	
	output [7:0] VGA_R;
	output [7:0] VGA_G;
	output [7:0] VGA_B;
	output VGA_BLANK_N;
	output VGA_CLK;
	output VGA_HS;
	output VGA_SYNC_N;
	output VGA_VS;
	
	// Divided clock so output is visible
    logic clk;
    logic [6:0] divided_clocks = 0;
    always_ff @(posedge clock) begin
        divided_clocks <= divided_clocks + 7'd1;
    end
    assign clk = divided_clocks[5];
	
	logic [10:0] x0, y0, x1, y1, x, y;
	logic done, reset, rreset;

	VGA_framebuffer fb (
		.clk50			(clk), 
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

	line_drawer lines (.clk(clk), .reset(line_reset), .x0(x0), .y0(y0), .x1(x1), .y1(y1), .x(x), .y(y), .done);
	
    // logic for grid design
	logic grid_done, grid_start;
	
	// reset for line_drawer
	logic line_reset;
	
	// enums states and state containers
 	enum {idle, grid_line1, grid_line2, grid_line3, grid_line4, state_grid_done} ps, ns;
 	
 	// counter to keep track of the current line
    logic [1:0] grid_counter;
    logic [4:0] line_counter;

    // coordinate values for the four lines
    logic [10:0] grid_coordinates[3:0][3:0];
    logic [10:0] line_coordinates[8:0][3:0];
    
    initial begin
        grid_coordinates[0] = '{11'd80, 11'd248, 11'd400, 11'd248};   // Grid 1
        grid_coordinates[1] = '{11'd80, 11'd390, 11'd400, 11'd390};   // Grid 2
        grid_coordinates[2] = '{11'd186, 11'd106, 11'd186, 11'd532};  // Grid 3
        grid_coordinates[3] = '{11'd292, 11'd106, 11'd292, 11'd532};  // Grid 4
        
        line_coordinates[0] = '{11'd0, 11'd0, 11'd480, 11'd640};   // Line 1
        line_coordinates[1] = '{11'd80, 11'd390, 11'd400, 11'd390};   // Line 2
        line_coordinates[2] = '{11'd186, 11'd106, 11'd186, 11'd532};  // Line 3
        line_coordinates[3] = '{11'd292, 11'd106, 11'd292, 11'd532};  // Line 4
        line_coordinates[4] = '{11'd292, 11'd106, 11'd292, 11'd532};  // Line 5
        line_coordinates[5] = '{11'd292, 11'd106, 11'd292, 11'd532};  // Line 6
        line_coordinates[6] = '{11'd292, 11'd106, 11'd292, 11'd532};  // Line 7
        line_coordinates[7] = '{11'd292, 11'd106, 11'd292, 11'd532};  // Line 8
        line_coordinates[8] = '{11'd292, 11'd106, 11'd292, 11'd532};  // Line 9
    end

    // Output coordinates
    // assign x0 = grid_done ? line_coordinates[line_counter][0] : grid_coordinates[grid_counter][0];
    // assign y0 = grid_done ? line_coordinates[line_counter][1] : grid_coordinates[grid_counter][1];
    // assign x1 = grid_done ? line_coordinates[line_counter][2] : grid_coordinates[grid_counter][2];
    // assign y1 = grid_done ? line_coordinates[line_counter][3] : grid_coordinates[grid_counter][3];
    
    assign x0 = grid_coordinates[grid_counter][0];
    assign y0 = grid_coordinates[grid_counter][1];
    assign x1 = grid_coordinates[grid_counter][2];
    assign y1 = grid_coordinates[grid_counter][3];
    
    always_comb begin
        // Check each switch
        if (SW[0]) begin
            // Code to execute when the i-th switch is on
            x0 = line_coordinates[0][0];
            y0 = line_coordinates[0][1];
            x1 = line_coordinates[0][2];
            y1 = line_coordinates[0][3];
        end
    end

    // State machine logic
    always_ff @(posedge clk) begin
        if (reset) begin
            ps <= idle;
            grid_counter <= 2'b00;
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
                grid_start = ~KEY[3];
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
