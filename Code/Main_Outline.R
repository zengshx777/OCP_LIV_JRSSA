#Main Script to Reproduce the Result
#You can run the following scripts sequentially and plot the 
#Figures in the paper with Figure Ploting Script 1-7.
#Sample the Posterior
source("JAGS_Sampling.R")

#Calculate the Fitted Probability to Produce Figure 1
source("Firstage Ploting.R")

#Calculate Estimands Defined on Average:MTE,TT, PRTE
source("Average_Estimands.R")

#Calculate the Estimands Defined on Ordinal Scale:TT PRTE
source("Ordinal_Estimands.R")

#Calculate Modeling Checking SPPV
source("Model_Checking_SPPV_Parallel_Version.R")

#Estimation from Other Methods
source("OtherMethods.R")

#Figure Reproduce
source("Figure1.R")
source("Figure3.R")
source("Figure4.R")
source("Figure5.R")
source("Figure6.R")
source("Figure7.R")