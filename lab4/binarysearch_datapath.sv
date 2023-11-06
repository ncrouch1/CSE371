/*
Henri Lower 2276644
Noah Crouch 2078812
*/

/*
	Inputs: A(Number), Clock(50Mhz Clock), signals (reset, load_regs, compute_next,
				Finished, Located)
	Outputs: addresses (left, right, Loc), signals (Done, Found), data as byte (middle_data)
*/

module binarysearch_datapath (A, Clock, Reset, load_regs, compute_next,
            Loc, left, right, Finished, Located, middle_data, Done, Found);
				
	 // instantiate logic
    input logic Clock, Reset, load_regs, compute_next, Finished, Located;
	 input logic [7:0] A;
    output logic [7:0] middle_data;
    output logic [4:0] left, right;
	 output logic [4:0] Loc;
    output logic Done, Found;
    logic [4:0] middle;
	 
	 // Synchronous always block triggered on the positive edge of Clock
    always_ff @(posedge Clock) begin
		  // load registers if either load_regs or Reset is true
        if (load_regs | Reset) begin
            left = 5'b00000;
            right = 5'b11111;
            middle = 5'b01111;
        end

        if (compute_next) begin
            // Compute the new middle value using binary search algorithm
            middle = left + ((right - left) >> 1);

            // Compare middle_data with A and update left and right accordingly
            if (middle_data < A)
                left = middle + 1;
            else
                right = middle - 1;

            // Recalculate middle
            middle = left + ((right - left) >> 1);
        end
    end
    
	 // Instantiate a RAM module with connections
    ram32x8 ram (.address(middle), .clock(Clock), .data(8'h00), .wren(1'b0), .q(middle_data));
	 
	 // propogate Done and Found signals from control module
    assign Done = Finished;
    assign Found = Located;
	 // Set location only if we have found the number
    assign Loc = Found ? middle : 5'b00000;
endmodule