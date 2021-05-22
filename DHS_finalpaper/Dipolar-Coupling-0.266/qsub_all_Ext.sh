#!/bin/bash 
#!/usr/local/bin/gnuplot -persist



array=(15 16 17 18 19 )

for j in "${array[@]}"
do

cd V$j
cp ../V20/E_0.266.sh E_0.266.sh


qsub E_0.266.sh

cd ..
done
