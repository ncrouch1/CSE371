
module screen_handler (
    input logic clk, reset, player, done, start,
    input logic [1:0] gamestate_next [9:0],
    output logic [10:0] x, y,
    output logic drawing_done
    );
	
	logic grid_done, grid_start, line_reset, line_start;

	logic [10:0] x10, y10, x11, y11, x20, y20, x21, y21;
    logic [3:0] rom_address; 
	 logic [87:0] data;

	 logic [10:0] x10_transfer, y10_transfer, x11_transfer, y11_transfer, x20_transfer, y20_transfer, x21_transfer, y21_transfer;
	logic [10:0] x_transfer, y_transfer;
	
	 assign x10 = x10_transfer;
    assign y10 = y10_transfer;
    assign x11 = x11_transfer;
    assign y11 = y11_transfer;
    assign x20 = x20_transfer;
    assign y20 = y20_transfer;
    assign x21 = x21_transfer;
    assign y21 = y21_transfer;
				
	line_drawer lines  (
			.clk(clk), 
			.reset(line_reset), 
			.x0((ps == draw_line2) ? x10 : x20), 
			.y0((ps == draw_line2) ? y10 : y20), 
			.x1((ps == draw_line2) ? x11 : x21), 
			.y1((ps == draw_line2) ? y11 : y21), 
			.x(fx1), 
			.y(fy1), 
			.done(drawing_done));
			
   //line_drawer lines2 (.clk(clk), .reset(line_reset), .x0(x20), .y0(y20), .x1(x21), .y1(y21), .x(fx2), .y(fy2), .done(drawing_done));
   //line_drawer grid (.clk(clk), .reset(line_reset), .x0(gx0), .y0(gy0), .x1(gx1), .y1(gy1), .x(x), .y(y), .done(drawing_done));
	rom line_data(.address(rom_address), .clock(clk), .q(data));
	
	// enums states and state containers
    enum {idle, grid_line1, grid_line2, grid_line3, grid_line4, state_grid_done} ps, ns;
    enum {idle2, draw_line1, draw_line2, line_done} ps2, ns2;

 	// counter to keep track of the current line
    logic [1:0] grid_counter;   

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
        case (player) 
            1'b0 : begin
                x10_transfer = data[10:0];
                y10_transfer = data[21:11];
                x11_transfer = data[32:22];
                y11_transfer = data[43:33];
                x20_transfer = 11'b0;
                y20_transfer = 11'b0;
                x21_transfer = 11'b0;
                y21_transfer = 11'b0;
            end

            1'b1 : begin
                x10_transfer = data[10:0];
                y10_transfer = data[21:11];
                x11_transfer = data[32:22];
                y11_transfer = data[43:33];
                x20_transfer = data[54:44];
                y20_transfer = data[65:55];
                x21_transfer = data[76:66];
                y21_transfer = data[87:77];
            end
            default: begin
                x10_transfer = grid_coordinates[grid_counter][0];
                y10_transfer = grid_coordinates[grid_counter][1];
                x11_transfer = grid_coordinates[grid_counter][2];
                y11_transfer = grid_coordinates[grid_counter][3];
					 x20_transfer = 11'b0;
                y20_transfer = 11'b0;
                x21_transfer = 11'b0;
                y21_transfer = 11'b0;
            end
        endcase
    end

	always_ff @(posedge clk or posedge reset) begin
		if (reset) begin
			ps <= idle;
			ps2 <= idle2;
			grid_counter <= 2'b00;
		end else begin
			ps <= ns;
			ps2 <= ns2;
			grid_counter <= (ns == idle) ? grid_counter + 1 : grid_counter;
	end

		case (ps2)
			idle2: begin
				ns2 = draw_line1;
			end

			draw_line1: begin
				ns2 = draw_line2;
			end

			draw_line2: begin
				ns2 = line_done;
			end

			line_done: begin
				//drawing_done <= 1'b1;
			end
		endcase

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

endmodule  // screen_handler

// Testbench for screen_handler module

module tb_screen_handler;
    // Inputs
    logic clk, reset, player, done, start;
    logic [1:0] gamestate_next [9:0];
    logic [87:0] data;
    
    // Outputs
    logic [10:0] x, y;
    logic drawing_done;

    // Instantiate screen_handler module
    screen_handler dut (
        .clk(clk),
        .reset(reset),
        .player(player),
        .done(done),
        .start(start),
        .gamestate_next(gamestate_next),
        .x(x),
        .y(y),
        .data(data),
        .drawing_done(drawing_done)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test scenario
    initial begin
        // Initialize inputs
        reset = 1;
        player = 0;
        done = 0;
        start = 0;
        data = 0;
        #10 reset = 0;

        // Test case 1
        // Set player to 0
        player = 0;
        #10 data = 32'h123456789;
        #10 done = 1;

        // Test case 2
        // Set player to 1
        player = 1;
        #10 data = 32'h9876543210123456789;
        #10 done = 1;

        // Add more test cases as needed

        #100 $stop;
    end

endmodule  // tb_screen_handler
