use POSIX qw/ceil/;
my $num_of_rounds = 5;
my $number_of_parallel_structures = 16;		#keep in 2 raise to powers only
my $image_width = 256;

my $number_of_pixels = 8*$image_width*$image_width;
my $ram_width = 256*$number_of_parallel_structures;
my $number_of_parallel_structures_m1 = $number_of_parallel_structures - 1;		#keep in 2 raise to powers only
my $ram_depth = (8*$image_width*$image_width)/$ram_width;
my $ram_depth_log2 = ceil(log($ram_depth)/log(2));
print"
`include \"../RTL_verilog/encryption_top.v\"

module encryption_top_tb;

reg clk,rstn;

reg [31:0] config_x1_initial, config_x2_initial, config_x3_initial;
reg [127:0] config_key_initial;
reg [255:0] config_initialization_vector;
reg [9:0] config_wait_count_for_chaos_valid;

reg [7:0] MEM [0:$number_of_pixels-1];
reg [7:0] MEMOUT [0:$number_of_pixels-1];
wire encryption_done;


encryption_top encryption_top_inst(
.clk					 (clk),
.rstn                                    (rstn),
.config_x1_initial                       (config_x1_initial),
.config_x2_initial                       (config_x2_initial),
.config_x3_initial                       (config_x3_initial),
.config_initialization_vector            (config_initialization_vector),
.config_wait_count_for_chaos_valid       (config_wait_count_for_chaos_valid),
.config_key_initial                      (config_key_initial),
.encryption_done			 (encryption_done)
);

always #5 clk=~clk;
shortreal values1,values2,values3;
initial	begin
	
clk = 1'b0;
rstn = 1'b0;

values1 = 0.100001;
values2 = 0.01;
values3 = 0;

config_x1_initial = \$shortrealtobits(values1);
config_x2_initial = \$shortrealtobits(values2); 
config_x3_initial = \$shortrealtobits(values3);
config_key_initial = {8'h87,8'h54,8'hAA,8'h13,8'h00,8'h12,8'hE2,8'h31,8'h88,8'h56,8'h75,8'h34,8'hB3,8'hA2,8'h75,8'h24};
config_initialization_vector = 256'h37a4bef644fa663ff0e12ee7416d7175f6e0aa1d178d128f5f9124f90fd7106f;
config_wait_count_for_chaos_valid = 10'd256;
#20;
	rstn = 1'b1;
    

end

initial	begin
    \$readmemh(\"../image/ps2_pic_converted.txt\",MEM);          //path for reading orginal image


//CODE COMING AT SUPERSONIC SPEED, search for MEMORY_DESCRIPTION_ENDS IF YOU ARE STUCK in between this maze
";
    for(my $j =0;$j<$ram_depth;$j++)	{
    	for(my $i =0;$i<(32*$number_of_parallel_structures);$i++)	{
		my $ram_msb = 8*$i+7;
		my $ram_lsb = 8*$i;
		my $MEM_INDEX = $i+($j*32*$number_of_parallel_structures);
	print"	encryption_top_inst.ram_inst.mem[$j][$ram_msb : $ram_lsb] = MEM[$MEM_INDEX];
	";
	}
    }
print"
//[63].....[33],[32],[31].....[1],[0]
//				  [64]
\@(posedge encryption_done);
";
    for(my $j =0;$j<$ram_depth;$j++)	{
    	for(my $i =0;$i<(32*$number_of_parallel_structures);$i++)	{
		my $ram_msb = 8*$i+7;
		my $ram_lsb = 8*$i;
		my $MEM_INDEX = $i+($j*32*$number_of_parallel_structures);
	print"  MEM[$MEM_INDEX] = encryption_top_inst.ram_inst.mem[$j][$ram_msb:$ram_lsb] ;
	";
	}
    }
print"
//MEMORY_DESCRIPTION_ENDS

    \$writememh(\"../image/ps2_pic_encrypted.txt\",MEM);
end



endmodule
";
