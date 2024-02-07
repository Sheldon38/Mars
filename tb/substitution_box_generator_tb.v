`include "../RTL_verilog/substitution_box_generator.v"

module substitution_box_generator_tb;

reg clk;
reg reset = 'b1;
reg enable_bar = 'b0;
reg [31:0] chaotic_signal_x1, chaotic_signal_x2, chaotic_signal_x3;
wire ready;
wire [7:0] sbox[16][16];

shortreal v1, v2, v3;

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

always #5 clk=~clk;

initial	begin
	clk = 1'b0;

	while(v1<0.5) begin
		v1 = v1 + 0.01;
		chaotic_signal_x1 = $shortrealtobits(v1);
		#10;
	end

end

reg [7:0] mem[16][16];
initial	begin
	if(substitution_box_ready)) begin
		mem = sbox;
        $writememh("substitution_box.txt",mem);
        $finish();
	end
end

endmodule