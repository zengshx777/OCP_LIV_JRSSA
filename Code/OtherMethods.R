source("Data_Reading.R")
library(Matching)
library(ordinal)
library(AER)

#Other Methods Comparison
source("OtherMethods_Fun.R")


for (res in 1:3)
{
  source("Data_Loading.R") 
  for (i in 1:4)
{
temp.data<-data.jags[[i]]
temp.data$y<-as.factor(temp.data[,response_index[res]])
temp.data$group<-as.factor(temp.data$rd.ind)
ylevel=length(unique(temp.data$y))

#ATT Estimation
tryCatch({
#Direct Modeling (Ordinal Probit)
#Outcome Formula
out.formula=as.formula("y~meduy+feduy+age+onechild+han+fincome+mage_birth+fage_birth+divorce+remarriage+qb1+onechild*meduy+
                   onechild*feduy+onechild*age+onechild*han")

model_dir<-clmm2(out.formula,random=group,
                 data=temp.data,link="logistic",
                 control=clmm2.control(method="nlminb"))


#IPW
#Fitted First Stage Modeling
first_stage<-glm(onechild~age+meduy+feduy+han,family = binomial(link = "probit"),data=temp.data)
temp.data$p<-fitted(first_stage,type="response")

#Get the Point Estimation of OLS, IPW and Double Robust
REG_IPW_Result<-Fit_Boot_method(temp.data,res,B=250,model=model_dir,choice_model=first_stage,ylevel)


#Point Estimation
Est_result<-c(REG_IPW_Result$reg.est,
              REG_IPW_Result$match.est,
              REG_IPW_Result$ipw.est,
              REG_IPW_Result$dr.est,
              REG_IPW_Result$iv.est)

#Standard Deviation
Se_result<-c(sd(REG_IPW_Result$b_reg,na.rm=T),
             sd(REG_IPW_Result$b_matching,na.rm=T),
             sd(REG_IPW_Result$b_ipw,na.rm=T),
             sd(REG_IPW_Result$b_dr,na.rm=T),
             sd(REG_IPW_Result$b_iv,na.rm=T))

#Upper Credible Interval
UCI_result<-c(quantile(REG_IPW_Result$b_reg,0.975,na.rm=T),
              quantile(REG_IPW_Result$b_matching,0.975,na.rm=T),
              quantile(REG_IPW_Result$b_ipw,0.975,na.rm=T),
              quantile(REG_IPW_Result$b_dr,0.975,na.rm=T),
              quantile(REG_IPW_Result$b_iv,0.975,na.rm=T)) 

#Lower Credible Interval
LCI_result<-c(quantile(REG_IPW_Result$b_reg,0.025,na.rm=T),
              quantile(REG_IPW_Result$b_matching,0.025,na.rm=T),
              quantile(REG_IPW_Result$b_ipw,0.025,na.rm=T),
              quantile(REG_IPW_Result$b_dr,0.025,na.rm=T),
              quantile(REG_IPW_Result$b_iv,0.025,na.rm=T)) 
},
error=function(e){
  print("==ERROR OCCUR==")
  Est_result<-rep(NA,5);Se_result<-rep(NA,5)
  LCI_result<-rep(NA,5);UCI_result<-rep(NA,5)
})
#Store Values
print(paste("==",res,"==",i,"==",seq=""))
assign(paste(response_index[res],i,"Estimation",seq="_"),Est_result)
assign(paste(response_index[res],i,"SE",seq="_"),Se_result)
assign(paste(response_index[res],i,"UCI",seq="_"),UCI_result)
assign(paste(response_index[res],i,"LCI",seq="_"),LCI_result)
assign(paste(response_index[res],i,"Bootsample",seq="_"),REG_IPW_Result)
}
}

#Result Extraction to Produce Table 6
T_MATRIX<-NULL
for (i in 1:4)
{
  R_MATRIX<-NULL
  for(res in c(7,3,4))
  {
    R_MATRIX<-cbind(R_MATRIX,
    t(rbind(get(paste(response_index[res],i,"Estimation",seq="_")),
            get(paste(response_index[res],i,"LCI",seq="_")),
            get(paste(response_index[res],i,"UCI",seq="_")))))
  }
  row.names(R_MATRIX)=c("OLS","Matching","IPW","Double Robust","2SLS")
  T_MATRIX<-rbind(T_MATRIX,R_MATRIX)
}

#####Miranda (2006) Selection Method, not include in the paper
# library(sampleSelection)
# 
# collected=NULL
# for (res in 1:3)
# {
#   source("Data_Loading.R") 
#   for (i in 1:4)
#   {
#     temp.data<-data.jags[[i]]
#     temp.data$y<-as.factor(temp.data[,response_index[res]])
#     temp.data$group<-as.factor(temp.data$rd.ind)
#     ylevel=length(unique(temp.data$y))
#     if(res==1){
#       model=summary(selection(onechild~meduy+ifppr+feduy+age+han,
#                               factor(qm404)~onechild+meduy+feduy+age+han,
#                               boundaries = c(0.5,1.5,2.5,3.5,4.5,5.5),
#                               type=2,
#                               temp.data))
#     }
#     else if(res==2){
#       model=summary(selection(onechild~meduy+ifppr+feduy+age+han,
#                               factor(qq603)~onechild+meduy+feduy+age+han,
#                               boundaries = c(0.5,1.5,2.5,3.5,4.5,5.5),
#                               type=2,
#                               temp.data))
#     }else{
#       model=summary(selection(onechild~meduy+ifppr+feduy+age+han,
#                               factor(qq604)~onechild+meduy+feduy+age+han,
#                               boundaries = c(0.5,1.5,2.5,3.5,4.5,5.5),
#                               type=2,
#                               temp.data))
#       
#     }
#     
#     
#     est=model$estimate['onechild',c(1,2)]
#     collected=rbind(collected,c(est[1],est[1]+1.96*est[2],est[1]-1.96*est[2]))
#   }
# }
#save(mle_iv,T_MATRIX,file="Figure5RData")