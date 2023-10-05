module photoSensor (Clk, Rst, Sensor, Enter, Exit);
	input logic  Clk, Rst;
	input logic  [1:0] Sensor;
	output logic Enter, Exit;
	
	enum { empty, oBlocked, iBlocked, both} ps, ns;
	
	always_comb begin
		case(ps)
			empty: begin
				if (Sensor == 2'b11)			ns = both;
				else if (Sensor == 2'b01)	ns = iBlocked;
				else if (Sensor == 2'b10)	ns = oBlocked;
				else								ns = empty;
			end
			
			oBlocked: begin
				if (Sensor == 2'b11)			ns = both;
				else if (Sensor == 2'b01)	ns = iBlocked;
				else if (Sensor == 2'b10)	ns = oBlocked;
				else								ns = empty;
			end
			
			iBlocked: begin
				if (Sensor == 2'b11)			ns = both;
				else if (Sensor == 2'b01)	ns = iBlocked;
				else if (Sensor == 2'b10)	ns = oBlocked;
				else								ns = empty;
			end
			
			both: begin
				if (Sensor == 2'b11)			ns = both;
				else if (Sensor == 2'b01)	ns = iBlocked;
				else if (Sensor == 2'b10)	ns = oBlocked;
				else								ns = empty;
			end
			
			default: ns = empty;
		endcase
	end
	
	always_ff @(posedge Clk) begin
		if (Rst)
			ps = empty;
		else
			ps <= ns;
	end
		
	always_comb begin
		if ((ns == iBlocked) & (ps == both)) begin
			Exit = 0;
			Enter = 1;
		end
		
		else if ((ns == oBlocked) & (ps == both)) begin
			Exit = 1;
			Enter = 0;
		end
		
		else begin
			Enter = 0;
			Exit = 0;
		end
	end
endmodule
