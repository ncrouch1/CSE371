module input_controller (
    input logic clock, reset, button, valid, drawing_done,
    output logic enable_validation, enable_setting, enable_ram,
    output logic enable_drawing, lock_input, player, update_state,
    output logic [9:0] LEDR;
    );

	enum {reading, validate, setting, fetching, drawing_state, toggle_player} ps, ns;
    
    assign enable_validation = (ps == validate);
    assign enable_setting = (ps == setting);
    assign enable_drawing = (ps == drawing_state);
    assign enable_ram = (ps == setting);
    assign update_state = (ps == toggle_player);
    assign lock_input = (ps != reading);
    assign LEDR[9] = 0;
    assign LEDR[8] = (gamestate[8] != 2'b00);
    assign LEDR[7] = (gamestate[7] != 2'b00);
    assign LEDR[6] = (gamestate[6] != 2'b00);
    assign LEDR[5] = (gamestate[5] != 2'b00);
    assign LEDR[4] = (gamestate[4] != 2'b00);
    assign LEDR[3] = (gamestate[3] != 2'b00);
    assign LEDR[2] = (gamestate[2] != 2'b00);
    assign LEDR[1] = (gamestate[1] != 2'b00);
    assign LEDR[0] = (gamestate[0] != 2'b00);

	// State logic
    always_comb begin 
        case(ps)
            reading: ns = button ? validate : reading;
            validate: ns =  valid ? setting : reading;
            setting: ns = fetching;
            fetching: ns = drawing_state;
            drawing_state: ns = drawing_done ? toggle_player : drawing_state;
            toggle_player: ns = reading;
			default: ns = ps;
        endcase
    end
    
    always_ff @(posedge clock) begin
        if (reset) begin
            ps <= reading;
            player <= 1'b0;
        end
        else
            ps <= ns;
        if (ps == toggle_player) begin
            player <= ~player;
        end
    end
endmodule

module input_controller_tb();
    logic clock, reset, button, drawing, valid, drawing_done,
    enable_validation, enable_setting, enable_ram, enable_drawing, lock_input, player, update_state;

    input_controller ic (.*);

    parameter T = 20;
    initial begin
        clock <= 0;
        forever #(T/2) clock <= ~clock;
    end

    initial begin
        reset <= 1'b1; button <= 1'b0; drawing <= 1'b0; drawing_done <= 1'b0; valid <= 1'b0; player <= 1'b0;        @(posedge clock);
        reset <= 1'b0;         @(posedge clock);
        button <= 1'b1;        @(posedge clock);
        button <= 1'b0; valid <= 1'b1;       @(posedge clock);
        valid <= 1'b0;         @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        drawing_done <= 1'b1;       @(posedge clock);
        drawing_done <= 1'b0;       @(posedge clock);
        repeat(4)   @(posedge clock);
        $stop;
    end
endmodule