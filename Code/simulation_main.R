###Gibbs Sampler for Bayes LIV method
###Input X,Y,Z,Tr
###rm(list=ls())
setwd("~/Downloads/third year/OCP_Gibbs_JRSSA-/Simulation")
rm(list=ls())

args=commandArgs(trailingOnly = TRUE)
if(length(args)==0){
  print("No arguments supplied.")
}else{
  for(i in 1:length(args)){
    eval(parse(text=args[[i]]))
  }
}

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
  print(paste("==",simu_time,"=="))
}
save(simu_result,file=paste("simu",h,"result.RData",sep="_"))

##Summary Simulation results
bias_ols_compare=rep(0,10)
bias_2sls_compare=rep(0,10)
bias_liv1_compare=rep(0,10)
bias_liv2_compare=rep(0,10)
mse_ols_compare=rep(0,10)
mse_2sls_compare=rep(0,10)
mse_liv1_compare=rep(0,10)
mse_liv2_compare=rep(0,10)
var_ols_compare=rep(0,10)
var_2sls_compare=rep(0,10)
var_liv1_compare=rep(0,10)
var_liv2_compare=rep(0,10)
h_grid=seq(0,-.9,length=10)
#collection_simu=rep(list(NA),10)
load("Collected_Simu.RData")
for (i in 1:10)
{
  simu_result=collection_simu[[i]]
  bias_ols_compare[i]=abs(mean(simu_result[,2]-simu_result[,1]))
  bias_2sls_compare[i]=abs(mean(simu_result[,5]-simu_result[,4]))
  bias_liv1_compare[i]=abs(mean(simu_result[,3]-simu_result[,1]))
  bias_liv2_compare[i]=abs(mean(simu_result[,6]-simu_result[,4]))
  
  mse_ols_compare[i]=sqrt(mean((simu_result[,2]-simu_result[,1])^2))
  mse_2sls_compare[i]=sqrt(mean((simu_result[,5]-simu_result[,4])^2))
  mse_liv1_compare[i]=sqrt(mean((simu_result[,3]-simu_result[,1])^2))
  mse_liv2_compare[i]=sqrt(mean((simu_result[,6]-simu_result[,4])^2))
  
  var_ols_compare[i]=sd(simu_result[,2])
  var_2sls_compare[i]=sd(simu_result[,5])
  var_liv1_compare[i]=sd(simu_result[,3])
  var_liv2_compare[i]=sd(simu_result[,6])
}


pdf("Bias_simu.pdf",width=8,height=6)
plot(abs(h_grid),bias_2sls_compare-bias_liv2_compare,type='o',
     ylab="Advantage over bias",
     xlab="Heterogeneity degree,h",lty=4,main="Absolute bias comparison as heterogeneity increasing")
lines(abs(h_grid),bias_ols_compare-bias_liv1_compare,type='o')
abline(h=0,lty=2)
legend("bottomright",legend=c("OLS-LIV","2SLS-LIV"),lty=c(1,4))
dev.off()

pdf("MSE_simu.pdf",width=8,height=6)
plot(abs(h_grid),mse_2sls_compare-mse_liv2_compare,type='o',
     ylab=expression("Advantage over"+sqrt(MSE)),
     xlab="Heterogeneity degree,h",lty=4,main=expression(sqrt(MSE)+"comparison as heterogeneity increasing"))
lines(abs(h_grid),mse_ols_compare-mse_liv1_compare,type='o')
abline(h=0,lty=2)
legend("bottomright",legend=c("OLS-LIV","2SLS-LIV"),lty=c(1,4))
dev.off()

# plot(abs(h_grid),var_2sls_compare-var_liv2_compare,type='o',
#      ylab=expression("Advantage over"+sqrt(MSE)),
#      xlab="Heterogeneity degree,h",lty=4,main=expression(sqrt(MSE)+"comparison as heterogeneity increasing"))
# lines(abs(h_grid),var_ols_compare-var_liv1_compare,type='o')
# abline(h=0,lty=2)
# legend("bottomright",legend=c("OLS-LIV","2SLS-LIV"),lty=c(1,4))
# dev.off()