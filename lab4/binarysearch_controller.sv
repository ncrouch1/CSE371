module binarysearch_controller (A, Start, Reset, Clock, Finished, Located,
                             Enable, load_regs, compute_next, left, right, middle_data);
    input logic Start, Reset, Clock, Enable;
    output logic Finished, Located, load_regs, compute_next;
    input logic [7:0] A, middle_data;
    input logic [4:0] left, right;

    enum {idle, search, fetch, compute, done} ps, ns;

    always_comb begin
        load_regs = 0; compute_next = 0; Finished = 0; Located = 0;
        case(ps)
            idle: begin
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
                    Finished = 1;
                    Located = 1;
                    ns = done;
                end
                else begin
                    ns = search;
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
                ns = Start ? done : idle;
            end
				default: ns = idle;
        endcase
    end

    always_ff @(posedge Clock) begin
        if (Reset | ~Enable) 
            ps <= idle;
        else
            ps <= ns;
    end
endmodule