use POSIX qw/ceil/;
my $amount_of_parallel_structures = 16;
my $image_width = 256;
my $ram_width = 256*$amount_of_parallel_structures;
my $ram_depth = (8*$image_width*$image_width)/$ram_width;
my $ram_depth_log2 = ceil(log($ram_depth)/log(2));

print"
//this my width : $ram_width and depth : $ram_depth
//this is logs : depth : $ram_depth_log2;
module ram (
	input clk,
	input [$ram_depth_log2 - 1 : 0] ram_rd_address,
	input [$ram_depth_log2 - 1 : 0] ram_wr_address,
	input [$ram_width - 1 : 0] ram_wr_data,
	input wr_val,
	output [$ram_width - 1 : 0] ram_rd_data
);

  reg [$ram_width-1:0] mem [$ram_depth];

  assign ram_rd_data = mem[ram_wr_address];
  
  always @(posedge clk) begin
	mem[ram_wr_address] = wr_val ? ram_wr_data : mem[ram_wr_address];
  end
  

endmodule

";
