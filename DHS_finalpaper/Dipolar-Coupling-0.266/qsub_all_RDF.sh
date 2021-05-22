#!/bin/bash 
#!/usr/local/bin/gnuplot -persist



array=( 22 23 24 25)

for j in "${array[@]}"
do


cd V$j
cp ../V0/RDF_V_0.266.sh RDF_V_0.266.sh

qsub RDF_V_0.266.sh

cd ..
done
