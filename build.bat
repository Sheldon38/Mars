@echo off

for %%A IN (.\\RTL\\*.py) do start /b /wait "" python "%%~fA" > ".\\RTL_verilog\\%%~nA.v"
for %%A IN (.\\RTL\\*.pl) do start /b /wait "" perl "%%~fA" > ".\\RTL_verilog\\%%~nA.v"
