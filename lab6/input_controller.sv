module input_controller (
    input logic clock, reset, button, drawing,
    output logic enable_validation, enable_setting, enable_ram,
    output logic enable_drawing, lock_input, player, update_state
    );

	enum {reading, validate, setting, drawing, toggle_player} ps, ns;
    
    assign enable_validation = (ps == validate);
    assign enable_setting = (ps == setting);
    assign enable_drawing = (ps == drawing);
    assign enable_ram = (ps == setting);
    assign update_state = (ps == toggle_player);
    assign lock_input = (ps != reading);

	// State logic
    always_ff begin 
        case(ps)
            reading: ns = button ? validate : reading;
            validate: ns =  valid ? setting : reading;
            setting: ns = fetching;
            fetching: ns = drawing;
            drawing: ns = drawing_done ? toggle_player : drawing;
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

module input_handler_tb();
    logic [9:0] SW, metaSW;
    logic clock, reset, button, holding, valid;
endmodule