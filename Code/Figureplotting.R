library("reshape2") # needed for melt()
library("ggplot2")

#Codes Below Produce Figure 1 in the Paper
load("Figure.RData")
pdf("Firstage_Prob_Quantile.pdf",height=4,width= 8)
par(mfrow=c(1, 1),mar = c(4.5,4.5,0,0))
#Index to Draw Points Along the Line
index=seq(1,1000,by=100)
#Create a Grid of Quantile for the IV
z.quantile=seq(0,1,length=1000)
plot(z.quantile,newz.p[,1],ylim=range(newz.p),type='l',lty=1,
     lwd=2,xlab="Quantile of the IFPPR",
     ylab="Probability of Being the Only Child",
     main="",
     yaxt = "n", xaxt = "n", axes = F)
axis(1, at = seq(0, 1, 0.1), 
     labels = seq(0, 1, 0.1))   
axis(2, at = c(0, 0.1, 0.3, 0.5, 0.7), 
     labels = c("0", ".1", ".3", ".5", ".7")) 

points(z.quantile[index],newz.p[index,1],pch=1,cex=1)
lines(z.quantile,newz.p[,2],type='l',lty=1,lwd=2)
points(z.quantile[index],newz.p[index,2],pch=2,cex=1)
lines(z.quantile,newz.p[,3],type='l',lty=1,lwd=2)
points(z.quantile[index],newz.p[index,3],pch=5,cex=1)
lines(z.quantile,newz.p[,4],type='l',lty=1,lwd=2)
points(z.quantile[index],newz.p[index,4],pch=6,cex=1)
legend("topleft",legend=Subgroup.name,lty=1,pch=c(1,2,5,6),cex=0.7)

dev.off()

#Transform From List to Long Vector
MTE=MTE_up=MTE_low=NULL
for (res in 1:3)
{
  for(k in 1:4)
  {
    MTE<-c(MTE,mte[[res]][[k]][1,])
    MTE_up<-c(MTE_up,mte[[res]][[k]][2,])
    MTE_low<-c(MTE_low,mte[[res]][[k]][3,])
  }
}

df <- data.frame(Grid=rep(seq(0.01,0.99,length=100),12),
                 MTE = MTE,
                 MTE_low = MTE_low,
                 MTE_up = MTE_up,
                 ruralgender = rep(rep(c("Rural Female", 
                                         "Rural Male", 
                                         "Urban Female", 
                                         "Urban Male"), each=100), 3),
                 measure = rep(c("Confidence", "Anxiety", "Desperation"), each=400))
df$measure.f=factor(df$measure,levels=c("Confidence","Anxiety","Desperation"))


