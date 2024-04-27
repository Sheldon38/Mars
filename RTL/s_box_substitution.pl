print"
module s_box_substitution(
";
for(my $i=0;$i<16;$i++){
print"input [127:0] sub_table_${i},
";
}
print"
input [7:0] in_byte,
output reg [7:0] sub_byte
);

wire [3:0] row_index,col_index;
assign row_index = in_byte[7:4];
assign col_index = in_byte[3:0];

always @(*)	begin
	case(row_index)
";
for(my $row_i=0;$row_i<16;$row_i++){
print"	4'd${row_i} : begin
			case(col_index)
			";
		for(my $col_i=0;$col_i<16;$col_i++){
			my $col_lower_index = (15-${col_i})*8;
			my $col_upper_index = (15-${col_i})*8+7;
			print"4'd${col_i} : sub_byte = sub_table_${row_i}[$col_upper_index:$col_lower_index];
			";
		}
print"default : sub_byte = 8'd0;
			endcase
		  end
";
}
print"
	default : sub_byte = 8'd0;
	endcase
end

endmodule
";
