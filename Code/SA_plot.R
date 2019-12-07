load("Sensitivity_Analysis.RData")
group_name=c("rural female","rural male","urban female","urban male")
res_name=c("confidence measure","anxiety measure","desperate measure")
for (res_id in c(1,2,3))
{
  for (subgroup in c(1,2,3,4))
  {
    pdf(paste("SA",res_id,subgroup,"stack.pdf",sep="_"),width=12,height=6)
    par(mfrow=c(1,2))
    res=SA_prte[[res_id]][,(subgroup-1)*3+c(1,2,3)]  
    plot(r_grid,res[,1],ylim=range(res),type='o',xaxt='n',
         xlab="Ratio of direct effect/total effect, r",ylab="Treatment Effect",
         main=paste("Sensitivity analysis on PRTE\n",res_name[res_id],",",group_name[subgroup],sep=""))
    axis(1,at=seq(-0.5,0.5,length=11),las=2)
    lines(r_grid,res[,2],lty=2)
    lines(r_grid,res[,3],lty=2)
    abline(h=0,lty=2)
    abline(v=0,lty=2)

    res=SA_prte[[res_id]][,(subgroup-1)*3+c(1,2,3)]      
    plot(r_grid,res[,1],ylim=range(res),type='o',xaxt='n',
         xlab="Ratio of direct effect/total effect, r",ylab="Treatment Effect",
         main=paste("Sensitivity analysis on ATT\n",res_name[res_id],",",group_name[subgroup],sep=""))
    axis(1,at=seq(-0.5,0.5,length=11),las=2)
    lines(r_grid,res[,2],lty=2)
    lines(r_grid,res[,3],lty=2)
    abline(h=0,lty=2)
    abline(v=0,lty=2)
    dev.off()
  }
}