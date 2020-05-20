#COPD_pneumonia_dryad data
df <- read.csv("C:/Users/akihi/Downloads/pneumocopd_analysis_dryad.csv")
#install packages
install.packages("rstan",
                 repos="https://cloud.r-project.org/",
                 dependence = TRUE)
pkgbuild::has_build_tools(debug = TRUE)
installed.packages("ggfortify")
#set up libraries
library(rstan)
library(ggfortify)
library(bayesplot)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())
#sample data
sample_size = nrow(df)
df_list <- list(age = df$age, N=sample_size)
mcmc_result <- stan(
  file = "sample_bayse.stan",
  data = df_list,
  seed=1,
  chains=4,
  iter = 2000,
  warmup = 1000,
  thin = 1
)
traceplot(mcmc_result, inc_warmup=T)
print(
  mcmc_result,
  probs = c(0.025, 0.5, 0.975)
)
mcmc_sample <- rstan::extract(mcmc_result, permuted = FALSE)
mu_mcmc_vec <- as.vector(mcmc_sample[,,"mu"])
autoplot(ts(mcmc_sample[,,"mu"]),
         facet = F,
         ylab = "mu",
         main = "Trace plot")
mcmc_hist(mcmc_sample, pars = c("mu", "sigma"))
mcmc_dens(mcmc_sample, pars = c("mu", "sigma"))
mcmc_combo(mcmc_sample, pars = c("mu", "sigma"))
#sample_regression
#association between steroid and hospitalization
#ax+b,σ
df_regression_list <- list(age = df$age, 
                           hospitalization = df$hospitalization,
                           N=sample_size)
mcmc_result <- stan(
  file = "sample_regression.stan",
  data = df_regression_list,
  seed=1,
  chains=4,
  iter = 2000,
  warmup = 1000,
  thin = 1
)
traceplot(mcmc_result, inc_warmup=T)
print(
  mcmc_result,
  probs = c(0.025, 0.5, 0.975)
)
#sample_logistic
#association between age and death
plot(df$age,df$death)
df_logistic_list <- list(age = df$age, 
                         death = df$death,
                         N=sample_size)
mcmc_result <- stan(
  file = "sample_logistic.stan",
  data = df_logistic_list,
  seed=1,
  chains=4,
  iter = 2000,
  warmup = 1000,
  thin = 1
)
traceplot(mcmc_result, inc_warmup=T)
print(
  mcmc_result,
  probs = c(0.025, 0.5, 0.975)
)
#sample_multiple
#association between age, respiratory rate and hospitalization
#omit NA
#confirm "class" before compiling
df <- na.omit(df)
sample_size = nrow(df)
df_multiple_list <- list(age = df$age, 
                         hr = df$hr,
                         hospitalization = df$hospitalization,
                         N=sample_size)
mcmc_result <- stan(
  file = "sample_multiple.stan",
  data = df_multiple_list,
  seed=1,
  chains=4,
  iter = 2000,
  warmup = 1000,
  thin = 1
)
traceplot(mcmc_result, inc_warmup=T)
print(
  mcmc_result,
  probs = c(0.025, 0.5, 0.975)
)
#hierarchial Beayse
#sample_hierarchial
#unique ID
df <- na.omit(df)
sample_size = nrow(df)
df$id = c(1:nrow(df)) #if some rows do have same id 
N_id = length(unique(df$id))
df_hierarchial_list <- list(s_id = df$id,
                            age = df$age, 
                            hospitalization = df$hospitalization,
                            N=sample_size,
                            N_id = N_id)
mcmc_result <- stan(
  file = "sample_hierarchial.stan",
  data = df_hierarchial_list,
  seed=1,
  chains=4,
  iter = 5000,
  warmup = 1000,
  thin = 1
)
traceplot(mcmc_result, inc_warmup=T)
print(
  mcmc_result,
  probs = c(0.025, 0.5, 0.975)
)