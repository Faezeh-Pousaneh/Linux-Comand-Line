#!/bin/bash
#!/usr/local/bin/gnuplot -persist



array=(2 3  5  8   )

for j in "${array[@]}"
do

cd V$j
cp ../V2/E_Field.sh E_Field.sh
qsub E_Field.sh


cd ..
done


