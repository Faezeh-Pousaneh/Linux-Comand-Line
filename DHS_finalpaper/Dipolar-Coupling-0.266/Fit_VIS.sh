#!/bin/bash 
#!/usr/local/bin/gnuplot -persist




array=( 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20  21 22 23 24 25)
for j in "${array[@]}"
do

rm *#*
cd V$j
rm Fit_VIS_table.*
for (( i=4000; i<17000; i += 4000 ))
do

gnuplot <<- EOF
reset
vai(k,a0,a1,a2)=a0*(1-a1*k*k)+a2*k*k*k*k

set xlabel "{k}^*"
set ylabel "{/Symbol h}^*"
set key top left Left reverse
set terminal postscript color enhanced
set print "Fit_VIS_table.txt" append
fit [0.001:5] vai(x,a0,a1,a2) "LL_${i}.xvg" u 1:2 via a0,a1,a2
print "",a0," \


unset table
set output
EOF
done 
cd ..
done




########################
# compile summary
#touch summary_distances.dat
#for (( i=1; i<10; i++ ))
#do
 #   d=`tail -n 1 dist${i}.xvg | awk '{print $2}'`
  #  echo "${i} ${d}" >> summary_distances.dat
   # rm dist${i}.xvg
#done

