/*
Lab 5
EE 371
Noah Crouch	2078812
Henri Lower 2276644

/* 
 * Scans the VGA Adapter screen from top left to bottom right.
 */
module screen_clearer(clock, reset, start, done, x, y);
    // declare signals
    input logic clock, reset, start;
    output logic done;
    output logic [10:0] x, y;

    // declare states and containers
    enum {idle, clearing, clear_done} ps, ns;
    
    // assign done to be when we're in the clear done state
    assign done = (ps == clear_done);

    // state traversal logic
    always_comb begin
        case (ps)
            // if idle wait for start signal to move to clearing
            // else stay in idle
            idle: begin
                ns = start ? clearing : idle;
            end
            // if clearing, wait until x and y are not at valid positions
            // to move to done. Valid positions being x < 640 & y < 480
            clearing: begin
                if (x != 640 & y != 480) begin
                    ns = clearing;
                end
                else ns = clear_done;
            end
            // if done, wait for start signal to go low to traverse back to idle
            clear_done: begin
                ns = start ? clear_done : idle;
            end
            // default load idle
			default: ns = idle;
        endcase
    end

    // synchronous logic
    always_ff @(posedge clock) begin
        // if reset, load idle to the present state, set x and y to 0
        if (reset) begin
            ps <= idle;
            x <= 0;
            y <= 0;
        end
        // else load ns into ps
        else
            ps <= ns;
        // if ps is idle state set x and y to zero
        if (ps == idle) begin
            x <= 0;
            y <= 0;
        end

        // if coordinates are still valid
        if (x <= 639 & y <= 479) begin
            // increment x
            x <= x + 1;
            // then check to see if x is again still valid
            if (x >= 639) begin
                // if x is not valid load 0 into x and increment y
                x <= 0;
                y <= y + 1;
            end
        end
    end
endmodule

/*
Lab 5
EE 371
Noah Crouch	2078812
Henri Lower 2276644

/* 
 * Tests the screen clearer
 */
module screen_clearer_tb();
    // declare all needed logic
    logic [10:0] x, y;
    logic done, start, reset, clock;

    // instantiate the screen clearer
    screen_clearer sc (.*);

    // create the period parameter
    parameter T = 20;

    // start the clock
    initial begin
        clock <= 0;
        forever #(T/2) clock <= ~clock;
    end

    // begin logic testing
    initial begin
        // set the reset
        reset <= 1; @(posedge clock)
        // unset the reset, set the start signal
        reset <= 0; start <= 1; @(posedge clock);
        // wait till done
        while (~done) @(posedge clock);
        // stop sim
        $stop;
    end
    
endmodule