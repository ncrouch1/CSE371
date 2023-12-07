
module screen_handler (
    input logic clk, reset, player, done, start,
    input logic [1:0] gamestate_next [9:0],
    output logic [10:0] x, y,
    input logic [87:0] data,
    output logic drawing_done
    );
	
	logic grid_done, grid_start, line_reset, line_start;

	logic [10:0] x10, y10, x11, y11, x20, y20, x21, y21;
    logic [3:0] rom_address; 
				
	line_drawer lines  (.clk(clk), .reset(line_reset), .x0(x10), .y0(y10), .x1(x11), .y1(y11), .x(x), .y(y), .done(line_draw_done));
    line_drawer lines2 (.clk(clk), .reset(line_reset), .x0(x20), .y0(y20), .x1(x21), .y1(y21), .x(x), .y(y), .done(line_draw_done));
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
            default: begin
                x10 = grid_coordinates[grid_counter][0];
                y10 = grid_coordinates[grid_counter][1];
                x11 = grid_coordinates[grid_counter][2];
                y11 = grid_coordinates[grid_counter][3];
            end
        endcase
    end

    // State machine logic
    always_ff @(posedge clk) begin
        if (reset) begin
            ps <= idle;
            ps2 <= idle2;
            grid_counter <= 2'b00;
        end else begin
            ps <= ns;
            ps2 <= ns2;
            grid_counter <= (ns == idle) ? grid_counter + 1 : grid_counter;
        end
    end

    // State logic for lines
    always_ff @(posedge clk) begin
        case(ps2)
            idle2: begin
                ns = draw_line1;
            end

            draw_line1: begin
                ns = draw_line2;
            end

            draw_line2: begin
                ns = line_done;
            end

            line_done: begin
                drawing_done <= 1'b1;
            end
        endcase
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
