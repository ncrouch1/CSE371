module player_handler (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, player, clk, valid);
	input logic clk; 
	output logic player, valid, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	
	assign HEX1 = 7'b1111111;
	
	always_ff @(posedge clk) begin
		if(player) begin
			HEX0 = 7'b1111111;
		end else begin
			HEX0 = 7'b1111111;
		end
	end

endmodule
