#!/bin/bash
#PBS -A nn9573k
#PBS -l walltime=01:30:60
#PBS -l select=1:ncpus=32:mpiprocs=16
 

module purge
module load intelcomp/17.0.0
module load mpt/2.14
module load gromacs/2016.1

case=$PBS_JOBNAME
cd $PBS_O_WORKDIR

cp ../IMPUT/NVT_rdf.mdp NVT_rdf.mdp


rm RDF.xvt rdf.xvg RDF_clea* 
rm -r FINISHED-RDF
rm *#* 

 gmx grompp -f NVT_rdf.mdp -c NVT.gro -p topol.top -o NVT_rdf.tpr   -maxwarn 3  -t NVT.cpt
 mpiexec_mpt  mdrun   -s  NVT_rdf.tpr    -deffnm NVT_rdf   -table Table_HS_modif.xvg

gmx rdf  -f  NVT_rdf.xtc  -s  NVT_rdf.tpr  -pbc   -ref 1 -sel 0   -selrpos  mol_com -seltype  mol_com  -b 50 -o RDF.xvg
rm *#*
rm NVT_rdf.x*
rm NVT_rdf.t*
rm NVT_rdf.l*
rm NVT_rdf.c*
mkdir FINISHED-RDF
