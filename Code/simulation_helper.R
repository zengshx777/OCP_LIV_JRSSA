library(truncnorm)
library(MASS)
simulation_data<-function(c_1=-0.5,t1=0.3,t2=-0.5,varz=1,size=200)
{
  ###t2 control the heterogeneity
  ###t1 control the correlation between Y1,Y0
  ###
  #linear model parameter
  b_00=0
  b_01=1
  
  b_10=3
  b_11=2
  
  #first stage parameter
  c_0=0
  
  
  #heterogeneity:cov(n,v)
  #type 1 selection bias:cov(e,v)
  #type 2 selection bias
  #covariance matrix for e,n,v
  e1=1
  e2=1
  e3=1
  #e1,e2,e3 could be reflected the size of noise
  c_matrix<-rbind(c(e1,0,t1*(e1*e3)^.5),c(0,e2,t2*(e2*e3)^.5),c(t1*(e1*e3)^.5,t2*(e2*e3)^.5,e3))
  
  
  #data generating
  x<-rnorm(size,0,1)
  z<-rnorm(size,0,varz)
  
  
  error<-mvrnorm(n=size,mu=c(0,0,0),Sigma=c_matrix)
  e=error[,1]
  n=error[,2]
  v=error[,3]
  
  
  
  s=4*v+c_0+c_1*x
  t=rep(0,size)
  t[z>s]=1
  #t[d<=s]=0OO
  
  n=2*n
  y_0=b_00+b_01*x+e
  y_1=b_10+b_11*x+e+n
  
  
  y=y_0*(1-t)+y_1*t
  return (list(Y=y,X=cbind(1,x),Z=z,Tr=t,Y1=y_1,Y0=y_0,S=s))
}


