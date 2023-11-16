module screen_clearer.sv(clock, reset, start, done, x, y);
    input logic clock, reset, start;
    output logic done;
    output logic [10:0] x, y;

    enum {idle, clearing, done} ps, ns;

    always_comb begin
        case (ps)
            idle: begin
                done = 0;
                x = 0;
                y = 0;
                ns = start ? clearing : idle;
            end
            clearing: begin
                done = 0;
                if (x != 640 && y != 480) begin
                    ns = clearing;
                end
                else ns = done;
            end
            done: begin
                done = 1;
            end
            default: begin
                done = 0;
                x = 0;
                y = 0;
            end
        endcase
    end

    always_ff @(posedge clock) begin
        if (reset)
            ps <= idle;
        else
            ps <= ns;
        if (ps == clearing) begin
            if (x == 640 && y != 480) begin
                x <= 0;
                y <= y + 1;
            end
            else if (x != 640) begin
                x <= x + 1;
            end
        end
    end
endmodule