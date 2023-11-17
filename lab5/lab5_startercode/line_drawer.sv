/*
Lab 5
EE 371
Noah Crouch	2078812
Henri Lower 2276644

/* Given two points on the screen this module draws a line between
 * those two points by coloring necessary pixels
 *
 * Inputs:
 *   clk    - should be connected to a 50 MHz clock
 *   reset  - resets the module and starts over the drawing process
 *	 x0 	- x coordinate of the first end point
 *   y0 	- y coordinate of the first end point
 *   x1 	- x coordinate of the second end point
 *   y1 	- y coordinate of the second end point
 *
 * Outputs:
 *   x 		- x coordinate of the pixel to color
 *   y 		- y coordinate of the pixel to color
 *   done	- flag that line has finished drawing
 *
 */
module line_drawer(clk, reset, x0, y0, x1, y1, x, y, done);
	input logic clk, reset;
	input logic [10:0]	x0, y0, x1, y1;
	output logic done;
	output logic [10:0]	x, y;
	
	/* You'll need to create some registers to keep track of things
	 * such as error and direction.
	 */
	 
	// Port declarations
	logic signed [11:0] error, abs_x, abs_y, delta_x, delta_y;  
	logic [10:0] temp_1, temp_2, x_start, x_end, y_start, y_end;
	logic is_steep, step;
	
	// is_steep logic
	assign abs_x = x1 > x0 ? x1 - x0 : x0 - x1;
	assign abs_y = y1 > y0 ? y1 - y0 : y0 - y1;
	assign is_steep = abs_x > abs_y ? 1'b0 : 1'b1;
	
	// If line is steep, then switch x and y coordinates
	assign temp_1 = is_steep ? y0 : x0;
	assign temp_2 = is_steep ? y1 : x1;
	
	// Set start and end for x and y. 
	// If x0 > x1 then swap x1 with x0 and y1 with y0
	assign x_start = temp_1 > temp_2 ? x1 : x0;
	assign y_start = temp_1 > temp_2 ? y1 : y0;
	assign x_end   = temp_1 > temp_2 ? x0 : x1;
	assign y_end   = temp_1 > temp_2 ? y0 : y1;
	
	// Setting delta x accordingly if the line is steep or not
	assign delta_x = is_steep ? y_end - y_start : x_end - x_start;
	
	// Using always_comb block to set delta y and step
	always_comb begin
		 if (is_steep) begin // if is_steep
			  delta_y = x_end > x_start ? x_end - x_start : x_start - x_end;
			  step = x_start < x_end ? 1'b1 : 1'b0;  // -1 if 0
		 end else begin // else
			  delta_y = y_end > y_start ? y_end - y_start : y_start - y_end;
			  step = y_start < y_end ? 1'b1 : 1'b0;  // -1 if 0
		 end // is_steep	 
	end  // delta_y and step assignment
	
	
	always_ff @(posedge clk) begin
		// YOUR CODE HERE
		done <= 1'b0;
		// reset logic
		if(reset) begin
			done <= 1'b0;
			x <= x_start;
			y <= y_start;
			error <= ~(delta_x / 2) + 1;
		end
		
		// Main
		if(~done) begin // if not done
		
			if(is_steep) begin // if is_steep
			
				if(y < y_end) begin // if y less than y_end
				
					y <= y + 1'd1; // y = y++
					
					// if error + delta y is greater than or equal to 0
					if(error + delta_y >= 0) begin 
						error <= error + delta_y - delta_x;
						// set x according to step
						x <= step ? x + 1'd1 : x - 1'd1;
					end // error + delta y is greater than or equal to 0
					
					else begin // error + delta y is less than 0
						error <= error + delta_y;
					end // else
					
				end // y less than y_end
				
				else done <= 1'b1;
			end // is_steep
			
			else begin // x equal or greater than x_end
				if(x < x_end) begin
					x <= x + 1'd1; // x = x++
					if( error + delta_y >= 0) begin
						error <= error + delta_y - delta_x;
						y <= step ? y + 1'd1 : y - 1'd1;
					end 
					
					else begin
						error <= error + delta_y;
					end
				end // x less than x_end
				
				else done <= 1'b1; // Done with line drawing
			end // if is_steep
		
		end // if not done
		
	end  // always_ff
	
endmodule  // line_drawer


// Testbench for line drawer
module line_drawer_tb ();

	// port declarations
	logic clk, reset;
	logic [10:0] x0, y0, x1, y1;
	logic done;
	logic [10:0] x, y;

	// simulated clock
	parameter T = 100;
	initial begin
		clk <= 0;
		forever #(T / 2) clk <= ~clk;  // Forever toggle the clock
	end  // Setting up a simulated clock

	// Create module instance
	line_drawer dut (.*);

	// Testbench
	initial begin
		// _________________________________________________________________
		// Draw line right and down - gradual 
		// Should go up 5 x for 1 y
		x0 <= 0 ; y0 <= 0 ; x1 <= 10 ; y1 <= 2; reset <= 1; @(posedge clk);
		reset <= 0; @(posedge clk);
		
		while(~done) begin
			@(posedge clk);
		end

		// _________________________________________________________________
		// Draw line left and up - gradual
		// Should go up 5 y for 1 x
		x0 <= 10 ; y0 <= 2 ; x1 <= 0 ; y1 <= 0; reset <= 1; @(posedge clk);
		reset <= 0; @(posedge clk);
		
		while(~done) begin
			@(posedge clk);
		end
			
		// _________________________________________________________________
		// Draw line right and down - steep
		x0 <= 0 ; y0 <= 0 ; x1 <= 2 ; y1 <= 10; reset <= 1; @(posedge clk);
		reset <= 0; @(posedge clk);
		
		while(~done) begin
			@(posedge clk);
		end
	
		// _________________________________________________________________
		// Draw line left and up - steep
		x0 <= 2 ; y0 <= 10 ; x1 <= 0 ; y1 <= 0; reset <= 1; @(posedge clk);
		reset <= 0; @(posedge clk);
		
		while(~done) begin
			@(posedge clk);
		end
		
		// _________________________________________________________________
		// Draw line right and up - gradual
		x0 <= 0 ; y0 <= 2 ; x1 <= 10 ; y1 <= 0; reset <= 1; @(posedge clk);
		reset <= 0; @(posedge clk);
		
		while(~done) begin
			@(posedge clk);
		end
		
		// _________________________________________________________________
		// Draw line left and down - gradual
		x0 <= 10 ; y0 <= 0 ; x1 <= 0 ; y1 <= 2; reset <= 1; @(posedge clk);
		reset <= 0; @(posedge clk);
		
		while(~done) begin
			@(posedge clk);
		end
		
		// _________________________________________________________________
		// Draw line right and up - steep
		x0 <= 0 ; y0 <= 10 ; x1 <= 2 ; y1 <= 0; reset <= 1; @(posedge clk);
		reset <= 0; @(posedge clk);
		
		while(~done) begin
			@(posedge clk);
		end
	
		// _________________________________________________________________
		// Draw line left and down - steep
		x0 <= 2 ; y0 <= 0 ; x1 <= 0 ; y1 <= 10; reset <= 1; @(posedge clk);
		reset <= 0; @(posedge clk);
		
		while(~done) begin
			@(posedge clk);
		end
		$stop;
	end
endmodule 