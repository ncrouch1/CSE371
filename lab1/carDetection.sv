// FSM to detect cars entering or exiting lot with pedestrian filter
// inputs:  2-bit signal for outer and inner photo sensors
// outputs: enter, exit are 1-bit signals that activate for one clock cycle 
module carDetection (clk, reset, sensors, enter, exit);
	input logic  		 clk, reset;
	input logic  [1:0] sensors; // [outer, inner]
	output logic 		 enter, exit;
	
	// State variables
	enum { empty, oBlocked, iBlocked, both} ps, ns;
	
	// Next State Logic
	always_comb begin
		case(ps)
			empty: begin
				if (sensors == 2'b11)			ns = both;
				else if (sensors == 2'b01)		ns = iBlocked;
				else if (sensors == 2'b10)		ns = oBlocked;
				else									ns = empty;
			end
			
			oBlocked: begin
				if (sensors == 2'b11)			ns = both;
				else if (sensors == 2'b01)		ns = iBlocked;
				else if (sensors == 2'b10)		ns = oBlocked;
				else									ns = empty;
			end
			
			iBlocked: begin
				if (sensors == 2'b11)			ns = both;
				else if (sensors == 2'b01)		ns = iBlocked;
				else if (sensors == 2'b10)		ns = oBlocked;
				else									ns = empty;
			end
			
			both: begin
				if (sensors == 2'b11)			ns = both;
				else if (sensors == 2'b01)		ns = iBlocked;
				else if (sensors == 2'b10)		ns = oBlocked;
				else									ns = empty;
			end
			
			default: ns = empty;
		endcase
	end // always_comb
	
	// Sequential Logic
	always_ff @(posedge clk) begin
		if (reset)
			ps <= empty;
		else
			ps <= ns;
	end // always_ff
	
	// Output Logic
	// Pedestrians are filtered by strating output conditions with both sensors triggered state,
	// assuming only cars can tirgger both at the same time
	always_comb begin
		// Entering Condtion
		if 	  ((ns == iBlocked) & (ps == both)) begin
			enter = 1;
			exit = 0;
		end
		
		// Exiting condition
		else if ((ns == oBlocked) & (ps == both)) begin
			enter = 0;
			exit = 1;
		end
		
		else begin
			enter = 0;
			exit = 0;
		end
	end // always_comb
endmodule // carDetection


module carDetection_tb();

	// define signals
	logic			clk, reset;
	logic [1:0] sensors;
	logic 		enter, exit;

	
	// define parameters
	parameter T = 20;
	
	// instantiate module
	carDetection dut (.clk(clk), .reset(reset), .sensors(sensors), .enter(enter), .exit(exit));
	
	// define simulated clock
	initial begin
		clk <= 0;
		forever	#(T/2)	clk <= ~clk;
	end  // initial clock
	
	initial begin
		reset <= 1; 						@(posedge clk);
		reset <= 0;							@(posedge clk);
		
		for (int i = 0; i < 10; i++) begin
		
			// Exiting Test
			sensors[1:0] 	<=  2'b01; @(posedge clk);
			sensors[1:0] 	<=  2'b11; @(posedge clk);
			sensors[1:0] 	<=  2'b10; @(posedge clk);
			sensors[1:0] 	<=  2'b00; @(posedge clk);
			
			// Entering Test
			sensors[1:0] 	<=  2'b10; @(posedge clk);
			sensors[1:0] 	<=  2'b11; @(posedge clk);
			sensors[1:0] 	<=  2'b01; @(posedge clk);
			sensors[1:0]  	<=  2'b00; @(posedge clk);
		end // for loop - Enter/Exit Tests run 10 times
		$stop;
	end
	
endmodule  // DE1_SoC_tb