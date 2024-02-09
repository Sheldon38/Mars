`include "../RTL_verilog/chaos_generator.v"
`include "../RTL_verilog/substitution_box_generator.v"

`define CLOCK_PERIOD 10

module substitution_box_generator_tb;

reg clk;
reg reset = 'b1;
reg enable_bar = 'b0;
wire [31:0] chaotic_signal_x1, chaotic_signal_x2, chaotic_signal_x3;
reg [31:0] x1_initial, x2_initial, x3_initial;
wire ready;
wire [7:0] sbox[16][16];

shortreal v1, v2, v3;

chaos_generator chaos_generator_object(
    clk,
    reset,
    x1_initial,
    x2_initial,
    x3_initial,
    chaotic_signal_x1,
    chaotic_signal_x2,
    chaotic_signal_x3
);

substitution_box_generator DUT(
    sbox,
    ready,
    chaotic_signal_x1,
    chaotic_signal_x2,
    chaotic_signal_x3,
    reset,
    enable_bar,
    clk
);

always #(`CLOCK_PERIOD/2) clk=~clk;

initial	begin
	clk = 1'b0;
    enable_bar = 1'b0;
    reset = 1'b1;

    #`CLOCK_PERIOD reset = 'b0;
    forever begin
        #`CLOCK_PERIOD;
    end
end

reg [7:0] mem[16][16];
initial	begin
	if(substitution_box_ready) begin
		mem = sbox;
        $writememh("./output/substitution_box.txt",mem);
        $finish();
	end
end

endmodule