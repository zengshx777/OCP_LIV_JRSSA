# OCP_LIV_JRSSA

This repo contains the code and dataset to replicate the paper "Is being the only child harmful for psychological health?: Evidence from an instrumental variable analysis of China's One-Child Policy" by Shuxi Zeng, Fan Li and Peng Ding.

- The "Data" folder contains the dataset and codebook for variables:
  - **CFPS_2010.csv**: Cleaned CFPS data
  - **Codebook.xlsx**: Codebook for the CFPS data

- The "Code" folder contains the R scripts for replication:
  - **Data_Reading.R**: Loading the CFPS data.
  - **Data_Loading.R**: Transform the data into the format for JAGS model.
  - **JAGS_MODEL.R**: Functions define the model used in JAGS config.
  - **JAGS_Sampling.R**: Main Script to perform MCMC, save the posterior sample.
  - **Average_Estimands.R**: Calculate the estimands defined in average, as well as the MTE, produce results for  Figure 2.
  - **Average_Utility_Func.R**: Required functions for Average_Estimands.R.
  - **OtherMethods.R**: Implement other methods as comparison, produce results for Figure 4.
  - **OtherMethods_Utility_Func.R**: Required functions for OtherMethods.R.
  - **JAGS_Model_SA.R**: JAGS model config for sensitivity analysis.
  - **JAGS_Sampling_SA.R**: Perform MCMC for sensitivity analysis.
  - **simulation_help.R**: Some helper functions to run simulations.
  - **simulation_main.R**: Main script to run simulation and draw Figure 6.
  - **simu.sh**: Bash script to run simulations.
  - **Figureplotting.R**: Reproduce all figures in the paper.
  - **Main_Outline.R**: Outline the procedures to produce all the results.
