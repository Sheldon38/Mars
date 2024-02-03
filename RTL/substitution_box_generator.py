print(
    """

module substitution_box_generator
(
    parameter BOX_ROWS = 16,
    parameter BOX_COLS = 16 // TODO: implement variable key size
)
(
    output reg [127:0] substitution_table[16],
    output reg ready,
    input [127:0] initial_vector,
    input [31:0] chaotic_signal_x1,
    input [31:0] chaotic_signal_x2,
    input [31:0] chaotic_signal_x3,
    input reset,
    input enable,
    input clk
);
    
    always @(posedge(clk)) begin
        if(!enable) begin
            ready <= 1'b0;
        end
        else if (rst) begin
            ready <= 1'b0;
            substitution_table <= 0;
        end
        else begin
            for(integer j = 0; j < BOX_ROWS; j++) begin
                substitution_table[j][7:0] <= initial_vector[8*(j+1) - 1: 8*j];
            end
        end
    end

endmodule;
    """
)
