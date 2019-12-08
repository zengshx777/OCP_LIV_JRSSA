#Produce Figure 5
library(ggplot2)
load("Figure5.RData")
par(mfrow=c(3,1), mar = c(2,4,1.5,0))

#Result by method*subgroup*measure*(est,low,up)
ols=as.vector(t(T_MATRIX[c(1,6,11,16),]))
match=as.vector(t(T_MATRIX[c(1,6,11,16)+1,]))
ipw=as.vector(t(T_MATRIX[c(1,6,11,16)+2,]))
dr=as.vector(t(T_MATRIX[c(1,6,11,16)+3,]))
iv=as.vector(t(T_MATRIX[c(1,6,11,16)+4,]))
tau=as.vector(t(TAU[,c(4,5,6)]))
values<-c(ols,iv,tau)
method=c(rep("OLS",36),rep("2SLS",36),rep("Bayesian LIV",36))
#Grid for X
xgrid=seq(1,7,length=3)
grid=c(rep(xgrid[1],each=36),rep(xgrid[2],each=36),
       rep(xgrid[3],each=36))
#Shape of Points
type=c(rep(c(6,1,2),12),rep(c(7,1,2),12),rep(c(8,1,2),12))
#Group to Draw Liness
pair=as.vector(t(cbind(seq(1,143,length=36),seq(2,144,length=36),
                     seq(2,144,length=36))))
#Measures
measure=rep(rep(c("Confidence","Anxiety","Desperation"),each=12),3)
#Subgroup
ruralgroup=rep(rep(c("Rural Female","Rural Male",
                     "Urban Female","Urban Male"),each=3),9)

#Transform into Data frame
df<- data.frame(
  Grid=grid,Values=values,type=as.factor(type),pairs=pair,
  measure=factor(measure,levels=c("Confidence","Anxiety","Desperation")),
  ruralgroup=factor(ruralgroup,levels=c("Rural Female","Rural Male",
                                        "Urban Female","Urban Male"))
)

p7<-ggplot(df, aes(x=Grid, y=Values,group=pairs)) + 
  # Add points, whose color and shape varies with the "variable" column
  geom_point(data=df,aes(shape=type),size=2, alpha=0.9) +
  geom_line(aes(x=Grid,y=Values),linetype="dashed")+
  scale_x_continuous(limits = c(0,8))+
  scale_shape_manual(values=c(32,32,1,9,12),
                     labels=c("","","OLS","2SLS","Bayesian LIV"))+
  # Provide breakpoints and respective labelings for the x-axis
 #scale_x_continuous(breaks=xgrid, labels=c("OLS","MATCH","IPW","DR","2SLS","BAYES"))+
  # Lay out plots in a grid fomat, with "measure" used as the vertical
  # facet group and "ruralgender" used as the horizontal facet group
  facet_grid(measure~ruralgroup) +
  # Add horizontal lines at 0
  geom_hline(aes(yintercept= 0), linetype="dotdash",alpha=0.5)+
  # Add labels. Note that to rename the legend, you have to rename both the
  # "shape" and the "color" variables.
  labs(title = "", x = "", y="",
       shape="") +
  # Choose a grayscale palette
  scale_color_grey() +
  # Remove the default grey background
  theme_bw() +
  # Customizations. Center plot title, and remove background lines
  theme(plot.title = element_text(hjust = 0.5),
        panel.spacing.x = unit(0, "lines"),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        legend.position="top",
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())


# 
pdf("OtherMethod.pdf",height = 6,width=8.5)
p7
dev.off()