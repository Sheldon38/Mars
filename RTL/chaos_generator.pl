print"
`include \"sawtooth_wave.v\"
`include \"../RTL/multiplier/Multiplication.v\"
module chaos_generator(
clk,
rst,
x1_initial,
x2_initial,
x3_initial,
x1_out,
x2_out,
x3_out
);


input clk;
input rst;
input [31:0] x1_initial;
input [31:0] x2_initial;
input [31:0] x3_initial;
output reg [31:0] x1_out;
output reg [31:0] x2_out;
output reg [31:0] x3_out;
wire [31:0] x1_b20_p_x2_b20,x2_b20_p_x3_b20,x1_b20_p_x3_b20;
wire [31:0] x1_p_x2_b20_p_u3,x2_p_x3_b20_p_u1,x1_p_x3_b20_p_u2;

always @(posedge clk,posedge rst)	begin
	if(rst)	begin
		x1_out <= x1_initial;
                x2_out <= x2_initial;
                x3_out <= x3_initial;
	end
	else	begin
		x1_out <= {1'b0,x2_p_x3_b20_p_u1[30:0]};
                x2_out <= {1'b0,x1_p_x3_b20_p_u2[30:0]};
                x3_out <= {1'b0,x1_p_x2_b20_p_u3[30:0]};
	end
end

//Multiplication m1(.a_operand(),.b_operand(),.result());
//sawtooth_wave s1(.clk(),.x_in(),.y_out());

wire [31:0] u1,u2,u3;
wire [31:0] sigma_times_x1k,sigma_times_x2k,sigma_times_x3k;
wire [31:0] x1_by_20,x2_by_20,x3_by_20;
//01000000000110010000011000100101	//2.391
//00111101010011001100110011001101	//1/20 = 0.05
";

for(my $i=1;$i<4;$i++){
	my $i_p3 = $i+3;
print"Multiplication m${i}(.a_operand(32'b01000000000110010000011000100101),.b_operand(x${i}_out),.result(sigma_times_x${i}k));
Multiplication m${i_p3}(.a_operand(32'b00111101010011001100110011001101),.b_operand(x${i}_out),.result(x${i}_by_20));
sawtooth_wave s${i}(.clk(clk),.x_in(sigma_times_x${i}k),.y_out(u${i}));
";
}
print"
float_adder A0(.Number1(x1_by_20),.Number2(x2_by_20),.Result(x1_b20_p_x2_b20));
float_adder A1(.Number1(x2_by_20),.Number2(x3_by_20),.Result(x2_b20_p_x3_b20));
float_adder A2(.Number1(x1_by_20),.Number2(x3_by_20),.Result(x1_b20_p_x3_b20));

float_adder A4(.Number1(x1_b20_p_x2_b20),.Number2(u3),.Result(x1_p_x2_b20_p_u3));
float_adder A5(.Number1(x2_b20_p_x3_b20),.Number2(u1),.Result(x2_p_x3_b20_p_u1));
float_adder A6(.Number1(x1_b20_p_x3_b20),.Number2(u2),.Result(x1_p_x3_b20_p_u2));



endmodule
";
