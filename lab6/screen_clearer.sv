module screen_clearer(clock, reset, start, done, x, y);
    input logic clock, reset, start;
    output logic done;
    output logic [10:0] x, y;

    enum {idle, clearing, clear_done} ps, ns;
    
    assign done = (ps == clear_done);

    always_comb begin
        case (ps)
            idle: begin
                ns = start ? clearing : idle;
            end
            clearing: begin
                if (x <= 640 & y <= 480) begin
                    ns = clearing;
                end
                else ns = clear_done;
            end
            clear_done: begin
                ns = start ? clear_done : idle;
            end
        endcase
    end

    always_ff @(posedge clock) begin
        if (reset) begin
            ps <= idle;
            x <= 0;
            y <= 0;
        end
        else
            ps <= ns;
        if (x <= 640 & y <= 480) begin
            x <= x + 1;
            if (x >= 640) begin
                x <= 0;
                y <= y + 1;
            end
        end
    end
endmodule

module screen_clearer_tb();
    logic [10:0] x, y;
    logic done, start, reset, clock;

    screen_clearer sc (.*);

    parameter T = 20;

    initial begin
        clock <= 0;
        forever #(T/2) clock <= ~clock;
    end

    initial begin
        reset <= 1; @(posedge clock)
        reset <= 0; start <= 1; @(posedge clock);
        while (~done) @(posedge clock);
        $stop;
    end
    
endmodule