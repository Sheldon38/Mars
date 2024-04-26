`include "../RTL_verilog/chaos_generator.v"
`include "../RTL_verilog/substitution_box_generator.v"

`define CLOCK_PERIOD 10

module substitution_box_generator_tb;

localparam KEY_SIZE = 128;

reg clk;
reg reset = 'b1;
reg enable_bar = 'b0;
wire [31:0] chaotic_signal_x1, chaotic_signal_x2, chaotic_signal_x3;
reg [31:0] x1_initial, x2_initial, x3_initial;
wire ready;
wire [KEY_SIZE-1:0] sbox_row[0:15];

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
    sbox_row[0],
    sbox_row[1],
    sbox_row[2],
    sbox_row[3],
    sbox_row[4],
    sbox_row[5],
    sbox_row[6],
    sbox_row[7],
    sbox_row[8],
    sbox_row[9],
    sbox_row[10],
    sbox_row[11],
    sbox_row[12],
    sbox_row[13],
    sbox_row[14],
    sbox_row[15],
    ready,
    chaotic_signal_x1,
    chaotic_signal_x2,
    chaotic_signal_x3,
    reset,
    enable_bar,
    clk
);

reg [KEY_SIZE-1:0] mem[0:15];

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
            mem[i] = sbox_row[i];
        end
    $writememh("./output/substitution_box.txt", mem);
    $finish();
end

endmodule
