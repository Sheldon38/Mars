use POSIX qw/ceil/;
my $num_of_rounds = 5;
my $number_of_parallel_structures = 2;		#keep in 2 raise to powers only
my $image_width = 256;

my $ram_width = 256*$number_of_parallel_structures;
my $number_of_parallel_structures_m1 = $number_of_parallel_structures - 1;		#keep in 2 raise to powers only
my $ram_depth = (8*$image_width*$image_width)/$ram_width;
my $ram_depth_m1 = $ram_depth - 1;
my $ram_depth_log2 = ceil(log($ram_depth)/log(2));
print"
`include \"../RTL_verilog/key_generator.v\"
`include \"../RTL_verilog/substitution_box_generator.v\"
`include \"../RTL_verilog/chaos_generator.v\"
`include \"../RTL_verilog/fiestel_structure_top.v\"

//1x30 aloo   paratha
//1x30 gobhi  paratha
//2x40 paneer paratha
//=140

//2x25 aloo paratha
//2x35 paneer paratha
//120

module encryption_top(
clk,
rstn,
config_x1_initial,
config_x2_initial,
config_x3_initial,
config_initialization_vector,
config_wait_count_for_chaos_valid,
config_key_initial,

ram_rd_address,
ram_wr_address,
ram_wr_data,
ram_rd_data,
wr_valid,

encryption_done
);


input clk;
input rstn;
input [31:0] config_x1_initial;
input [31:0] config_x2_initial;
input [31:0] config_x3_initial;
input [127:0] config_key_initial;
input [255:0] config_initialization_vector;
input [9:0] config_wait_count_for_chaos_valid;
output reg encryption_done;

output [$ram_depth_log2 - 1 : 0] ram_rd_address;
output reg [$ram_depth_log2 - 1 : 0] ram_wr_address;
output [$ram_width - 1 : 0] ram_wr_data;
output wr_valid;
input [$ram_width - 1 : 0] ram_rd_data;


assign ram_rd_address = ram_wr_address;

