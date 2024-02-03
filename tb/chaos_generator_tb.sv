`include "../RTL_verilog/chaos_generator.v"
module chaos_generator_tb;
reg clk;
reg rst;
reg [31:0] x1_initial,x2_initial,x3_initial;
wire [31:0] x1_out,x2_out,x3_out;
shortreal values1,values2,values3;

chaos_generator DUT(clk,rst,x1_initial,x2_initial,x3_initial,x1_out,x2_out,x3_out);

always #5 clk=~clk;

initial	begin
	clk = 1'b0;
	values1 = 0.100001;
	values2 = 0.01;
	values3 = 0;
	x1_initial =$shortrealtobits(values1);
	x2_initial =$shortrealtobits(values2);
	x3_initial =$shortrealtobits(values3);
	rst = 1'b1;
	#13;
	rst = 1'b0;

end

reg [31:0] x1_mem[1000];
reg [31:0] x2_mem[1000];
reg [31:0] x3_mem[1000];
int i;
initial	begin
	i=0;
	while(i<1000)	begin
		@(posedge clk);
		x1_mem[i] = x1_out;
		x2_mem[i] = x2_out;
		x3_mem[i] = x3_out;
		i=i+1;
	end
	$writememh("x1_wave.txt",x1_mem);
	$writememh("x2_wave.txt",x2_mem);
	$writememh("x3_wave.txt",x3_mem);
	$finish();
end

endmodule
