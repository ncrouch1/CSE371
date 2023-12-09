/* 
Noah Crouch 2078812
Henri Lower   2276644
EE/CSE 371
Lab 6 Report
12/08/2023

Screen handler module that initializes the line_drawer 
module and feeds it the coordinatesto receive x and y 
outputs that it relays to the top level module. Draws 
one slash for player one and two slashes (or and x) 
for player 2

Inputs:
    clk             - clock to synchronize module
    reset           - reset signal 
    player          - player signal, LOW is player 1, HIGH is player 2
    start           - start signal triggered by button on DE1-SoC
    data            - data from rom that contains coordinate values for slashes and x's

Outputs:
    x               - x value from line_drawer
    y               - y value from line_drawer
    drawing_done    - asserted at end of FSM to signal that drawing is done
    done            - done signal used for line_drawer
*/

module screen_handler (
    input logic clk, reset, player, start,
    output logic [10:0] x, y,
    output logic drawing_done, done,
    input logic [87:0] data
    );
	
    // Port Declarations
	logic grid_done, grid_start, line_reset, line_start;
	logic [10:0] x10, y10, x11, y11, x20, y20, x21, y21;
    
    // Assignments
	assign drawing_done = (ps == line_done);
			
    // line_drawer initialization 
	line_drawer lines  (
			.clk(clk), 
			.reset(line_reset), 
			.x0((ps == ~draw_line2) ? x10 : x20), 
			.y0((ps == ~draw_line2) ? y10 : y20), 
			.x1((ps == ~draw_line2) ? x11 : x21), 
			.y1((ps == ~draw_line2) ? y11 : y21), 
			.x(x), 
			.y(y), 
			.done(done));
			
	// enums states and state containers
    enum {idle, grid_line1, grid_line2, grid_line3, grid_line4, state_grid_done} ps, ns;
    enum {idle2, draw_line1, draw_line2, line_done} ps2, ns2;

 	// counter to keep track of the current line
    logic [1:0] grid_counter;   

    // coordinate values for the four lines
    logic [10:0] grid_coordinates[3:0][3:0];
    
    // Setting of grid coordinates
    initial begin
        grid_coordinates[0] = '{11'd80, 11'd248, 11'd400, 11'd248};   // Grid 1
        grid_coordinates[1] = '{11'd80, 11'd390, 11'd400, 11'd390};   // Grid 2
        grid_coordinates[2] = '{11'd186, 11'd106, 11'd186, 11'd532};  // Grid 3
        grid_coordinates[3] = '{11'd292, 11'd106, 11'd292, 11'd532};  // Grid 4
    end
    
    // Slash and X logic that accounts for the player. 
    always_comb begin 
        // if grid is not drawn then do that first
        if(~grid_done) begin
            x10 = grid_coordinates[grid_counter][0];
            y10 = grid_coordinates[grid_counter][1];
            x11 = grid_coordinates[grid_counter][2];
            y11 = grid_coordinates[grid_counter][3];
		    x20 = 11'b0;
            y20 = 11'b0;
            x21 = 11'b0;
            y21 = 11'b0;
        end else 
        
        case (player) 
            1'b0 : begin
                x10 = data[10:0];
                y10 = data[21:11];
                x11 = data[32:22];
                y11 = data[43:33];
                x20 = 11'b0;
                y20 = 11'b0;
                x21 = 11'b0;
                y21 = 11'b0;
            end

            1'b1 : begin
                x10 = data[10:0];
                y10 = data[21:11];
                x11 = data[32:22];
                y11 = data[43:33];
                x20 = data[54:44];
                y20 = data[65:55];
                x21 = data[76:66];
                y21 = data[87:77];
            end
            // Default condition
            default: begin
                x10 = grid_coordinates[grid_counter][0];
                y10 = grid_coordinates[grid_counter][1];
                x11 = grid_coordinates[grid_counter][2];
                y11 = grid_coordinates[grid_counter][3];
			    x20 = 11'b0;
                y20 = 11'b0;
                x21 = 11'b0;
                y21 = 11'b0;
            end
        endcase
    end

    // reset flipflop that increments grid counter
	always_ff @(posedge clk or posedge reset) begin
		if (reset) begin
			ps <= idle;
			ps2 <= idle2;
			grid_counter <= 2'b00;
		end else begin
			ps <= ns;
			ps2 <= ns2;
			line_start <= start;
			grid_counter <= (ns == idle) ? grid_counter + 1 : grid_counter;
	end

        // FSM for slash and x logic
		case (ps2)
			idle2: begin
				ns2 = draw_line1;
			end

			draw_line1: begin
			    
				ns2 = done ? draw_line2 : draw_line1;
			end

			draw_line2: begin
				ns2 = done ? line_done : draw_line2;
			end

			line_done: begin
			    
				ns2 = idle2;
			end
		endcase

        // FSM for grid lines
		case (ps)
			idle: begin
					
				// Need clear screen logic here
				ns = ~line_start ? ps : grid_line1;
			end
			grid_line1: begin
				line_reset <= 1'b1;
				ns = drawing_done ? grid_line2 : grid_line1;
			end
			grid_line2: begin
				line_reset <= 1'b1;
				ns = drawing_done ? grid_line3 : grid_line2;
			end
			grid_line3: begin
				line_reset <= 1'b1;
				ns = drawing_done ? grid_line4 : grid_line3;
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

module screen_handler_tb;

    // Inputs
    reg clk, reset, player, start;
    reg [87:0] data;

    // Outputs
    reg [10:0] x, y;
    reg drawing_done, done;

    // Instantiate the module under test
    screen_handler sh_tb (
        .clk(clk),
        .reset(reset),
        .player(player),
        .start(start),
        .data(data),
        .x(x),
        .y(y),
        .drawing_done(drawing_done),
        .done(done)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Initial stimulus
    initial begin
        // Initialize inputs
        clk = 0;
        reset = 1;
        player = 0;
        start = 0;
        data = 88'b0;

        // Apply reset
        #10 reset = 0;

        // Start the simulation
        #10 start = 1;

        // Simulate for 100 clock cycles
        repeat (100) #10 clk = ~clk;

        // Stop the simulation
        #10 $finish;
    end

    // Monitor outputs
    always @(posedge clk) begin
        $display("x = %h, y = %h, drawing_done = %b, done = %b", x, y, drawing_done, done);
        // Add other signals as needed
    end

endmodule

