module enter_exit_handler(clk, reset, enter, exit, counterstate, HEX);
	input logic clk, reset, enter, exit;
	input logic [4:0] counterstate;
	output logic [6:0] HEX [1:0];
	
	parameter HEXD0 = 7'b0000001;
	parameter HEXD1 = 7'b1001111;
	parameter HEXD2 = 7'b0010010;
	parameter HEXD3 = 7'b0000110;
	parameter HEXD4 = 7'b1001100;
	parameter HEXD5 = 7'b0100100;
	parameter HEXD6 = 7'b0100000;
	parameter HEXD7 = 7'b0001111;
	parameter HEXD8 = 7'b0000000;
	parameter HEXD9 = 7'b0000100;
	
	always_ff @(posedge clk) begin
		if (counterstate == 0) begin
			HEX[1] <= HEXD0;
			HEX[0] <= HEXD0;
		end
		else if (counterstate == 1) begin
			HEX[1] <= HEXD0;
			HEX[0] <= HEXD1;
		end
		else if (counterstate == 2) begin
			HEX[1] <= HEXD0;
			HEX[0] <= HEXD2;
		end
		else if (counterstate == 3) begin
			HEX[1] <= HEXD0;
			HEX[0] <= HEXD3;
		end
		else if (counterstate == 4) begin
			HEX[1] <= HEXD0;
			HEX[0] <= HEXD4;
		end
		else if (counterstate == 5) begin
			HEX[1] <= HEXD0;
			HEX[0] <= HEXD5;
		end
		else if (counterstate == 6) begin
			HEX[1] <= HEXD0;
			HEX[0] <= HEXD6;
		end
		else if (counterstate == 7) begin
			HEX[1] <= HEXD0;
			HEX[0] <= HEXD7;
		end
		else if (counterstate == 8) begin
			HEX[1] <= HEXD0;
			HEX[0] <= HEXD8;
		end
		else if (counterstate == 9) begin
			HEX[1] <= HEXD0;
			HEX[0] <= HEXD9;
		end
		else if (counterstate == 10) begin
			HEX[1] <= HEXD1;
			HEX[0] <= HEXD0;
		end
		else if (counterstate == 11) begin
			HEX[1] <= HEXD1;
			HEX[0] <= HEXD1;
		end
		else if (counterstate == 12) begin
			HEX[1] <= HEXD1;
			HEX[0] <= HEXD2;
		end
		else if (counterstate == 13) begin
			HEX[1] <= HEXD1;
			HEX[0] <= HEXD3;
		end
		else if (counterstate == 14) begin
			HEX[1] <= HEXD1;
			HEX[0] <= HEXD4;
		end
		else if (counterstate == 15) begin
			HEX[1] <= HEXD1;
			HEX[0] <= HEXD5;
		end
		else if (counterstate == 16) begin
			HEX[1] <= HEXD1;
			HEX[0] <= HEXD6;
		end
	end
endmodule
	