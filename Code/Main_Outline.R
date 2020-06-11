#Main Script to Reproduce the Result
#You can run the following scripts sequentially and plot the 
#Figures in the paper with Figure Ploting Script 1-7.
#Sample the Posterior
source("JAGS_Sampling.R")

#Calculate the Fitted Probability to Produce Figure 1
source("Firstage Ploting.R")

#Calculate Estimands Defined on Average:MTE,TT, PRTE
source("Average_Estimands.R")

# #Calculate the Estimands Defined on Ordinal Scale:TT PRTE
# source("Ordinal_Estimands.R")

# #Calculate Modeling Checking SPPV
# source("Model_Checking_SPPV_Parallel_Version.R")

#Estimation from Other Methods
source("OtherMethods.R")

##Sensitivity Analysis
##Sensitivity parameter
delta_grid=seq(-0.2,0.2,length=11)
for (delta in delta_grid){
  source("JAGS_Sampling_SA.R")}

##Simulation
##Heterogeneity Parameter
## run bash script: bash simu.sh

#Figures Reproduce
source("Figureplotting.R")
#source("Figure8.R")