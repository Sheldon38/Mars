
`include "../RTL_verilog/decryption_fiestel_structure_top.v"
`include "../RTL_verilog/fiestel_structure_top.v"
`include "../RTL_verilog/key_generator.v"

module fiestel_tb;
reg clk,rst;
reg [127:0] key_initial;
reg [127:0] sub_table_0;
reg [127:0] sub_table_1;
reg [127:0] sub_table_2;
reg [127:0] sub_table_3;
reg [127:0] sub_table_4;
reg [127:0] sub_table_5;
reg [127:0] sub_table_6;
reg [127:0] sub_table_7;
reg [127:0] sub_table_8;
reg [127:0] sub_table_9;
reg [127:0] sub_table_10;
reg [127:0] sub_table_11;
reg [127:0] sub_table_12;
reg [127:0] sub_table_13;
reg [127:0] sub_table_14;
reg [127:0] sub_table_15;
reg substitution_table_valid;

wire [127:0] key_for_round_0;
wire [127:0] key_for_round_1;
wire [127:0] key_for_round_2;
wire [127:0] key_for_round_3;
wire [127:0] key_for_round_4;

reg [255:0] tb2encryption_plane_text;
wire [255:0] encryption2tb_cypher_text;
wire [255:0] tb2decryption_cypher_text;
wire [255:0] decryption2tb_plane_text;

assign tb2decryption_cypher_text  = encryption2tb_cypher_text;
//assign tb2decryption_cypher_text  = 256'h22ca04e808d8335164e1b15f1dd7d2d20b6b8da88364f224859a7b0f4e86335c;


fiestel_structure_top encryption_DUT(
	.clk				(clk),
	.rst				(~rstn),
	.plane_text_in			(tb2encryption_plane_text),
	.cypher_text_out		(encryption2tb_cypher_text),
  .key_for_round_0		(key_for_round_0),
  .key_for_round_1		(key_for_round_1),
  .key_for_round_2		(key_for_round_2),
  .key_for_round_3		(key_for_round_3),
  .key_for_round_4		(key_for_round_4),
	.substitution_box_row0		(sub_table_0),
	.substitution_box_row1		(sub_table_1),
	.substitution_box_row2		(sub_table_2),
	.substitution_box_row3		(sub_table_3),
	.substitution_box_row4		(sub_table_4),
	.substitution_box_row5		(sub_table_5),
	.substitution_box_row6		(sub_table_6),
	.substitution_box_row7		(sub_table_7),
	.substitution_box_row8		(sub_table_8),
	.substitution_box_row9		(sub_table_9),
	.substitution_box_row10		(sub_table_10),
	.substitution_box_row11		(sub_table_11),
	.substitution_box_row12		(sub_table_12),
	.substitution_box_row13		(sub_table_13),
	.substitution_box_row14		(sub_table_14),
	.substitution_box_row15		(sub_table_15),
       .substitution_table_valid	(substitution_table_valid)
);

decryption_fiestel_structure_top decryption_DUT(
	.clk				(clk),
	.rst				(~rstn),
	.plane_text_out			(decryption2tb_plane_text),
	.cypher_text_in 		(tb2decryption_cypher_text),
  .key_for_round_0		(key_for_round_0),
  .key_for_round_1		(key_for_round_1),
  .key_for_round_2		(key_for_round_2),
  .key_for_round_3		(key_for_round_3),
  .key_for_round_4		(key_for_round_4),
	.substitution_box_row0		(sub_table_0),
	.substitution_box_row1		(sub_table_1),
	.substitution_box_row2		(sub_table_2),
	.substitution_box_row3		(sub_table_3),
	.substitution_box_row4		(sub_table_4),
	.substitution_box_row5		(sub_table_5),
	.substitution_box_row6		(sub_table_6),
	.substitution_box_row7		(sub_table_7),
	.substitution_box_row8		(sub_table_8),
	.substitution_box_row9		(sub_table_9),
	.substitution_box_row10		(sub_table_10),
	.substitution_box_row11		(sub_table_11),
	.substitution_box_row12		(sub_table_12),
	.substitution_box_row13		(sub_table_13),
	.substitution_box_row14		(sub_table_14),
	.substitution_box_row15		(sub_table_15),
       .substitution_table_valid	(substitution_table_valid)
);

key_generator key_generator_DUT(
	.clk				(clk),
	.rst                            (rst),
	.key_initial                    (key_initial),
	.key_for_round_0                (key_for_round_0),
	.key_for_round_0_valid          (key_for_round_0_valid),
	.key_for_round_1                (key_for_round_1),
	.key_for_round_1_valid          (key_for_round_1_valid),
	.key_for_round_2                (key_for_round_2),
	.key_for_round_2_valid          (key_for_round_2_valid),
	.key_for_round_3                (key_for_round_3),
	.key_for_round_3_valid          (key_for_round_3_valid),
	.key_for_round_4                (key_for_round_4),
	.key_for_round_4_valid          (key_for_round_4_valid),
	.substitution_box_row0		(sub_table_0),
	.substitution_box_row1		(sub_table_1),
	.substitution_box_row2		(sub_table_2),
	.substitution_box_row3		(sub_table_3),
	.substitution_box_row4		(sub_table_4),
	.substitution_box_row5		(sub_table_5),
	.substitution_box_row6		(sub_table_6),
	.substitution_box_row7		(sub_table_7),
	.substitution_box_row8		(sub_table_8),
	.substitution_box_row9		(sub_table_9),
	.substitution_box_row10		(sub_table_10),
	.substitution_box_row11		(sub_table_11),
	.substitution_box_row12		(sub_table_12),
	.substitution_box_row13		(sub_table_13),
	.substitution_box_row14		(sub_table_14),
	.substitution_box_row15		(sub_table_15),
	.substitution_table_valid       (substitution_table_valid)
);



always #5 clk=~clk;

initial	begin
	clk = 1'b0;
	rst = 1'b1;

	//key_initial = {8'h75,8'h46,8'h20,8'h67,
	//	       8'h6E,8'h75,8'h4B,8'h20,
	//	       8'h79,8'h6D,8'h20,8'h73,
	//	       8'h74,8'h61,8'h68,8'h54};
	tb2encryption_plane_text = 256'h8b0fc5ee6e08e497c2ef4b9108428a1fbc01533bc8c895074590da3fb58e07a0;

 	key_initial = {8'h87,8'h54,8'hAA,8'h13,8'h00,8'h12,8'hE2,8'h31,8'h88,8'h56,8'h75,8'h34,8'hB3,8'hA2,8'h75,8'h24};

	sub_table_0={8'h63,8'h7c,8'h77,8'h7b,8'hf2,8'h6b,8'h6f,8'hc5,8'h30,8'h01,8'h67,8'h2b,8'hfe,8'hd7,8'hab,8'h76};
	sub_table_1={8'hca,8'h82,8'hc9,8'h7d,8'hfa,8'h59,8'h47,8'hf0,8'had,8'hd4,8'ha2,8'haf,8'h9c,8'ha4,8'h72,8'hc0};
	sub_table_2={8'hb7,8'hfd,8'h93,8'h26,8'h36,8'h3f,8'hf7,8'hcc,8'h34,8'ha5,8'he5,8'hf1,8'h71,8'hd8,8'h31,8'h15};
	sub_table_3={8'h04,8'hc7,8'h23,8'hc3,8'h18,8'h96,8'h05,8'h9a,8'h07,8'h12,8'h80,8'he2,8'heb,8'h27,8'hb2,8'h75};
	sub_table_4={8'h09,8'h83,8'h2c,8'h1a,8'h1b,8'h6e,8'h5a,8'ha0,8'h52,8'h3b,8'hd6,8'hb3,8'h29,8'he3,8'h2f,8'h84};
	sub_table_5={8'h53,8'hd1,8'h00,8'hed,8'h20,8'hfc,8'hb1,8'h5b,8'h6a,8'hcb,8'hbe,8'h39,8'h4a,8'h4c,8'h58,8'hcf};
	sub_table_6={8'hd0,8'hef,8'haa,8'hfb,8'h43,8'h4d,8'h33,8'h85,8'h45,8'hf9,8'h02,8'h7f,8'h50,8'h3c,8'h9f,8'ha8};
	sub_table_7={8'h51,8'ha3,8'h40,8'h8f,8'h92,8'h9d,8'h38,8'hf5,8'hbc,8'hb6,8'hda,8'h21,8'h10,8'hff,8'hf3,8'hd2};
	sub_table_8={8'hcd,8'h0c,8'h13,8'hec,8'h5f,8'h97,8'h44,8'h17,8'hc4,8'ha7,8'h7e,8'h3d,8'h64,8'h5d,8'h19,8'h73};
	sub_table_9={8'h60,8'h81,8'h4f,8'hdc,8'h22,8'h2a,8'h90,8'h88,8'h46,8'hee,8'hb8,8'h14,8'hde,8'h5e,8'h0b,8'hdb};
	sub_table_10={8'he0,8'h32,8'h3a,8'h0a,8'h49,8'h06,8'h24,8'h5c,8'hc2,8'hd3,8'hac,8'h62,8'h91,8'h95,8'he4,8'h79};
	sub_table_11={8'he7,8'hc8,8'h37,8'h6d,8'h8d,8'hd5,8'h4e,8'ha9,8'h6c,8'h56,8'hf4,8'hea,8'h65,8'h7a,8'hae,8'h08};
	sub_table_12={8'hba,8'h78,8'h25,8'h2e,8'h1c,8'ha6,8'hb4,8'hc6,8'he8,8'hdd,8'h74,8'h1f,8'h4b,8'hbd,8'h8b,8'h8a};
	sub_table_13={8'h70,8'h3e,8'hb5,8'h66,8'h48,8'h03,8'hf6,8'h0e,8'h61,8'h35,8'h57,8'hb9,8'h86,8'hc1,8'h1d,8'h9e};
	sub_table_14={8'he1,8'hf8,8'h98,8'h11,8'h69,8'hd9,8'h8e,8'h94,8'h9b,8'h1e,8'h87,8'he9,8'hce,8'h55,8'h28,8'hdf};
	sub_table_15={8'h8c,8'ha1,8'h89,8'h0d,8'hbf,8'he6,8'h42,8'h68,8'h41,8'h99,8'h2d,8'h0f,8'hb0,8'h54,8'hbb,8'h16};
	substitution_table_valid = 1'b1;
	#10;
	rst = 1'b0;
	#10;
	$display("%h",encryption2tb_cypher_text);
	$finish();

end

endmodule