always \@(posedge clk,negedge rstn)	begin
	if(!rstn)	begin
		encryption_done <= 1'd0;
	end
	else	begin
		encryption_done <= (ram_wr_address == ${ram_depth_log2}'d${ram_depth_m1}) ? 1'b1 : encryption_done;
	end
end


//ram ram_inst(
//.clk		(clk),
//.ram_rd_address (ram_rd_address),
//.ram_wr_address (ram_wr_address),
//.ram_wr_data    (ram_wr_data),
//.wr_val         (wr_valid),
//.ram_rd_data    (ram_rd_data)
//);

wire [31:0] x1_initial;
wire [31:0] x2_initial;
wire [31:0] x3_initial;


assign x1_initial = config_x1_initial;
assign x2_initial = config_x2_initial;
assign x3_initial = config_x3_initial;

wire [31:0] x1_out;
wire [31:0] x2_out;
wire [31:0] x3_out;

wire rst;
assign rst = ~rstn;
chaos_generator chaos_generator_inst(
.clk		(clk),
.rst		(rst),
.x1_initial     (x1_initial),
.x2_initial     (x2_initial),
.x3_initial     (x3_initial),
.x1_out         (x1_out),
.x2_out         (x2_out),
.x3_out         (x3_out)
);

reg [9:0] chaos_ready_counter;

always\@(posedge clk,negedge rstn)	begin
	if(!rstn)	begin
		chaos_ready_counter <= 10'd0;
	end
	else	begin
		chaos_ready_counter <= (chaos_ready_counter < config_wait_count_for_chaos_valid) ? chaos_ready_counter + 1 : chaos_ready_counter;
	end
end
";
for(my $i=0;$i<16;$i++){
print"wire [127:0] substitution_box_row${i};
";
}
print"
wire substitution_box_ready;
wire [31:0] chaotic_signal_x1;
wire [31:0] chaotic_signal_x2;
wire [31:0] chaotic_signal_x3;
wire enable_bar;
assign enable_bar = (chaos_ready_counter == config_wait_count_for_chaos_valid) ? 1'b0 : 1'b1;
assign chaotic_signal_x1 = x1_out;
assign chaotic_signal_x2 = x2_out;
assign chaotic_signal_x3 = x3_out;

substitution_box_generator substitution_box_generator_inst
(
";
for(my $i=0;$i<16;$i++){
print".substitution_box_row${i}	 (substitution_box_row${i}),
";
}
print"
.substitution_box_ready		 (substitution_box_ready),
.chaotic_signal_x1               (chaotic_signal_x1),
.chaotic_signal_x2               (chaotic_signal_x2),
.chaotic_signal_x3               (chaotic_signal_x3),
.reset                           (rst),
.enable_bar                      (enable_bar),
.clk                             (clk)
);




wire [127:0] key_initial;
assign key_initial = config_key_initial;
";
for(my $i=0;$i<$num_of_rounds;$i++){
print"wire [127:0] key_for_round_${i};
wire key_for_round_${i}_valid;
";
}
print"
wire substitution_table_valid;

key_generator key_generator_inst(
.clk		(clk),
.rst            (rst),
.key_initial    (key_initial),
";
for(my $i=0;$i<$num_of_rounds;$i++){
print".key_for_round_${i}	(key_for_round_${i}),
.key_for_round_${i}_valid	(key_for_round_${i}_valid),
";
}
print"
";
for(my $i=0;$i<16;$i++){
print".substitution_box_row${i}	 (substitution_box_row${i}),
";
}
print"
.substitution_table_valid	(substitution_table_valid)
);

assign substitution_table_valid = ~enable_bar && substitution_box_ready;
reg [255:0] mlc_cypher_text_out;

";
for(my $j=0;$j<$number_of_parallel_structures; $j++){
print"
wire [255:0] plane_text_in_for_str${j};
wire [255:0] cypher_text_out_for_str${j};
";
my $lsb = 256*${j};
my $msb = 255 + $lsb;
my $j_m_1 = $j - 1;
if($j eq 0){
print"
assign plane_text_in_for_str${j} = ram_rd_data [$msb:$lsb] ^ ((ram_rd_address == ${ram_depth_log2}'d0) ? config_initialization_vector : mlc_cypher_text_out);
";
}
else{
print"
assign plane_text_in_for_str${j} = ram_rd_data [$msb:$lsb] ^ cypher_text_out_for_str${j_m_1};
";
}
print"
fiestel_structure_top fiestel_structure_top_inst_${j}(
.clk			(clk),
.rst			(rst),
.plane_text_in		(plane_text_in_for_str${j}),
.cypher_text_out	(cypher_text_out_for_str${j}),
";
for(my $i=0;$i<$num_of_rounds;$i++){
print".key_for_round_${i}	(key_for_round_${i}),
";
}
print"
";
for(my $i=0;$i<16;$i++){
print".substitution_box_row${i}	 (substitution_box_row${i}),
";
}
print"
.substitution_table_valid	(substitution_table_valid)
);";
}
print"
assign wr_valid = substitution_table_valid && !encryption_done;
assign ram_wr_data = 
{";
for(my $j=$number_of_parallel_structures-1;$j>=0;$j--){
print"cypher_text_out_for_str${j}";
if($j ne 0){
print",";
}
}
print"
};


always \@(posedge clk,negedge rstn)	begin
	if(!rstn)	begin
		ram_wr_address <= ${ram_depth_log2}'d0;
		mlc_cypher_text_out <= 256'd0; 
	end
	else	begin
		ram_wr_address <= (substitution_table_valid && (ram_wr_address != ${ram_depth_log2}'d${ram_depth_m1})) ? ram_wr_address + ${ram_depth_log2}'d1 : ram_wr_address;
		mlc_cypher_text_out <= (ram_wr_address == ${ram_depth_log2}'d0) ? 256'd0 : cypher_text_out_for_str${number_of_parallel_structures_m1}; 
	end
end

endmodule

";
