my $num_of_rounds=5;
my $num_of_rounds_m1 = $num_of_rounds - 1;
print"
`include \"f_function_top.v\"
module decryption_fiestel_structure_top(
clk,
rst,
cypher_text_in,
plane_text_out,
";
for(my $i=0;$i<$num_of_rounds;$i++){
print"key_for_round_${i},
";
}
print"
";
for(my $i=0;$i<16;$i++){
print"substitution_box_row${i},
";
}
print"
substitution_table_valid
);


input clk;
input rst;
input [255:0] cypher_text_in;
output [255:0] plane_text_out;
";
for(my $i=0;$i<$num_of_rounds;$i++){
print"input [127:0] key_for_round_${i};
";
}
print"
";
for(my $i=0;$i<16;$i++){
print"input [127:0] substitution_box_row${i};
";
}
print"
input substitution_table_valid;
";


for(my $i=0;$i<$num_of_rounds;$i++){
my $num_of_rounds_m_i_m_1 = $num_of_rounds_m1 - $i;
my $i_m_1 = $i-1;
print"
wire [127:0] lhs_plane_text_for_round${i},rhs_plane_text_for_round${i};
wire [127:0] lhs_cypher_text_for_round${i},rhs_cypher_text_for_round${i};
";
if($i eq 0){
print"
assign lhs_cypher_text_for_round${i} = cypher_text_in[255:128];
assign rhs_cypher_text_for_round${i} = cypher_text_in[127:0];
";
}
else{
print"
assign lhs_cypher_text_for_round${i} = lhs_plane_text_for_round${i_m_1};
assign rhs_cypher_text_for_round${i} = rhs_plane_text_for_round${i_m_1};
";
}
print"
wire [127:0] f_function_out_for_round${i};

f_function_top f_function_for_round${i}(
.state_in	(lhs_cypher_text_for_round${i}),
";
for(my $i=0;$i<16;$i++){
print".sub_table_${i} (substitution_box_row${i}),
";
}
print"
.key_in         (key_for_round_${num_of_rounds_m_i_m_1}),
.state_out      (f_function_out_for_round${i})
);

assign lhs_plane_text_for_round${i} = rhs_cypher_text_for_round${i} ^ f_function_out_for_round${i};
assign rhs_plane_text_for_round${i} = lhs_cypher_text_for_round${i};

";
}
print"
assign plane_text_out = substitution_table_valid ? {lhs_plane_text_for_round${num_of_rounds_m1},rhs_plane_text_for_round${num_of_rounds_m1}} : 128'd0;



endmodule
";
