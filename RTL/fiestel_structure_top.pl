my $num_of_rounds=5;
print"

f_function_top(
plane_text_in,
cypher_text_out
);


key_generator(
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
";