p4<-ggplot(df, aes(Grid)) + 
  # Draw MTE lines, as well as the Confidence Interval
  geom_line(aes(y=MTE),size=0.9,linetype="solid") +
  geom_line(aes(y=MTE_up),size=0.9,linetype="dashed") +
  geom_line(aes(y=MTE_low),size=0.9,linetype="dashed") +
  # Lay out plots in a grid fomat, with "measure" used as the vertical
  # facet group and "ruralgender" used as the horizontal facet group
  facet_grid(measure.f~ruralgender) +
  # Add horizontal lines at 0
  geom_hline(yintercept=0, linetype="dotdash",alpha=0.5) +
  labs(title = "", x = "Quantile of principal strata", y="MTE",
       shape="", color="") +
  # Choose a grayscale palette
  scale_color_grey() +
  # Remove the default grey background
  theme_bw() +
  # Customizations. Center plot title, and remove background lines
  theme(plot.title = element_text(hjust = 0.5),
        panel.spacing.x = unit(1, "lines"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        legend.position="none")
pdf(file = "Expected_MTE.pdf",height=6,width=8.5)
p4
dev.off()

df <- data.frame(
  #Indicate Whether is point estimation or bound
  type=c(rep("0",12),rep("1",12),rep("95",48)),
  #Indicate Whether is TT or PRTE
  tt_prte=c(
    rep(1,12),rep(2,12),rep(1,12),rep(2,12),
    rep(1,12),rep(2,12)
  ),
  limy.up=1,
  limy.down=c(rep(0,24),rep(NA,48)),
  pairs=c(
    1:24,1:24,1:24),
  #Grid of X to Plot on 
  Grid=rep(
    c(rep(c(1,2,3,4),3),rep(c(1,2,3,4),3)+0.3),3),
  #Values of Point
  #Point Estimation for the Estimands
  Values=c(
    c(TAU[,4],TAU[,1]),
    #Upper Bound 
    c(TAU[,6],TAU[,3]),
    #Lower Bound
    c(TAU[,5],TAU[,2])),
  #Indicate Whether is tau,rho,eta
  name=c(rep("tau",72)),
  #Measures Names
  measure = rep(rep(c("Confidence", "Anxiety", "Desperation"), each=4),6))
#df$name.f=factor(df$name,levels=c(expression(tau),expression(rho),expression(eta)))
df$measure.f=factor(df$measure,levels=c("Confidence","Anxiety","Desperation"))
df$type.f=factor(df$type,levels=c(0,1,95))

p5<-ggplot(df, aes(x=Grid, y=Values,group=pairs)) + 
  # Add points, whose color and shape varies with the "variable" column
  geom_point(data=df,aes(shape=type.f),size=2, alpha=0.9) +
  geom_line(aes(x=Grid,y=Values),linetype="dashed")+
  # Provide breakpoints and respective labelings for the x-axis
  scale_x_continuous(breaks=c(1.15,2.15,3.15,4.15), labels=c("Rural-F", "Rural-M", "Urban-F","Urban-M")) +
  # Lay out plots in a grid fomat, with "measure" used as the vertical
  # facet group and "ruralgender" used as the horizontal facet group
  scale_shape_manual(values=c(16,15,32),labels=c("ATT","PRTE",""))+
  facet_grid(~measure.f,scale="free",labeller = label_parsed) +
  # Add horizontal lines at 0
  geom_hline(aes(yintercept= 0), linetype="dotdash")+
  # Add labels. Note that to rename the legend, you have to rename both the
  # "shape" and the "color" variables.
  labs(title = "", x = "Subgroups", y="Treatment effect",
       shape="") +
  # Choose a grayscale palette
  scale_color_grey() +
  # Remove the default grey background
  theme_bw() +
  # Customizations. Center plot title, and remove background lines
  theme(plot.title = element_text(hjust = 0.5),
        panel.spacing.x = unit(1, "lines"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        legend.position="top")


pdf("overalleffects.pdf", width = 8.5, height = 3.3)
p5
dev.off()


pdf("Pos_PS_confidence.pdf",width=8,height = 6)
unique_grid=sort(PS_pos_mean[[1]])
F1=ecdf(PS_pos_mean[[1]])
cdf_value=F1(unique_grid)
plot(unique_grid,cdf_value,lwd=2,type='l',xlab="Principal strata",
     ylab="Cumulative distribution",main="")
#unique_grid=sort(PS_pos_mean[[2]])
F2=ecdf(PS_pos_mean[[2]])
cdf_value=F2(unique_grid)
lines(unique_grid,cdf_value,lwd=2,lty=2)
F3=ecdf(PS_pos_mean[[3]])
cdf_value=F3(unique_grid)
lines(unique_grid,cdf_value,lwd=2,lty=3)
F4=ecdf(PS_pos_mean[[4]])
cdf_value=F4(unique_grid)
lines(unique_grid,cdf_value,lwd=2,lty=4)
abline(v=c(0,140),lty=2)
legend("topleft",lty=c(1,2,3,4),lwd=2,
       legend=c("Rural females","Rural males","Urban females","Urban males"))
dev.off()
# F1=ecdf(PS_pos_mean[[1]])
# plot(F1,
#      xlab = "Principal strata",
#      ylab = "Cumulativa distribution function",
#      main="")
# abline(v=c(0,140),lty=2)
# F2=ecdf(PS_pos_mean[[2]])
# lines(F2,col="red")
# F3=ecdf(PS_pos_mean[[3]])
# lines(F3,col="blue",cex=0.1)
# F4=ecdf(PS_pos_mean[[4]])
# lines(F4,col="orange",cex=0.1)
# legend("topleft",lty=1,col=c("black","red","blue","orange"),
#        legend=c("Rural females","Rural males","Urban females","Urban males"))





pdf("Pos_PS_confidence_rf.pdf",width=8,height=6)
F1=ecdf(PS_pos_mean[[1]])
plot(F1,
     xlab = "Principal strata",
     ylab = "Cumulativa distribution function")
abline(v=c(0,140),lty=2)
dev.off()



pdf("Pos_PS_anxiety.pdf",width=8,height = 6)
F1=ecdf(PS_pos_mean[[5]])
plot(F1,
     xlab = "Principal strata",
     ylab = "Cumulativa distribution function")
abline(v=c(0,140),lty=2)
F2=ecdf(PS_pos_mean[[6]])
lines(F2,col="red")
F3=ecdf(PS_pos_mean[[7]])
lines(F3,col="blue",cex=0.1)
F4=ecdf(PS_pos_mean[[8]])
lines(F4,col="orange",cex=0.1)
legend("topleft",lty=1,col=c("black","red","blue","orange"),
       legend=c("Rural females","Rural males","Urban females","Urban males"))
dev.off()



pdf("Pos_PS_anxiety_rf.pdf",width=8,height=6)
F1=ecdf(PS_pos_mean[[5]])
plot(F1,
     xlab = "Principal strata",
     ylab = "Cumulative distribution function")
abline(v=c(0,140),lty=2)
dev.off()

pdf("Pos_PS_desperation.pdf",width=8,height = 6)
F1=ecdf(PS_pos_mean[[9]])
plot(F1,
     xlab = "Principal strata",
     ylab = "Cumulative distribution function")
abline(v=c(0,140),lty=2)
F2=ecdf(PS_pos_mean[[10]])
lines(F2,col="red")
F3=ecdf(PS_pos_mean[[11]])
lines(F3,col="blue",cex=0.1)
F4=ecdf(PS_pos_mean[[12]])
lines(F4,col="orange",cex=0.1)
legend("topleft",lty=1,col=c("black","red","blue","orange"),
       legend=c("Rural females","Rural males","Urban females","Urban males"))
dev.off()



pdf("Pos_PS_desperation_rf.pdf",width=8,height=6)
F1=ecdf(PS_pos_mean[[9]])
plot(F1,
     xlab = "Principal strata",
     ylab = "Cumulative distribution function")
abline(v=c(0,140),lty=2)
dev.off()

group_name=c("Rural female","Rural male","Urban female","Urban male")
res_name=c("confidence measure","anxiety measure","desperate measure")
for (res_id in c(1,2,3))
{
  for (subgroup in c(1,2,3,4))
  {
    pdf(paste("SA",res_id,subgroup,"stack.pdf",sep="_"),width=8,height=4)
    par(mfrow=c(1,2))
    
    res=SA_att[[res_id]][,(subgroup-1)*3+c(1,2,3)]
    plot(r_grid,res[,1],ylim=range(res),type='o',xaxt='n',
         xlab="r",ylab="ATT",
         main=paste(group_name[subgroup],"ATT",sep=" ,"))
    axis(1,at=seq(-0.5,0.5,length=11),las=2)
    lines(r_grid,res[,2],lty=2)
    lines(r_grid,res[,3],lty=2)
    abline(h=0,lty=2)
    abline(v=0,lty=2)
    
    res=SA_prte[[res_id]][,(subgroup-1)*3+c(1,2,3)]
    plot(r_grid,res[,1],ylim=range(res),type='o',xaxt='n',
         xlab="r",ylab="PRTE",
         main=paste(group_name[subgroup],"PRTE",sep=" ,"))
    axis(1,at=seq(-0.5,0.5,length=11),las=2)
    lines(r_grid,res[,2],lty=2)
    lines(r_grid,res[,3],lty=2)
    abline(h=0,lty=2)
    abline(v=0,lty=2)
    
    
    
    dev.off()
  }
}

##Summary Simulation results
##Draw Figure 7 in the paper.
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

pdf("simu_result.pdf",width=8,height=4)
par(mfrow=c(1,2))
#pdf("Bias_simu.pdf",width=8,height=6)
plot(abs(h_grid),bias_2sls_compare-bias_liv2_compare,type='o',
     ylab="Advantage over absolute bias",
     xlab="h",lty=4)
lines(abs(h_grid),bias_ols_compare-bias_liv1_compare,type='o')
abline(h=0,lty=2)
legend("bottomright",legend=c("OLS-Local IV","2SLS-Local IV"),lty=c(1,4))
#dev.off()

#pdf("MSE_simu.pdf",width=8,height=6)
plot(abs(h_grid),mse_2sls_compare-mse_liv2_compare,type='o',
     ylab=expression("Advantage over RMSE"),
     xlab="h",lty=4)
lines(abs(h_grid),mse_ols_compare-mse_liv1_compare,type='o')
abline(h=0,lty=2)
legend("bottomright",legend=c("OLS-Local IV","2SLS-Local IV"),lty=c(1,4))
dev.off()

# plot(abs(h_grid),var_2sls_compare-var_liv2_compare,type='o',
#      ylab=expression("Advantage over"+sqrt(MSE)),
#      xlab="Heterogeneity degree,h",lty=4,main=expression(sqrt(MSE)+"comparison as heterogeneity increasing"))
# lines(abs(h_grid),var_ols_compare-var_liv1_compare,type='o')
# abline(h=0,lty=2)
# legend("bottomright",legend=c("OLS-LIV","2SLS-LIV"),lty=c(1,4))
# dev.off()

