`include "sawtooth_wave.v"
module sawtooth_wave_tb;
reg clk;
reg [31:0] x_in;
wire [31:0] y_out;
shortreal values;


sawtooth_wave DUT(clk,x_in,y_out);

always #5 clk=~clk;

initial	begin
	clk = 1'b0;
	x_in = 32'b0_10000101_01010100100000000000000;
	values = -5;

	while(values <5)	begin
		values = values + 0.01;
		$display("values : %b",$shortrealtobits(values));
		$display("values (in d) : %f",values);
		$display("floor_x : %b",DUT.floor_x);
		$display("floor_x (in d) : %f",DUT.floor_x);
		x_in =$shortrealtobits(values);
		#10;
	end

end

reg [31:0] mem[1000];
int i;
initial	begin
	i=0;
	forever @(posedge clk)	begin
		mem[i] = y_out;
		i=i+1;
//		$display("time : %0t",$time());
//		$display("values : %b",values);
//		$display("values (in d) : %f",values);
//		$display("y_out (in d) : %h",y_out);
//		$display("y_out (in d) : %f",y_out);
		if(values >= 5)
			break;
	end
	$writememh("sawtooth_wave.txt",mem);
	$finish();
end

endmodule
