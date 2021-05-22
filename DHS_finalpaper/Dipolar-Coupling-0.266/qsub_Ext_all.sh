#!/bin/bash 
#!/usr/local/bin/gnuplot -persist



array=(10 11 12 13 14 15 16 17 18 19 20)

for j in "${array[@]}"
do


cd V$j

cp  ../V10/E_0.266.sh E_0.266.sh

qsub E_0.266.sh

cd ..
done
