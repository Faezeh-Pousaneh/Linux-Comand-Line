#!/bin/bash
#!/usr/local/bin/gnuplot -persist

array=( 0 1 2 3 4 5 6 7 8      )

for j in "${array[@]}"
do

cd V$j
cp ../V0/V_Field.sh V_Field.sh
qsub V_Field.sh


cd ..
done


