#!/bin/bash 
#!/usr/local/bin/gnuplot -persist



array=(21 22 23 24 25)

for j in "${array[@]}"
do

cp -r V0 V$j

cd V$j

Z=-0.84000

echo "scale=5;$Z+($j*2.0/10.0)" | bc > p.dat
Z=`tail -1  p.dat  | awk '{print $1}'`



sed "s/B=3.50000/B=$Z/" V_0.266.sh -i
cd ..
done
