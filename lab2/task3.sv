module task3(clock, enable, reset, datain, rdaddress, wraddress, wren, dataout);
    input logic clock, wren, reset, enable;
    input logic [4:0] rdaddress, wraddress;
    input logic [2:0] datain;
    output logic [2:0] dataout;
    
    logic [4:0] rdaddr, wraddr;

    ram32x3port2 ram(.clock(clock), .data(datain), .rdaddress(rdaddr), .wraddress(wraddr), .wren(wren), .q(dataout));

    always_ff @(posedge clock) begin
        if (reset) begin
            rdaddr <= 0;
            wraddr <= 0;
        end
        else if (enable) begin
            rdaddr <= rdaddress;
            wraddr <= wraddress;
        end
    end
endmodule

`timescale 1 ps / 1 ps
module task3_tb();
    logic clock, wren, reset;
    logic [4:0] rdaddress, wraddress;
    logic [2:0] datain, dataout;

    task3 dut(.clock, .enable(1), .reset, .datain, .rdaddress, .wraddress, .wren, .dataout);

    parameter T = 20;
    initial begin
        clock <= 0;
        forever #(T/2) clock <= ~clock;
    end

    initial begin
        rdaddress <= 0; wraddress <= 0; wren <= 0; datain <= 0; reset <= 1; @(posedge clock);
        reset <= 0; @(posedge clock);
        for (int i = 0; i < 32; i++) begin
            rdaddress++; @(posedge clock);
        end
        rdaddress <= 0; @(posedge clock);
        wren <= 1; datain <= 3'b111; @(posedge clock);
        for (int i = 0; i < 32; i++) begin
            rdaddress++; wraddress++; @(posedge clock);
        end
		  $stop;
    end
endmodule