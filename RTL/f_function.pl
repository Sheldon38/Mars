my $num_of_rounds = 5;
print"
`include \"mix_column.v\"
module f_function_top(
state_in,
sub_table,
key_in,
state_out
);


input [127:0] state_in;
input [127:0] sub_table[16];
input [127:0] key_in;
output [127:0] state_out;


//SUBBYTE		DONE
//SHIFT			DONE
//MIX			DONE
//ADDKEY		DONE
wire [127:0] state_in_subbed;
";
for(my $i=0;$i<16;$i++){
my $lower_index = 8*${i};
my $upper_index = 8*${i}+7;
print"s_box_substitution	s_box_sub${i} (sub_table,state_in[$upper_index:$lower_index],state_in_subbed[$upper_index:$lower_index]);
";
}
print"
wire [31:0] state_table_0;
wire [31:0] state_table_1;
wire [31:0] state_table_2;
wire [31:0] state_table_3;
";
for(my $i=0;$i<4;$i++){
@symbol_array = ($i,$i+4,$i+8,$i+12);
print"assign state_table_${i} = {state_in_subbed[${\(($symbol_array[0]+1)*8-1)}:${\($symbol_array[0]*8)}],state_in_subbed[${\(($symbol_array[1]+1)*8-1)}:${\($symbol_array[1]*8)}],state_in_subbed[${\(($symbol_array[2]+1)*8-1)}:${\($symbol_array[2]*8)}],state_in_subbed[${\(($symbol_array[3]+1)*8-1)}:${\($symbol_array[3]*8)}]};
";
}
print"

wire [31:0] state_table_shifted_0;
wire [31:0] state_table_shifted_1;
wire [31:0] state_table_shifted_2;
wire [31:0] state_table_shifted_3;

//[31:24],[23:16],[15:8],[7:0]

assign state_table_shifted_0 = state_table_0;
assign state_table_shifted_1 = {state_table_1[23:0],state_table_1[31:24]};
assign state_table_shifted_2 = {state_table_2[15:0],state_table_2[31:16]};
assign state_table_shifted_3 = {state_table_3[7:0],state_table_3[31:8]};

wire [127:0] mix_col_in, mix_col_out;
//assign mix_col_in = 
//{state_table_shifted_3[7:0],state_table_shifted_2[7:0],state_table_shifted_1[7:0],state_table_shifted_0[7:0],
//state_table_shifted_3[15:8],state_table_shifted_2[15:8],state_table_shifted_1[15:8],state_table_shifted_0[15:8],
//state_table_shifted_3[23:16],state_table_shifted_2[23:16],state_table_shifted_1[23:16],state_table_shifted_0[23:16],
//state_table_shifted_3[31:24],state_table_shifted_2[31:24],state_table_shifted_1[31:24],state_table_shifted_0[31:24]};


assign mix_col_in = 
{state_table_shifted_0[31:24],state_table_shifted_1[31:24],state_table_shifted_2[31:24],state_table_shifted_3[31:24],
state_table_shifted_0[23:16],state_table_shifted_1[23:16],state_table_shifted_2[23:16],state_table_shifted_3[23:16],
state_table_shifted_0[15:08],state_table_shifted_1[15:08],state_table_shifted_2[15:08],state_table_shifted_3[15:8],
state_table_shifted_0[07:00],state_table_shifted_1[07:00],state_table_shifted_2[07:00],state_table_shifted_3[7:0]};

mixColumns mx(mix_col_in,mix_col_out);

wire [127:0] mix_col_reversed;
assign mix_col_reversed = {";
for(my $i=0;$i<16;$i++){
	my $lsb = 8*${i};
	my $msb = 8*${i}+7;
if($i ne 15){
print"mix_col_out[$msb:$lsb],";
}
else{
print"mix_col_out[$msb:$lsb]";
}
}
print"
};


assign state_out = mix_col_reversed ^ key_in;

endmodule
";
