##Summary Simulation results
##Draw Figure 8 in the paper.
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
load("Figure8.RData")
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

pdf("simu_result.pdf",width=12,height=6)
par(mfrow=c(1,2))
#pdf("Bias_simu.pdf",width=8,height=6)
plot(abs(h_grid),bias_2sls_compare-bias_liv2_compare,type='o',
     ylab="Advantage over absolute bias",
     xlab="h",lty=4)
lines(abs(h_grid),bias_ols_compare-bias_liv1_compare,type='o')
abline(h=0,lty=2)
legend("bottomright",legend=c("OLS-LIV","2SLS-LIV"),lty=c(1,4))
#dev.off()

#pdf("MSE_simu.pdf",width=8,height=6)
plot(abs(h_grid),mse_2sls_compare-mse_liv2_compare,type='o',
     ylab=expression("Advantage over RMSE"),
     xlab="h",lty=4)
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