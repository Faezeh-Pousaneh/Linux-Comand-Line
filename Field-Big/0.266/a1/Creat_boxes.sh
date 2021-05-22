#!/bin/bash 
#!/usr/local/bin/gnuplot -persist



#array=( 0 1 2 3 4 5 6 7 8 )
array=( 21 22 23 24 25 26 27 28  )

for j in "${array[@]}"
do

cp -r V9 V$j

cd V$j

Z=2.740000

echo "scale=5;($Z+$j*0.3)*1." | bc > p.dat
Z=`tail -1  p.dat  | awk '{print $1}'`



sed "s/B=6.40000/B=$Z/"   V_Field.sh   -i
cd ..
done
