#!/bin/bash

mkdir -p in_out src
touch in_out/{input,output}.txt src/{A..I}.cpp src/misc.cpp
code in_out/{input,output}.txt src/{A..I}.cpp src/misc.cpp
