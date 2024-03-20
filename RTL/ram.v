
//this my width : 4096 and depth : 128
//this is logs : depth : 7;
module ram (
	input clk,
	input [7 - 1 : 0] ram_rd_address,
	input [7 - 1 : 0] ram_wr_address,
	input [4096 - 1 : 0] ram_wr_data,
	input wr_val,
	output [4096 - 1 : 0] ram_rd_data
);

  reg [4096-1:0] mem [128];

  assign ram_rd_data = mem[ram_wr_address];
  
  always @(posedge clk) begin
	mem[ram_wr_address] = wr_val ? ram_wr_data : mem[ram_wr_address];
  end
  

endmodule

