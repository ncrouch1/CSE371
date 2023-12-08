module address_decoder (
    input logic [9:0] metaSW,
    input logic enable, clock, reset,
    output logic [3:0] address
);
    logic [3:0] address_next;
    always_comb begin
		if (reset) begin
			address_next <= 4'b0000;
		end else begin
        case({enable, metaSW})
            11'b10000000001: address_next = 4'b0000;
            11'b10000000010: address_next = 4'b0001;
            11'b10000000100: address_next = 4'b0010;
            11'b10000001000: address_next = 4'b0011;
            11'b10000010000: address_next = 4'b0100;
            11'b10000100000: address_next = 4'b0101;
            11'b10001000000: address_next = 4'b0110;
            11'b10010000000: address_next = 4'b0111;
            11'b10100000000: address_next = 4'b1000;
            default: address_next = address;
        endcase        
		 end
    end

    always_ff @(posedge clock) begin
        if (reset) begin
            address <= 4'b0000;
        end
        address <= address_next;
    end
endmodule

