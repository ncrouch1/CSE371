module enter_exit_handler(clk, reset, counterstate, HEX0, HEX1);
	input logic clk, reset;
	input logic [4:0] counterstate;
	output logic [6:0] HEX0, HEX1;
	
<<<<<<< HEAD
	parameter HEXD0 = 7'b1000000;
	parameter HEXD1 = 7'b1111001;
	parameter HEXD2 = 7'b0100100; 
	parameter HEXD3 = 7'b0110000; 
	parameter HEXD4 = 7'b0011001; 
	parameter HEXD5 = 7'b0010010; 
	parameter HEXD6 = 7'b0000010; 
	parameter HEXD7 = 7'b1111000; 
=======
	enum { s0, s1, s2, s3, s4, s5, s6 ,s7 ,s8, s9, error } ps, ns;
	
	parameter HEXD0 = 7'b0000001;
	parameter HEXD1 = 7'b1001111;
	parameter HEXD2 = 7'b0010010;
	parameter HEXD3 = 7'b0000110;
	parameter HEXD4 = 7'b1001100;
	parameter HEXD5 = 7'b0100100;
	parameter HEXD6 = 7'b0100000;
	parameter HEXD7 = 7'b0001111;
>>>>>>> af10525df4666732e1a9f035e57ffbcdb4fa08dc
	parameter HEXD8 = 7'b0000000;
	parameter HEXD9 = 7'b0010000; 
	
	always_comb begin
		case (ps)
			s0: begin
				if 		(enter)		ns = s1;
				else if 	(exit)		ns = error;
				else						ns = s0;
			end
			
			s1: begin
				if 		(enter)		ns = s2;
				else if 	(exit)		ns = s0;
				else						ns = s1;
			end
			
			s2: begin
				if 		(enter)		ns = s3;
				else if 	(exit)		ns = s1;
				else						ns = s2;
			end
			
			s3: begin
				if 		(enter)		ns = s4;
				else if 	(exit)		ns = s2;
				else						ns = s3;
			end
			
			s4: begin
				if 		(enter)		ns = s5;
				else if 	(exit)		ns = s3;
				else						ns = s4;
			end
			
			s5: begin
				if 		(enter)		ns = s6;
				else if 	(exit)		ns = s4;
				else						ns = s5;
			end
			
			s6: begin
				if 		(enter)		ns = s7;
				else if 	(exit)		ns = s5;
				else						ns = s6;
			end
			
			s7: begin
				if 		(enter)		ns = s8;
				else if 	(exit)		ns = s6;
				else						ns = s7;
			end
			
			s8: begin
				if 		(enter)		ns = s9;
				else if 	(exit)		ns = s7;
				else						ns = s8;
			end
			
			s9: begin
				if 		(enter)		ns = error;
				else if 	(exit)		ns = s8;
				else						ns = s9;
			end
			
			error: begin
				if 		(reset)		ns = s0;
				else						ns = error;
			end
			
			default:						ns = s0;
		endcase
	end
			
	always_ff @(posedge clk) begin
<<<<<<< HEAD
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
=======
		if (reset)
			ps <= s0;
		else
			ps <= ns;
	end
	
	always_comb begin
		if (ps == s0) begin
			HEX[1] <= HEXD0;
			HEX[0] <= HEXD0;
		end
		else if (ps == s1) begin
			HEX[1] <= HEXD0;
			HEX[0] <= HEXD1;
		end
		else if (ps == s2) begin
			HEX[1] <= HEXD0;
			HEX[0] <= HEXD2;
		end
		else if (ps == s3) begin
			HEX[1] <= HEXD0;
			HEX[0] <= HEXD3;
		end
		else if (ps == s4) begin
			HEX[1] <= HEXD0;
			HEX[0] <= HEXD4;
		end
		else if (ps == s5) begin
			HEX[1] <= HEXD0;
			HEX[0] <= HEXD5;
		end
		else if (ps == s6) begin
			HEX[1] <= HEXD0;
			HEX[0] <= HEXD6;
		end
		else if (ps == s7) begin
			HEX[1] <= HEXD0;
			HEX[0] <= HEXD7;
		end
		else if (ps == s8) begin
			HEX[1] <= HEXD0;
			HEX[0] <= HEXD8;
		end
		else if (ps == s9) begin
			HEX[1] <= HEXD0;
			HEX[0] <= HEXD9;
		end
		else if (ps == s10) begin
			HEX[1] <= HEXD1;
			HEX[0] <= HEXD0;
		end
		else if (ps == s11) begin
			HEX[1] <= HEXD1;
			HEX[0] <= HEXD1;
		end
		else if (ps == s12) begin
			HEX[1] <= HEXD1;
			HEX[0] <= HEXD2;
		end
		else if (ps == s13) begin
			HEX[1] <= HEXD1;
			HEX[0] <= HEXD3;
		end
		else if (ps == s14) begin
			HEX[1] <= HEXD1;
			HEX[0] <= HEXD4;
		end
		else if (ps == s15) begin
			HEX[1] <= HEXD1;
			HEX[0] <= HEXD5;
		end
		else if (ps == s16) begin
			HEX[1] <= HEXD1;
			HEX[0] <= HEXD6;
>>>>>>> af10525df4666732e1a9f035e57ffbcdb4fa08dc
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
