#!/bin/bash
#PBS -A nn9572k
#PBS -l walltime=89:30:60
#PBS -l select=1:ncpus=32:mpiprocs=16
 

module purge
module load intelcomp/17.0.0
module load mpt/2.14
module load gromacs/2016.1

case=$PBS_JOBNAME
cd $PBS_O_WORKDIR


rm  em.* BOX.gro  Table_HS_modif.xvg  *#* *.log* *.cpt*   *sh.* em.gro NVT_e.gro NVT.gro *edr*  *.tpr* *.xtc*  *prev* *density*  press* *avera* Fit*  NVT.* NVT_vis* NVT_e.*
rm *RDF* rdf*  JJ_* LL_* max*  err* tcaf*  *VIS* dens* U_* C_* *Dens* t.* p.* C.xvg U.xvg volume*
rm -r gromos54a7.ff

B=3.80000

cp ../IMPUT/em.mdp em.mdp
cp ../IMPUT/NVT_e.mdp NVT_e.mdp
cp ../IMPUT/NVT.mdp NVT.mdp
cp ../IMPUT/topol.top topol.top
cp -r ../IMPUT/gromos54a7.ff gromos54a7.ff
cp ../IMPUT/Table_HS_modif.xvg Table_HS_modif.xvg
cp ../IMPUT/BOX.gro BOX.gro

sed "s/   3.35820   3.35820   3.35820/   $B   $B   $B/" BOX.gro -i

sed "s/ nsteps                    =/ nsteps                    = 40000000;/" NVT_e.mdp -i

sed "s/ nsteps                    =/ nsteps                    = 300000000;/" NVT.mdp -i


 gmx grompp -f em.mdp -c  BOX.gro  -p topol.top -o em.tpr  -maxwarn 3
 mpiexec_mpt  mdrun   -s  em.tpr    -deffnm em   -table Table_HS_modif.xvg

 gmx grompp -f NVT_e.mdp -c em.gro -p topol.top -o NVT_e.tpr -maxwarn 3  
 mpiexec_mpt  mdrun   -s  NVT_e.tpr    -deffnm NVT_e   -table Table_HS_modif.xvg


 gmx grompp -f NVT.mdp -c NVT_e.gro -p topol.top -o NVT.tpr   -maxwarn 3  -t NVT_e.cpt
 mpiexec_mpt  mdrun   -s  NVT.tpr    -deffnm NVT   -table Table_HS_modif.xvg


rm *#*

cp ../IMPUT/NVT_vis.mdp NVT_vis.mdp

sed "s/ nsteps                    =/ nsteps                    =60000000;/" NVT_vis.mdp -i
sed "s/ nstxout                   =/ nstxout                   =60;/" NVT_vis.mdp -i
sed "s/ nstvout                   =/ nstvout                   =60;/" NVT_vis.mdp -i


 gmx grompp  -f  NVT_vis.mdp   -c   NVT.gro   -p  topol.top  -o   NVT_vis.tpr   -maxwarn 3 -t  NVT.cpt
 mpiexec_mpt  mdrun   -s  NVT_vis.tpr    -deffnm NVT_vis   -table Table_HS_modif.xvg

echo 0 | gmx tcaf  -f NVT_vis.trr -s NVT_vis.tpr -normalize -b 10000  -ov  LL_4000.xvg
echo 0 | gmx tcaf  -f NVT_vis.trr -s NVT_vis.tpr -normalize -b 20000  -ov  LL_8000.xvg
echo 0 | gmx tcaf  -f NVT_vis.trr -s NVT_vis.tpr -normalize -b 30000  -ov  LL_12000.xvg
echo 0 | gmx tcaf  -f NVT_vis.trr -s NVT_vis.tpr -normalize -b 40000  -ov  LL_16000.xvg

rm *#*
rm NVT_vis.t*
rm NVT_vis.x*
rm NVT_vis.cpt

