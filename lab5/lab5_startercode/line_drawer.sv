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
	logic signed [11:0] error;  // example - feel free to change/delete
	logic handleError, takestep, leftright, updown;
	assign handleError = updown ? (error < -0.5) : (error > 0.5);
	assign x_step = leftright ? (x > x1_post) : (x < x1_post);
	float m = ((y1 - y0) / x1 - x0);

	always_ff @(posedge clk) begin
		// YOUR CODE HERE
		if (reset) begin
			done <= 0;
			if (x1 < x0)
				leftright = 0;
			else if (x1 > x0)
				leftright = 1;
			if (y1 > y0) 
				updown = 0;
			else if (y1 < y0)
				updown = 1;
			error <= updown ? (y0 + 0.5) : (y0 - 0.5); 
		end

	end  // always_ff
	
endmodule  // line_drawer