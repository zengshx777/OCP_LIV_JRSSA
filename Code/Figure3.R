#Produce Figure 3 in the paper.
load("Figure3.RData")

library(ggplot2)
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
  scale_shape_manual(values=c(16,15,32))+
  # Provide breakpoints and respective labelings for the x-axis
  scale_x_continuous(breaks=c(1.15,2.15,3.15,4.15), labels=c("Rural_F", "Rural_M", "Urban_F","Urban_M")) +
  # Lay out plots in a grid fomat, with "measure" used as the vertical
  # facet group and "ruralgender" used as the horizontal facet group
  facet_grid(~measure.f,scale="free",labeller = label_parsed) +
  # Add horizontal lines at 0
  geom_hline(aes(yintercept= 0), linetype="dotdash")+
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
        panel.spacing.x = unit(1, "lines"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        legend.position="none")


pdf("overalleffects.pdf", width = 8.5, height = 3)
p5
dev.off()