module binarysearch_datapath (A, Clock, Reset, load_regs, compute_next,
            Loc, left, right, Finished, Located, middle_data, Done, Found);
    input logic Clock, Reset, load_regs, compute_next, Finished, Located;
	 input logic [7:0] A;
    output logic [7:0] middle_data;
    output logic [4:0] left, right;
	 output logic [4:0] Loc;
    output logic Done, Found;
    logic [4:0] middle;
    always_ff @(posedge Clock) begin
        if (load_regs | Reset) begin
            left = 5'b00000;
            right = 5'b11111;
            middle = 5'b01111;
        end

        if (compute_next) begin
            middle = left + ((right - left) >> 1);
            if (middle_data < A)
                left = middle + 1;
            else
                right = middle - 1;
  			   middle = left + ((right - left) >> 1);
        end
    end

    ram32x8 ram (.address(middle), .clock(Clock), .data(8'h00), .wren(1'b0), .q(middle_data));

    assign Done = Finished;
    assign Found = Located;
    assign Loc = Found ? middle : 5'b00000;
endmodule