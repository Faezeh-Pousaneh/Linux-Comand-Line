#!/bin/bash 
#!/usr/local/bin/gnuplot -persist



array=( 21 22 23 24 25)

for j in "${array[@]}"
do


cd V$j


qsub V_0.266.sh

cd ..
done
