module player_handler(HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, player);
	output logic player;
	
	assign HEX1 = ~segments[0] & segments[1] & segments[2] & ~segments[3] & ~segments[4] & ~segments[5] & ~segments[6];
	
	if(player) begin
		assign HEX0 = 2'b01;
	end else begin
		assign HEX0 = 2'b10;
	end

endmodule
