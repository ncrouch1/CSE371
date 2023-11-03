// Module to read ROM data and output it based on current data and
// input statuses
module Task2 (input logic [23:0] readdata_left, readdata_right,
            output logic [23:0] outdata_left, outdata_right,
            input logic SW9, clock, reset);
    logic [15:0] counter;
	logic [23:0] ram_data;

	always @(posedge clock) begin
		if (reset | ~SW9)
		    counter <= 0;
		else begin
		    counter <= counter + 1;
		    if (counter >= 48000)
		        counter <= 0;
		end
	end

	rom1port rom (.address(counter), .clock(clock), .q(ram_data));

    assign outdata_left = SW9 ? ram_data : readdata_left;
    assign outdata_right = SW9 ? ram_data : readdata_right;
endmodule

`timescale 1 ps / 1 ps
// a module to test Task2
module Tast2_tb();
	logic [23:0] readdata_left, readdata_right, outdata_left, outdata_right;
	logic clock, reset, SW9;

	Task2 dut (.*);

	parameter T = 20;
	initial begin
		clock <= 0;
		forever #(T/2) clock <= ~clock;
	end

	initial begin
		reset <= 1; SW9 <= 1; 																 @(posedge clock);
		reset <= 0; readdata_left = 24'hFFFFFF; readdata_right <= 24'hFFFFFF; @(posedge clock);
		repeat(10)																				 @(posedge clock);
		SW9 <= 0;																				 @(posedge clock);
		repeat(10)																				 @(posedge clock);
		$stop;
	end
endmodule
