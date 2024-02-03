print"
`include \"../RTL/adder/float_adder_v2.v\"
module sawtooth_wave(
clk,
x_in,
y_out
);

input clk;
input [31:0] x_in;
output [31:0] y_out;

wire x_sign;
wire [7:0] x_exponent;
wire [22:0] x_mantissa;

assign x_sign = x_in[31];
assign x_exponent = x_in[30:23];
assign x_mantissa = x_in[22:0];
";
print"
wire [7:0] shift_initial;
assign shift_initial = (x_exponent < 8'd127) ? 8'd0 : x_exponent-8'd127;

wire [22:0] x_mantissa_shifted_initial;
assign x_mantissa_shifted_initial = (x_mantissa << shift_initial);

wire [7:0] x_exponent_initial;
assign x_exponent_initial = (x_exponent - shift_initial);

//now need to get most significant 1
reg [4:0] most_significant_one;

always @(*)	begin
	most_significant_one = ";
for(my $i=1;$i<24;$i++){
	my $shifted_i = 23-$i;
print"
	x_mantissa_shifted_initial[$shifted_i] ? 5'd${i} :";
}
	print"5'd0;
end


wire [22:0] x_mantissa_shifted_final;
assign x_mantissa_shifted_final = (x_exponent < 8'd127) ? x_mantissa_shifted_initial : (x_mantissa_shifted_initial << most_significant_one);

wire [7:0] x_exponent_final;
assign x_exponent_final =  (x_exponent < 8'd127) ? x_exponent_initial : 
			    ((x_exponent_initial - most_significant_one) == 8'd127 && (x_mantissa_shifted_final == 23'd0)) ? 8'd0 : (x_exponent_initial - most_significant_one);

wire [31:0] floor_x;
assign floor_x = {x_sign,x_exponent_final,x_mantissa_shifted_final};


//5 adder we need here
//opposite to the sign, we would add/subtract 0.2 = 32'b00111110010011001100110011001101
//the point where sign changes, we would take the previous shit

wire [31:0] subtracted_0;
wire [31:0] subtracted_1;
wire [31:0] subtracted_2;
wire [31:0] subtracted_3;
wire [31:0] subtracted_4;
";
for(my $i=0;$i<5;$i++){
	my $i_p1 = $i+1;
	my $i_m1 = $i-1;
if($i==0){
print"float_adder A${i}(.Number1(floor_x),.Number2({~x_sign,31'b0111110010011001100110011001101}),.Result(subtracted_${i}));
";}
else {
print"float_adder A${i}(.Number1(subtracted_${i_m1}),.Number2({~x_sign,31'b0111110010011001100110011001101}),.Result(subtracted_${i}));
";
}
}
print"

wire[31:0] normalized_x;
assign normalized_x = (subtracted_0[31] != x_sign) ? floor_x : 
		      (subtracted_1[31] != x_sign) ? subtracted_0 :
		      (subtracted_2[31] != x_sign) ? subtracted_1 :
		      (subtracted_3[31] != x_sign) ? subtracted_2 :
		      (subtracted_4[31] != x_sign) ? subtracted_3 :
		       subtracted_4;
		      

wire [31:0] normalized_x_m_0p5;
wire [31:0] normalized_x_m_1p5;

float_adder x_m_0p5(.Number1({1'b0,normalized_x[30:0]}),.Number2(32'b10111101010011001100110011001101),.Result(normalized_x_m_0p5));
float_adder x_m_1p5(.Number1({1'b0,normalized_x[30:0]}),.Number2(32'b10111110000110011001100110011010),.Result(normalized_x_m_1p5));


wire sign_normalized_x_m_0p5;
wire sign_normalized_x_m_1p5;

assign sign_normalized_x_m_0p5 = normalized_x_m_0p5[31];
assign sign_normalized_x_m_1p5 = normalized_x_m_1p5[31];

reg [31:0] number_to_be_added;
reg sign_of_x_while_calculation;

always @(*)	begin
	case({sign_normalized_x_m_0p5,sign_normalized_x_m_1p5})
		2'b00 : begin number_to_be_added = 32'b10111110010011001100110011001101;		//-0.2
			      sign_of_x_while_calculation = 1'b0;
			end
		2'b01 : begin number_to_be_added = 32'b00111101110011001100110011001101;		//0.1
			      sign_of_x_while_calculation = 1'b1;
			end
		2'b10 : begin number_to_be_added = 32'd0;
			      sign_of_x_while_calculation = 1'b0;
			end
		2'b11 : begin number_to_be_added = 32'd0;
			      sign_of_x_while_calculation = 1'b0;
			end
		default : begin number_to_be_added = 32'd0; 
			      sign_of_x_while_calculation = 1'b0;
			  end
	endcase
end

wire [31:0] sawtooth_final_pre;
                                                                 
float_adder sawtooth_function(.Number1({sign_of_x_while_calculation,normalized_x[30:0]}),.Number2(number_to_be_added),.Result(sawtooth_final_pre));

wire sawtooth_final_sign;
assign sawtooth_final_sign = x_sign ^ sawtooth_final_pre[31];

assign y_out = {sawtooth_final_sign,sawtooth_final_pre[30:0]};


endmodule


";
#We want only the decimal part, not the other 
#85.125
#85 = 1010101
#0.125 = 001
#85.125 = 1010101.001
#       =1.010101001 x 2^6 
#
#biased exponent 127+6=133
#133 = 10000101
#Normalised mantisa = 010101001
#
#	        127+6
#85.125 = 0 10000101 01010100100000000000000 
#00.125 = 0 01111100 00000000000000000000000  shift = 9
#		127-3
#
#              127+3
#08.370 = 0 10000010 00001011110101110000101  
#                   22
#00.370 = 0 01111101 01111010111000010100100   shift = 5
#	        127-2
#
#NO NEED IF EXPONENT LESS THAN 127
#0.0001 = 0 01110001 10100011011011100010111
#
#              127+0
#01.000 = 0 01111111 00000000000000000000000  shift = 0
#
#	        127+5
#37.000 = 0 10000100 00101000000000000000000  shift = 5
#
#
#
#
#Just need to calculate the shift, that will make my life ez  
#a) exponent - 127
#b) left shift by that much
#c) after that,if msb is 0, find the next most significant 1, if there is
#none, leave
#d) left shift again by this much and subtract result from the exponent_new
#e) if after shift, we are left with 127 + 0, change it to 0
#	    127-1
#0.880 = 0 0111_1110 11000010100011110101110
#
#  127-1
#1 0111_1110 10001010001111010111000		//-0.77
#1 0111_1101 10001111010111000010100		//-0.39
#  127-2
