module Task3 #(N=15) (input logic [23:0] indata,
            output logic [23:0] outdata,
            input logic clock, reset);
    // Fifo Signals
    logic [23:0] fifo_read, filtered_data;
    logic read, write, full, empty;

	 assign write = 1;
	 assign read = full;
	     // declare divided new number and summation number memmory space
    logic [23:0] divided, sum;
    // the divided number
    assign divided = {{N{indata[23]}}, indata[23:N]};

    // declare FIFO buffer
    fifo #(.DATA_WIDTH(24), .ADDR_WIDTH(N)) buffer (.clk(clock), .reset(reset), .rd(read), .wr(write), .empty(empty), .full(full),
			.w_data(divided), .r_data(filtered_data));
			
    // if the buffer is not full do not read
    assign fifo_read = ~full ? 24'b0 : filtered_data;

    // sum the new value and the removed number
    assign sum = (-1 * fifo_read) + divided;

    // Accumulator
    always_ff @(posedge clock) begin
        // if reset output 0
        if (reset) begin
            outdata <= 24'b0;
        end
        // else sum the new value minus removed value and sum with
        // the previous output
        else begin
            outdata <= sum + outdata;
        end
    end
endmodule

module Task3_tb();
    logic [23:0] indata, outdata;
    logic clock, reset;

    parameter T = 20;
    initial begin
        clock <= 0;
        forever #(T/2) clock <= ~clock;
    end

	 parameter N = 3;
    Task3 #(.N(N)) dut (.*);

    initial begin
        reset <= 1; indata <= 24'hAAFFFF; 					    	@(posedge clock);
        reset <= 0;                                   @(posedge clock);
        repeat(16) begin indata <= 24'h8;         @(posedge clock); end
		  repeat(16 / 4)											@(posedge clock);		  
        $stop;
    end
endmodule
