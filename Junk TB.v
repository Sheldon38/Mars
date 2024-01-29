module tb_imgencrypt;
reg [7:0] MEM [0:98303];
reg [7:0] MEMOUT [0:98303];
    
initial
begin
    $readmemh("imtotxt.txt",MEM);          //path for reading orginal image
    
    //after image is done, signalled by a done signal, print ram from memout
    //in imgnew.txt

    $writememh("imgnew.txt",MEMOUT);            //path to write modified image
end

endmodule
