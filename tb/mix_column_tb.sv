`include "../RTL_verilog/mix_column.v"
module mixColumns_tb;
reg [0:127] in;

wire [0:127] out;	


mixColumns m (in,out);


initial begin
$monitor("input= %H , output= %h",in,out);
in= 128'h_63_F2_7D_D4_C9_63_D4_FA_FE_26_C9_63_30_F2_C9_82 ;
#10;
in=128'h_84e1dd69_1a41d76f_792d3897_83fbac70 ;
#10;
in=128'h_6353e08c_0960e104_cd70b751_bacad0e7;
#10;
end
endmodule
