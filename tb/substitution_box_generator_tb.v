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
wire [7:0] sbox[0:15][0:15];

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

reg [7:0] mem[0:15][0:15];

always #(`CLOCK_PERIOD/2) clk=~clk;

initial	begin
	clk = 1'b0;
    enable_bar = 1'b0;
    reset = 1'b1;
    x1_initial = 32'h3DCC_CD53; // 0.1
	x2_initial = 32'h3C23_D70A; // 0.01
	x3_initial = 32'h0;
    #`CLOCK_PERIOD reset = 'b0;
    
    wait(ready == 1);
    for (integer i = 0; i < 16; i++) begin
        for (integer j = 0; j < 16; j++) begin
            mem[i][j] = sbox[i][j];
        end
    end
    $writememh("./output/substitution_box.txt", mem);
    $finish();
end

endmodule
