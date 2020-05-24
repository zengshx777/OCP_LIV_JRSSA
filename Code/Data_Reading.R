#This Script preprocess the data for subsequent analysis
#adult2010<-read.dta13("CFPS_2010_Adult_Clean_0714.dta")
load("../Data/CFPS_2010_Data.RData")
#read the data of instrument variable
ifppr<-read.table("../Data/IFPPR.txt",header=TRUE)
#Unify the name of province variable
ifppr$provcd_born=ifppr$provcd

#Extract Range
start=1979;end=2010;iend=140

#combine the data set
merge<-merge(adult2010,ifppr,by=c("provcd_born"))
#full_data<-subset(merge,ifppr>0&meduy>=0&feduy>=0&
  #                  age>=0&gender>=0&urban_3>=0)

#Extract the data within the range specified
data1<-subset(merge,age>=(2010-end)&age<=(2010-start)&ifppr<iend)
data1$mage_birth=data1$mage-data1$age
data1$fage_birth=data1$fage-data1$age
#Divide Data into 4 Subgroups by Hukou Status and Gender
data_00=subset(data1,urban_3==0&gender==0)
data_10=subset(data1,urban_3==1&gender==0)
data_01=subset(data1,urban_3==0&gender==1)
data_11=subset(data1,urban_3==1&gender==1)


#Codebook for Variable Name
#Notice that sampling weight (national combined weight) is included
#covariate_index<-c("meduy","feduy","age","han","rswt_nat")
covariate_index<-c("meduy","feduy","age","han","fincome","fage_birth","qb1",
                   "mage_birth","divorce","remarriage")
response_index<-c("qm404","qq603","qq604")
treatment_index<-"onechild"
instrument_index<-"ifppr"
cluster_index<-"provcd_born"

#Create a List to Combine Differ Data Set
data.combine<-list(data_00,data_01,data_10,data_11)
data.jags=data.combine

#Summary statistics
# dim(data_00)
# dim(data_01)
# dim(data_10)
# dim(data_11)
# sum(data_00$onechild)
# sum(data_01$onechild)
# sum(data_10$onechild)
# sum(data_11$onechild)

# apply(data1[,covariate_index],2,FUN=function(x){mean(x,na.rm = T
#                                                      )})
# apply(data1[,covariate_index],2,FUN=function(x){sd(x,na.rm = T)})
# apply(subset(data1,onechild==1)[,covariate_index],2,FUN=function(x){mean(x,na.rm = T
# )})
# apply(subset(data1,onechild==1)[,covariate_index],2,FUN=function(x){sd(x,na.rm = T
# )})
# apply(subset(data1,onechild==0)[,covariate_index],2,FUN=function(x){mean(x,na.rm = T
# )})
# apply(subset(data1,onechild==0)[,covariate_index],2,FUN=function(x){sd(x,na.rm = T
# )})

