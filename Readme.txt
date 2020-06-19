Readme file of R scripts and datasets for ``Is being an only child harmful 
for psychological health?: Evidence from an instrumental variable analysis of
 China's One-Child Policy'' by Shuxi Zeng, Fan Li and Peng Ding

This package contains R scripts for implementing the approaches 
proposed in the paper ``Is being an only child harmful for psychological health?: 
Evidence from a local instrumental variable analysis of China's One-Child 
Policy'' by Zeng, Li and Ding, and the dataset from the empirical application 
of the paper.  

Shuxi Zeng
E-mail:shuxi.zeng@duke.edu

Fan Li
E-mail: fl35@duke.edu

Peng Ding
E-mail: pengdingpku@berkeley.edu



1.Datasets:

CFPS_2010.csv: Cleaned CFPS data 
Codebook.xlsx: Codebook for the CFPS data
cfps2010adult_report_nat092014.dta: Original CFPS data, can be downloaded from\\& http://www.isss.pku.edu.cn/cfps/EN/ with authorization.
The "Data" folder contains the dataset and codebook for variables:

2.Rcodes:

Data_Reading.R: Loading the CFPS data.
Data_Loading.R: Transform the data into the format for JAGS model.
JAGS_MODEL.R: Functions define the model used in JAGS config.
JAGS_Sampling.R: Main Script to perform MCMC, save the posterior sample.
Average_Estimands.R: Calculate the estimands defined in average, as well as the MTE, produce results for Figure 2.
Average_Utility_Func.R: Required functions for Average_Estimands.R.
OtherMethods.R: Implement other methods as comparison, produce results for Figure 4.
OtherMethods_Utility_Func.R: Required functions for OtherMethods.R.
JAGS_Model_SA.R: JAGS model config for sensitivity analysis.
JAGS_Sampling_SA.R: Perform MCMC for sensitivity analysis.
simulation_help.R: Some helper functions to run simulations.
simulation_main.R: Main script to run simulation and draw Figure 6.
simu.sh: Bash script to run simulations.
Figureplotting.R: Reproduce all figures in the paper.
Main_Outline.R: Outline the procedures to produce all the results.



