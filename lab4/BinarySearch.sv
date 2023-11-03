module binarysearch (A, Start, Reset, Clock, Loc, Done, Found, Enable);
    input logic Start, Reset, Clock, Enable;
    output logic Done, Found;
    input logic [7:0] A;
    output logic [4:0] Loc;
    logic [4:0] left, right;
    logic [7:0] middle_data;
    logic Finished, Located, load_regs, compute_next;

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
module bsearch_tb();
    logic [7:0] A;
    logic Clock, Reset, Start, Done, Found;
    logic [4:0] Loc;

    binarysearch dut (.A(A), .Start(Start), .Reset(Reset), .Clock(Clock),
                .Loc(Loc), .Done(Done), .Found(Found), .Enable(1'b1));
    
    parameter T = 20;

    initial begin
        Clock <= 0;
        forever #(T/2) Clock <= ~Clock;
    end

    initial begin
        Reset <= 1; Start <= 0;                        @(posedge Clock);
        Reset <= 0;                                    @(posedge Clock);
        for (int i = 0; i < 64; i++) begin
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
