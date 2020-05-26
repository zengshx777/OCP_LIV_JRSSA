###Gibbs Sampler for Bayes LIV method
###Input X,Y,Z,Tr
###rm(list=ls())

# args=commandArgs(trailingOnly = TRUE)
# if(length(args)==0){
#   print("No arguments supplied.")
# }else{
#   for(i in 1:length(args)){
#     eval(parse(text=args[[i]]))
#   }
# }

source("simulation_helper.R")
set.seed(2019)

#h;simu_time;mcmc.time
simu_result=matrix(0,ncol=6,nrow=simu_time)
#h_max=
for (seed in 1:simu_time){
  simu.data=simulation_data(t2=h)
  bliv_result=Gibbs_LIV(X=simu.data$X,Y=simu.data$Y,Z=simu.data$Z,Tr=simu.data$Tr,mcmc_n=mcmc.time)
  
  ##True ATT
  true_att=mean((simu.data$Y1-simu.data$Y0)[simu.data$Tr==1])
  ##True PRTE
  zmin=min(simu.data$Z)
  zmax=max(simu.data$Z)
  c.index=simu.data$S<=zmax&simu.data$S>=zmin
  true_prte=mean((simu.data$Y1-simu.data$Y0)[c.index])
  
  #ols
  model_ols<-lm(Y~Tr+X+Tr*X,data=simu.data)
  ols_estimate=model_ols$coefficients[2]
  #2sls
  model_iv_1<-glm(Tr~X+Z,data=simu.data,family = binomial(link="probit"))
  # model_first<-lm(Tr~X+Z)
  fit_t<-fitted(model_iv_1)
  
  model_iv_2<-lm(Y~fit_t+X+X*fit_t,data=simu.data)
  iv_estimate<-model_iv_2$coefficients[2]
  
  bliv_att_estimate=mean(bliv_result$ATT)
  bliv_prte_estimate=mean(bliv_result$PRTE)
  
  simu_result[seed,]=c(true_att,ols_estimate,bliv_att_estimate,
                       true_prte,iv_estimate,bliv_prte_estimate)
  print(paste("==",seed,"=="))
}
save(simu_result,file=paste("simu",h,"result.RData",sep="_"))