Gibbs_LIV<-function(X,Y,Z,Tr,mcmc_n=1000)
{
  sample_size=length(Y)
  X_product=t(X)%*%X
  treated_unit=which(Tr==1)
  control_unit=which(Tr==0)
  #Initial Parameters
  #Parameter for Y~S
  gamma.s.1=rep(0,length=mcmc_n)
  gamma.s.0=rep(0,length=mcmc_n)
  #Parameter for Y~X
  beta.y.0=matrix(0,nrow=mcmc_n,ncol=ncol(X))
  beta.y.1=matrix(0,nrow=mcmc_n,ncol=ncol(X))
  #Parameter for S~X
  beta.s=matrix(0,nrow=mcmc_n,ncol=ncol(X))
  sigma.s=rep(1,length=mcmc_n)
  sigma.y=rep(1,length=mcmc_n)
  
  #Prior variance for parameter
  prior.sigma=100
  sigma.a=0.1;sigma.b=0.1
  #Individual Principal Strate.
  S=matrix(0,nrow=mcmc_n,ncol=sample_size)
  
  for (t in 2:mcmc_n){
    ##Sample PS
    prec.1=1/sigma.s[t-1]
    for (i in c(1:sample_size))
    {
      
      mean.1=X[i,]%*%beta.s[t-1,]
      if (Tr[i]==1)
      {
        prec.2=gamma.s.1[t-1]^2/sigma.y[t-1]
        mean.2=(Y[i]-X[i,]%*%beta.y.1[t-1,])*gamma.s.1[t-1]/sigma.y[t-1]
        S[t,i]=rtruncnorm(1,mean=(mean.1*prec.1+mean.2)/(prec.1+prec.2),
                          a=-Inf,b=Z[i],
                          sd=sqrt(1/(prec.1+prec.2)))
      }
      else
      {
        prec.2=gamma.s.0[t-1]^2/sigma.y[t-1]
        mean.2=(Y[i]-X[i,]%*%beta.y.0[t-1,])*gamma.s.0[t-1]/sigma.y[t-1]
        S[t,i]=rtruncnorm(1,mean=(mean.1*prec.1+mean.2)/(prec.1+prec.2),
                          a=Z[i],b=Inf,
                          sd=sqrt(1/(prec.1+prec.2)))
      }
      
      
    }
    
    ###Update gamma.s.0
    AUG_X=cbind(X,S[t,])
    AUG_X_1=AUG_X[treated_unit,]
    AUG_X_0=AUG_X[control_unit,]
    
    #Outcome Model Parameter
    Sigma_Y_0_inv=(t(AUG_X_0)%*%AUG_X_0)/sigma.y[t-1]+diag(rep(1,ncol(AUG_X_0)))/prior.sigma
    Mean_Y_0=t(AUG_X_0)%*%Y[control_unit]/sigma.y[t-1]
    Sigma_Y_0=solve(Sigma_Y_0_inv)
    Mean_Y_0=Sigma_Y_0%*%Mean_Y_0
    temp_0=mvrnorm(n=1,mu=Mean_Y_0,Sigma=Sigma_Y_0)
    gamma.s.0[t]=temp_0[3]
    beta.y.0[t,]=temp_0[1:2]
    
    Sigma_Y_1_inv=(t(AUG_X_1)%*%AUG_X_1)/sigma.y[t-1]+diag(rep(1,ncol(AUG_X_1)))/prior.sigma
    Mean_Y_1=t(AUG_X_1)%*%Y[treated_unit]/sigma.y[t-1]
    Sigma_Y_1=solve(Sigma_Y_1_inv)
    Mean_Y_1=Sigma_Y_1%*%Mean_Y_1
    temp_1=mvrnorm(n=1,mu=Mean_Y_1,Sigma=Sigma_Y_1)
    gamma.s.1[t]=temp_1[3]
    beta.y.1[t,]=temp_1[1:2]
    #Update PS Model beta.s
    Sigma_S=solve(X_product/sigma.s[t-1]+diag(rep(1,ncol(X)))/prior.sigma)
    Mean_S=Sigma_S%*%(t(X)%*%S[t,]/sigma.s[t-1])
    beta.s[t,]=mvrnorm(n=1,mu=Mean_S,Sigma=Sigma_S)
    
    #Update Precision Parameter for outcome
    SSE=sum((Y[treated_unit]-AUG_X_1%*%temp_1)^2)+sum((Y[control_unit]-AUG_X_0%*%temp_0)^2)
    sigma.y[t]=1/rgamma(1,shape=sample_size/2+sigma.a,rate=SSE/2+sigma.b)
    
    #Update Precision Parameter for Ps
    SSE=sum((S[t,]-X%*%beta.s[t,])^2)
    sigma.s[t]=1/rgamma(1,shape=sample_size/2+sigma.a,rate=SSE/2+sigma.b)
    
    # if(t%%(mcmc_n/100)==0)
    # {
    #   print(paste(t*100/mcmc_n,"% finished"))
    # }
  }
  
  post_index=((4*mcmc_n/5)+1):mcmc_n
  att_post=unlist(lapply(post_index,FUN=function(i){
    return ((gamma.s.1[i]-gamma.s.0[i])*mean(S[i,treated_unit])+(beta.y.1[i,]-beta.y.0[i,])%*%
              apply(X[treated_unit,],2,mean))}))
  prte_post=unlist(lapply(post_index,FUN=function(i){
    c_index=which(S[i,]>=min(Z)&S[i,]<=max(Z))
    return ((gamma.s.1[i]-gamma.s.0[i])*mean(S[i,c_index])+(beta.y.1[i,]-beta.y.0[i,])%*%
              apply(X[c_index,],2,mean))}))
  
  return (list(ATT=att_post,PRTE=prte_post,
               gamma.s.1=gamma.s.1[post_index],
               gamma.s.0=gamma.s.0[post_index],
               beta.y.1=beta.y.1[post_index,],
               beta.y.0=beta.y.0[post_index,],
               beta.s=beta.s[post_index],
               S=S[post_index,]))
  
}