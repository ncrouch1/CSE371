/*
Henri Lower 2276644
Noah Crouch 2078812
*/

/*
	Inputs: Signals (Start, Reset, Clock, Enable), Data as byte (A - number)
	Outputs: Addresses (Loc), Signals (Done, Found)
*/

module binarysearch (A, Start, Reset, Clock, Loc, Done, Found, Enable);
	 // instantiate signals
    input logic Start, Reset, Clock, Enable;
    output logic Done, Found;
    input logic [7:0] A;
    output logic [4:0] Loc;
    logic [4:0] left, right;
    logic [7:0] middle_data;
    logic Finished, Located, load_regs, compute_next;
	 
	 // instantiate controller
    binarysearch_controller controller (
        .A(A), .Start(Start),
        .Clock(Clock),
        .Reset(Reset),
        .Finished(Finished),
        .Located(Located),
        .Enable(Enable),
        .load_regs(load_regs),
        .compute_next(compute_next),
        .left(left), .right(right),
        .middle_data(middle_data)
    );
	 
	 // instantiate datapath
    binarysearch_datapath datapath(
        .A(A),
        .Clock(Clock),
        .Reset(Reset),
        .load_regs(load_regs),
        .compute_next(compute_next),
		  .Finished(Finished), .Located(Located),
        .Loc(Loc), .left(left), .right(right),
        .middle_data(middle_data),
        .Done(Done), .Found(Found)
    );

endmodule

`timescale 1 ps / 1 ps
// Testbench module for binarysearch
module bsearch_tb();
	 // instantiate logic
    logic [7:0] A;
    logic Clock, Reset, Start, Done, Found;
    logic [4:0] Loc;
	 
	 // instantiate binary search
    binarysearch dut (.A(A), .Start(Start), .Reset(Reset), .Clock(Clock),
                .Loc(Loc), .Done(Done), .Found(Found), .Enable(1'b1));
    
	 // set period
    parameter T = 20;
	 
	 
	 // initiate clock
    initial begin
        Clock <= 0;
        forever #(T/2) Clock <= ~Clock;
    end

	 // start testing
    initial begin
		  // Reset and set start to 0
        Reset <= 1; Start <= 0;                        @(posedge Clock);
        // raise reset
		  Reset <= 0;   		  @(posedge Clock);
		  // Search for numbers 64 to 127
        for (int i = 64; i < 128; i++) begin
            A <= i;             @(posedge Clock);
				@(posedge Clock);
            Start <= 1;         @(posedge Clock);
            while (~Done) begin
                @(posedge Clock);
            end
            Start <= 0; @(posedge Clock);
				@(posedge Clock);
        end
        $stop;
    end
endmodule
