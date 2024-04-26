#!/bin/bash

for python_file in $(find ./RTL -name *.py)
do
    filename=$(basename "$python_file")
    nohup python $python_file > ./RTL_verilog/${filename%.*}.v & disown
done

for perl_file in $(find ./RTL -name *.pl)
do
    filename=$(basename "$perl_file")
    nohup python $perl_file > ./RTL_verilog/${filename%.*}.v & disown
done
