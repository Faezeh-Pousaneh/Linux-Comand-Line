#!/bin/bash
#PBS -A nn9572k
#PBS -l walltime=49:10:60
#PBS -l select=1:ncpus=32:mpiprocs=16
 

module purge
module load intelcomp/17.0.0
module load mpt/2.14
module load gromacs/2016.1

case=$PBS_JOBNAME
cd $PBS_O_WORKDIR

 rm V_0*
 rm  LL_* NVT_vis*  J_RU*  E_RU*    Dens* density*  nvt.*  Fit* VIS*  table*   Vis*    tcaf*  Dens*  err* *table* *.dat* *.txt* *rdf* 
 rm  *#*  *pressure* box.txt 
 rm Mtot*  epsilon*   dipdist.xvg  fit.*
 rm *visc_k* t.dat p.dat  MM_* SS_* visc*
 rm *step*       *.sh.*    *#*
 rm -r FINISHED
 rm -r FINISHED-RDF

cp ../IMPUT/NVT_F.mdp NVT_F.mdp
cp ../IMPUT/NVT_vis.mdp NVT_vis.mdp
############PRESSURE#########################################################

B=6.40000

cp ../IMPUT/em.mdp em.mdp
cp ../IMPUT/NVT_e.mdp NVT_e.mdp
cp ../IMPUT/NVT.mdp NVT.mdp
cp ../IMPUT/BOX.gro BOX.gro

sed "s/   6.37735   6.37735   6.37735/   $B   $B   $B/" BOX.gro -i
sed "s/ nsteps                    =/ nsteps                    = 200000000;/" NVT.mdp -i



 gmx grompp -f NVT_e.mdp -c BOX.gro -p topol.top -o NVT_e.tpr -maxwarn 3
 mpiexec_mpt  mdrun   -s  NVT_e.tpr    -deffnm NVT_e   -table Table_HS_modif.xvg


 gmx grompp -f NVT.mdp -c NVT_e.gro -p topol.top -o NVT.tpr   -maxwarn 3  -t NVT_e.cpt
 mpiexec_mpt  mdrun   -s  NVT.tpr    -deffnm NVT   -table Table_HS_modif.xvg



sed "s/ dt                        =/ dt                        = 0.002;/" NVT_F.mdp -i
sed "s/ nsteps                    =/ nsteps                    = 100000000;/" NVT_F.mdp -i
sed "s/ E-x                       =/ E-x                       = 1  0.75   0;/" NVT_F.mdp -i


 gmx grompp -f NVT_F.mdp -c NVT.gro -p topol.top -o NVT_F.tpr   -maxwarn 3  -t NVT.cpt
 mpiexec_mpt  mdrun   -s  NVT_F.tpr    -deffnm NVT_F   -table Table_HS_modif.xvg



sed "s/ nsteps                    =/ nsteps                    =60000000;/" NVT_vis.mdp -i
sed "s/ nstxout                   =/ nstxout                   =100;/" NVT_vis.mdp -i
sed "s/ nstvout                   =/ nstvout                   =100;/" NVT_vis.mdp -i
sed "s/ E-x                       =/ E-x                       = 1  0.75   0;/" NVT_F.mdp -i

 gmx grompp  -f  NVT_vis.mdp   -c   NVT_F.gro   -p  topol.top  -o   NVT_vis.tpr   -maxwarn 3 -t  NVT_F.cpt
 mpiexec_mpt  mdrun   -s  NVT_vis.tpr    -deffnm NVT_vis   -table Table_HS_modif.xvg

echo 0 | gmx tcaf  -f NVT_vis.trr -s NVT_vis.tpr -normalize -b 10000  -ov  LL_4000.xvg
echo 0 | gmx tcaf  -f NVT_vis.trr -s NVT_vis.tpr -normalize -b 20000  -ov  LL_8000.xvg
echo 0 | gmx tcaf  -f NVT_vis.trr -s NVT_vis.tpr -normalize -b 30000  -ov  LL_12000.xvg
echo 0 | gmx tcaf  -f NVT_vis.trr -s NVT_vis.tpr -normalize -b 40000  -ov  LL_16000.xvg

rm *#*
rm NVT_vis.t*
rm NVT_vis.x*
rm NVT_vis.cpt

