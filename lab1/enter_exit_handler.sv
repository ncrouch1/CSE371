module enter_exit_handler(clk, reset, counterstate, HEX0, HEX1);
	input logic clk, reset;
	input logic [4:0] counterstate;
	output logic [6:0] HEX0, HEX1;
	
	parameter HEXD0 = 7'b1000000;
	parameter HEXD1 = 7'b1111001;
	parameter HEXD2 = 7'b0100100; 
	parameter HEXD3 = 7'b0110000; 
	parameter HEXD4 = 7'b0011001; 
	parameter HEXD5 = 7'b0010010; 
	parameter HEXD6 = 7'b0000010; 
	parameter HEXD7 = 7'b1111000; 
	parameter HEXD8 = 7'b0000000;
	parameter HEXD9 = 7'b0010000; 
	
	always_ff @(posedge clk) begin
		if (reset) begin
			HEX1 <= HEXD0;
			HEX0 <= HEXD0;
		end
		else if (counterstate == 0) begin
			HEX1 <= HEXD0;
			HEX0 <= HEXD0;
		end
		else if (counterstate == 1) begin
			HEX1 <= HEXD0;
			HEX0 <= HEXD1;
		end
		else if (counterstate == 2) begin
			HEX1 <= HEXD0;
			HEX0 <= HEXD2;
		end
		else if (counterstate == 3) begin
			HEX1 <= HEXD0;
			HEX0 <= HEXD3;
		end
		else if (counterstate == 4) begin
			HEX1 <= HEXD0;
			HEX0 <= HEXD4;
		end
		else if (counterstate == 5) begin
			HEX1 <= HEXD0;
			HEX0 <= HEXD5;
		end
		else if (counterstate == 6) begin
			HEX1 <= HEXD0;
			HEX0 <= HEXD6;
		end
		else if (counterstate == 7) begin
			HEX1 <= HEXD0;
			HEX0 <= HEXD7;
		end
		else if (counterstate == 8) begin
			HEX1 <= HEXD0;
			HEX0 <= HEXD8;
		end
		else if (counterstate == 9) begin
			HEX1 <= HEXD0;
			HEX0 <= HEXD9;
		end
		else if (counterstate == 10) begin
			HEX1 <= HEXD1;
			HEX0 <= HEXD0;
		end
		else if (counterstate == 11) begin
			HEX1 <= HEXD1;
			HEX0 <= HEXD1;
		end
		else if (counterstate == 12) begin
			HEX1 <= HEXD1;
			HEX0 <= HEXD2;
		end
		else if (counterstate == 13) begin
			HEX1 <= HEXD1;
			HEX0 <= HEXD3;
		end
		else if (counterstate == 14) begin
			HEX1 <= HEXD1;
			HEX0 <= HEXD4;
		end
		else if (counterstate == 15) begin
			HEX1 <= HEXD1;
			HEX0 <= HEXD5;
		end
		else if (counterstate == 16) begin
			HEX1 <= HEXD1;
			HEX0 <= HEXD6;
		end
	end
endmodule

module enter_exit_handler_tb();

	// define signals
	logic clk, reset;
	logic [4:0] counterstate;
	logic [6:0] HEX0, HEX1;
	
	// define parameters
	parameter T = 20;
	
	// instantiate module
	enter_exit_handler dut (.clk(clk), .reset(reset), .counterstate(counterstate), .HEX0(HEX0), .HEX1(HEX1));
	
	// define simulated clock
	initial begin
		clk <= 0;
		forever	#(T/2)	clk <= ~clk;
	end  // initial clock
	
	initial begin
		reset <= 1;  						@(posedge clk);
		counterstate <= 0; 	
		reset <= 0;  						@(posedge clk);
		for (int i = 0; i < 15; i++) begin
			counterstate++;				@(posedge clk);
		end
		$stop;
	end
	
endmodule  // enter_exit_handler_tb
