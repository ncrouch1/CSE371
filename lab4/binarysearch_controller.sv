/*
Henri Lower 2276644
Noah Crouch 2078812
*/

/*
	Inputs: Signals (Start, Reset, Clock, Enable), Addresses (left, right), data as byte (A - Number, middle_data - curr comparing num)
	Outputs: Signals (load_regs, compute_next, Finished, Located)
*/

module binarysearch_controller (
    Start, Reset, Clock, Enable, Finished, Located, load_regs, compute_next,
    A, middle_data, left, right
);

	 input logic Start, Reset, Clock, Enable;
	 input logic [7:0] A, middle_data;
	 input logic [4:0] left, right;
	 output logic Finished, Located, load_regs, compute_next;

    // Declare the current state (ps) and next state (ns) as an enum
    enum {idle, search, fetch, compute, done} ps, ns;

    // Combinational always block for control logic
    always_comb begin
        load_regs = 0; compute_next = 0; Finished = 0; Located = 0;
        case (ps)
            idle: begin
                // If Start is not asserted, load registers and stay in idle state
                if (~Start) begin
                    load_regs = 1;
                    ns = idle;
                end
                else
                    ns = search;
            end
            search: ns = fetch;
            fetch: ns = compute;
            compute: begin
                if (middle_data == A) begin
                    // If middle_data matches A, set Finished and Located and transition to done state
                    Finished = 1;
                    Located = 1;
                    ns = done;
                end
                else begin
                    ns = search;
                    // If left is less than right, set compute_next to 1, else transition to done
                    if (left < right)
                        compute_next = 1;
                    else 
                        ns = done;
                end
            end
            done: begin
                Finished = 1;
                if (middle_data == A) 
                    Located = 1;
                // Stay in done state if Start is still asserted, otherwise go back to idle
                ns = Start ? done : idle;
            end
            default: ns = idle;
        endcase
    end

    // Sequential always_ff block for state transitions
    always_ff @(posedge Clock) begin
        if (Reset | ~Enable) 
            ps <= idle;
        else
            ps <= ns;
    end
endmodule
