#!/bin/bash 
#!/usr/local/bin/gnuplot -persist



array=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20)

for j in "${array[@]}"
do

cp -r V0 V$j

cd V$j

Z=3.50000

echo "scale=5;$Z+$j*0.3" | bc > p.dat
Z=`tail -1  p.dat  | awk '{print $1}'`



sed "s/B=3.50000/B=$Z/" V_0.266.sh -i
cd ..
done
