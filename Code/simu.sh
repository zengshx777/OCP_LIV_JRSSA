R CMD BATCH --vanilla '--args h=0 mcmc.time=5000 simu_time=1000' simulation_main.R main_1.out &
R CMD BATCH --vanilla '--args h=0.1 mcmc.time=5000 simu_time=1000' simulation_main.R main_2.out &
R CMD BATCH --vanilla '--args h=0.2 mcmc.time=5000 simu_time=1000' simulation_main.R main_3.out &
R CMD BATCH --vanilla '--args h=0.3 mcmc.time=5000 simu_time=1000' simulation_main.R main_4.out &
R CMD BATCH --vanilla '--args h=0.4 mcmc.time=5000 simu_time=1000' simulation_main.R main_5.out &
R CMD BATCH --vanilla '--args h=0.5 mcmc.time=5000 simu_time=1000' simulation_main.R main_6.out &
R CMD BATCH --vanilla '--args h=0.6 mcmc.time=5000 simu_time=1000' simulation_main.R main_7.out &
R CMD BATCH --vanilla '--args h=0.7 mcmc.time=5000 simu_time=1000' simulation_main.R main_8.out &
R CMD BATCH --vanilla '--args h=0.8 mcmc.time=5000 simu_time=1000' simulation_main.R main_9.out &
R CMD BATCH --vanilla '--args h=0.9 mcmc.time=5000 simu_time=1000' simulation_main.R main_10.out &
