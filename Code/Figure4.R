load("Figure4.RData")
pdf("Pos_PS_confidence.pdf",width=8,height = 6)
F1=ecdf(PS_pos_mean[[1]])
plot(F1,
     xlab = "Principal strata",
     ylab = "CDF",
     main = "Cumulative distribution function of imputed principal strata")
abline(v=c(0,140),lty=2)
F2=ecdf(PS_pos_mean[[2]])
lines(F2,col="red")
F3=ecdf(PS_pos_mean[[3]])
lines(F3,col="blue",cex=0.1)
F4=ecdf(PS_pos_mean[[4]])
lines(F4,col="orange",cex=0.1)
legend("topleft",lty=1,col=c("black","red","blue","orange"),
       legend=c("Rural females","Rural males","Urban females","Urban males"))
dev.off()



pdf("Pos_PS_confidence_rf.pdf",width=8,height=6)
F1=ecdf(PS_pos_mean[[1]])
plot(F1,
     xlab = "Principal strata",
     ylab = "CDF",
     main = "Cumulative distribution function of imputed principal strata")
abline(v=c(0,140),lty=2)
dev.off()



pdf("Pos_PS_anxiety.pdf",width=8,height = 6)
F1=ecdf(PS_pos_mean[[5]])
plot(F1,
     xlab = "Principal strata",
     ylab = "CDF",
     main = "Cumulative distribution function of imputed principal strata\n anxiety measure")
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
     ylab = "CDF",
     main = "Cumulative distribution function of imputed principal strata\n anxiety measure")
abline(v=c(0,140),lty=2)
dev.off()

pdf("Pos_PS_desperation.pdf",width=8,height = 6)
F1=ecdf(PS_pos_mean[[9]])
plot(F1,
     xlab = "Principal strata",
     ylab = "CDF",
     main = "Cumulative distribution function of imputed principal strata\n desperation measure")
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
     ylab = "CDF",
     main = "Cumulative distribution function of imputed principal strata\n desperation measure")
abline(v=c(0,140),lty=2)
dev.off()

