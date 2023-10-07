// This module handles the signals for the hex displays based on the current counterstate
// reset and clock signals
module enter_exit_handler(clk, reset, counterstate, HEX0, HEX1);
	input logic clk, reset;
	input logic [4:0] counterstate;
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

	// 7-segment display variables defined
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

	parameter HEXDC = 7'b1000110;
	parameter HEXDL = 7'b1000111;
	parameter HEXDE = 7'b0000110;
	parameter HEXDA = 7'b0001000;
	parameter HEXDR = 7'b0101111;
	parameter HEXDU = 7'b1000001;
	parameter HEXDF = 7'b0001110;

	// FF to change HEXs on clock posedge depending on counterstate value
	// zero counterstate displays CLEAr0, 16 counterstate displays FULL, all middle states display just car count 		
	always_ff @(posedge clk) begin
		if (reset | counterstate == 0) begin 	// HEX[5:1] = "CLEAR0"
			HEX0 <= HEXD0;
			HEX1 <= HEXDR;
			HEX2 <= HEXDA;
			HEX3 <= HEXDE;
			HEX4 <= HEXDL;
			HEX5 <= HEXDC;
		end
		
		else if (counterstate == 16) begin // HEX[5:2] = "FULL"
			HEX0 <= '1;
			HEX1 <= '1;
			HEX2 <= HEXDL;
			HEX3 <= HEXDL;
			HEX4 <= HEXDU;
			HEX5 <= HEXDF;
		end
		else if (counterstate == 1) begin
			HEX5 <= '1;
			HEX4 <= '1;
			HEX3 <= '1;
			HEX2 <= '1;
			HEX1 <= HEXD0;
			HEX0 <= HEXD1;
		end
		else if (counterstate == 2) begin
			HEX5 <= '1;
			HEX4 <= '1;
			HEX3 <= '1;
			HEX2 <= '1;
			HEX1 <= HEXD0;
			HEX0 <= HEXD2;
		end
		else if (counterstate == 3) begin
			HEX5 <= '1;
			HEX4 <= '1;
			HEX3 <= '1;
			HEX2 <= '1;
			HEX1 <= HEXD0;
			HEX0 <= HEXD3;
		end
		else if (counterstate == 4) begin
			HEX5 <= '1;
			HEX4 <= '1;
			HEX3 <= '1;
			HEX2 <= '1;
			HEX1 <= HEXD0;
			HEX0 <= HEXD4;
		end
		else if (counterstate == 5) begin
			HEX1 <= HEXD0;
			HEX0 <= HEXD5;
		end
		else if (counterstate == 6) begin
			HEX5 <= '1;
			HEX4 <= '1;
			HEX3 <= '1;
			HEX2 <= '1;
			HEX1 <= HEXD0;
			HEX0 <= HEXD6;
		end
		else if (counterstate == 7) begin
			HEX5 <= '1;
			HEX4 <= '1;
			HEX3 <= '1;
			HEX2 <= '1;
			HEX1 <= HEXD0;
			HEX0 <= HEXD7;
		end
		else if (counterstate == 8) begin
			HEX5 <= '1;
			HEX4 <= '1;
			HEX3 <= '1;
			HEX2 <= '1;
			HEX1 <= HEXD0;
			HEX0 <= HEXD8;
		end
		else if (counterstate == 9) begin
			HEX5 <= '1;
			HEX4 <= '1;
			HEX3 <= '1;
			HEX2 <= '1;
			HEX1 <= HEXD0;
			HEX0 <= HEXD9;
		end
		else if (counterstate == 10) begin
			HEX5 <= '1;
			HEX4 <= '1;
			HEX3 <= '1;
			HEX2 <= '1;
			HEX1 <= HEXD1;
			HEX0 <= HEXD0;
		end
		else if (counterstate == 11) begin
			HEX5 <= '1;
			HEX4 <= '1;
			HEX3 <= '1;
			HEX2 <= '1;
			HEX1 <= HEXD1;
			HEX0 <= HEXD1;
		end
		else if (counterstate == 12) begin
			HEX5 <= '1;
			HEX4 <= '1;
			HEX3 <= '1;
			HEX2 <= '1;
			HEX1 <= HEXD1;
			HEX0 <= HEXD2;
		end
		else if (counterstate == 13) begin
			HEX5 <= '1;
			HEX4 <= '1;
			HEX3 <= '1;
			HEX2 <= '1;
			HEX1 <= HEXD1;
			HEX0 <= HEXD3;
		end
		else if (counterstate == 14) begin
			HEX5 <= '1;
			HEX4 <= '1;
			HEX3 <= '1;
			HEX2 <= '1;
			HEX1 <= HEXD1;
			HEX0 <= HEXD4;
		end
		else if (counterstate == 15) begin
			HEX5 <= '1;
			HEX4 <= '1;
			HEX3 <= '1;
			HEX2 <= '1;
			HEX1 <= HEXD1;
			HEX0 <= HEXD5;
		end
	end // always_posedge
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
		for (int i = 0; i < 16; i++) begin
			counterstate++;				@(posedge clk);
		end
		$stop;
	end
	
endmodule  // enter_exit_handler_tb
