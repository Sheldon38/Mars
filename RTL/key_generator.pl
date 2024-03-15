my $num_of_rounds = 5;
@rc_values=("00","01","02","04","08","10","20","40","80","1B","36");
print"
`include \"s_box_substitution.v\"
module key_generator(
clk,
rst,
key_initial,
";
for(my $i=0;$i<$num_of_rounds;$i++){
print"key_for_round_${i},
key_for_round_${i}_valid,
";
}
print"
sub_table,
substitution_table_valid
);


input clk;
input rst;
input [127:0] key_initial;
";
for(my $i=0;$i<$num_of_rounds;$i++){
print"output [127:0] key_for_round_${i};
output key_for_round_${i}_valid;
";
}
print"
input [127:0] sub_table[16];
input substitution_table_valid;

wire [31:0] key_table[4];
";
for(my $i=0;$i<4;$i++){
@symbol_array = ($i,$i+4,$i+8,$i+12);
print"assign key_table[${i}] = {key_initial[${\(($symbol_array[0]+1)*8-1)}:${\($symbol_array[0]*8)}],key_initial[${\(($symbol_array[1]+1)*8-1)}:${\($symbol_array[1]*8)}],key_initial[${\(($symbol_array[2]+1)*8-1)}:${\($symbol_array[2]*8)}],key_initial[${\(($symbol_array[3]+1)*8-1)}:${\($symbol_array[3]*8)}]};
";
}
print"


wire [31:0] word0,word1,word2,word3;
";
for(my $i=0;$i<4;$i++){
	my $four_m_i = 4-$i;
print"assign word${i} = {key_table[0][${\($four_m_i*8-1)}:${\(($four_m_i-1)*8)}],key_table[1][${\($four_m_i*8-1)}:${\(($four_m_i-1)*8)}],key_table[2][${\($four_m_i*8-1)}:${\(($four_m_i-1)*8)}],key_table[3][${\($four_m_i*8-1)}:${\(($four_m_i-1)*8)}]};
";
}
print"

assign key_for_round_0 = 
{word3[7:0],word3[15:8],word3[23:16],word3[31:24]
,word2[7:0],word2[15:8],word2[23:16],word2[31:24]
,word1[7:0],word1[15:8],word1[23:16],word1[31:24]
,word0[7:0],word0[15:8],word0[23:16],word0[31:24]};


assign key_for_round_0_valid = 1'b1;		//first key is always valid coz it's just mixup of wires


";
for(my $i=1;$i<$num_of_rounds;$i++){
	my $i_m_1 = $i - 1;
print"
	wire [31:0] word${\(4*$i-1)}_prime;
	//generator function

	wire [7:0] byte_0_for_round${i},byte_1_for_round${i},byte_2_for_round${i},byte_3_for_round${i};

	assign byte_0_for_round${i} = word${\(4*$i-1)} [31:24];
	assign byte_1_for_round${i} = word${\(4*$i-1)} [23:16];
	assign byte_2_for_round${i} = word${\(4*$i-1)} [15:8];
	assign byte_3_for_round${i} = word${\(4*$i-1)} [7:0];

	wire [7:0] sub_byte_0_for_round${i},sub_byte_1_for_round${i},sub_byte_2_for_round${i},sub_byte_3_for_round${i};

	s_box_substitution	s_box_sub_round${i}_0 (sub_table,byte_0_for_round${i},sub_byte_0_for_round${i});
	s_box_substitution	s_box_sub_round${i}_1 (sub_table,byte_1_for_round${i},sub_byte_1_for_round${i});
	s_box_substitution	s_box_sub_round${i}_2 (sub_table,byte_2_for_round${i},sub_byte_2_for_round${i});
	s_box_substitution	s_box_sub_round${i}_3 (sub_table,byte_3_for_round${i},sub_byte_3_for_round${i});

	wire [7:0] sub_byte_1_for_round${i}_xored;
        assign sub_byte_1_for_round${i}_xored = 8'h$rc_values[$i] ^ sub_byte_1_for_round${i};

	assign word${\(4*$i-1)}_prime = {sub_byte_1_for_round${i}_xored,sub_byte_2_for_round${i},sub_byte_3_for_round${i},sub_byte_0_for_round${i}};

	wire [31:0] word${\(4*$i)},word${\(4*$i+1)},word${\(4*$i+2)},word${\(4*$i+3)};
	assign word${\(4*$i)}   = word${\(4*$i_m_1)}   ^ word${\(4*$i-1)}_prime;
	assign word${\(4*$i+1)} = word${\(4*$i_m_1+1)} ^ word${\(4*$i)};
	assign word${\(4*$i+2)} = word${\(4*$i_m_1+2)} ^ word${\(4*$i+1)};
	assign word${\(4*$i+3)} = word${\(4*$i_m_1+3)} ^ word${\(4*$i+2)};

//assign key_for_round_${i} = {word${\(4*$i)},word${\(4*$i+1)},word${\(4*$i+2)},word${\(4*$i+3)}};

assign key_for_round_${i} = 
{word${\(4*$i+3)} [7:0],word${\(4*$i+3)} [15:8],word${\(4*$i+3)} [23:16],word${\(4*$i+3)} [31:24]
,word${\(4*$i+2)} [7:0],word${\(4*$i+2)} [15:8],word${\(4*$i+2)} [23:16],word${\(4*$i+2)} [31:24]
,word${\(4*$i+1)} [7:0],word${\(4*$i+1)} [15:8],word${\(4*$i+1)} [23:16],word${\(4*$i+1)} [31:24]
,word${\(4*$i)} [7:0],word${\(4*$i)} [15:8],word${\(4*$i)} [23:16],word${\(4*$i)} [31:24]};



assign key_for_round_${i}_valid = substitution_table_valid;		//first key is always valid coz it's just mixup of wires

";
}
print"

endmodule
";

