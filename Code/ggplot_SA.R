
sa_name=c("SA_confidence_ggplot.pdf","SA_anxiety_ggplot.pdf","SA_desperation_ggplot.pdf")
for (res_id in c(1:3)){
#Transform From List to Long Vector
Mean_value=Up_value=Low_value=NULL
for(k in 1:4)
{
  Mean_value=c(Mean_value,SA_att[[res_id]][,(k-1)*3+1],SA_prte[[res_id]][,(k-1)*3+1])
  Up_value=c(Up_value,SA_att[[res_id]][,(k-1)*3+2],SA_prte[[res_id]][,(k-1)*3+2])
  Low_value=c(Low_value,SA_att[[res_id]][,(k-1)*3+3],SA_prte[[res_id]][,(k-1)*3+3])
}

df <- data.frame(Grid=rep(r_grid,8),
                 TE = Mean_value,
                 TE_low = Low_value,
                 TE_up = Up_value,
                 ruralgender = rep(c("Rural Female", 
                                         "Rural Male", 
                                         "Urban Female", 
                                         "Urban Male"), each=18),
                 estimand = rep(rep(c("ATT", "PRTE"), each=9),4))


supple_figure<-ggplot(df, aes(Grid)) + 
  # Draw MTE lines, as well as the Confidence Interval
  geom_line(aes(y=TE),size=0.9,linetype="solid") +
  geom_line(aes(y=TE_up),size=0.9,linetype="dashed") +
  geom_line(aes(y=TE_low),size=0.9,linetype="dashed") +
  geom_point(aes(y=TE))+
  # Lay out plots in a grid fomat, with "measure" used as the vertical
  # facet group and "ruralgender" used as the horizontal facet group
  facet_grid(estimand~ruralgender) +
  # Add horizontal lines at 0
  geom_hline(yintercept=0, linetype="dotdash",alpha=0.5) +
  labs(title = "", x = "Sensitivity parameter", y="Effect size",
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
pdf(file = sa_name[res_id],height=5,width=10.5)
supple_figure
dev.off()
}


