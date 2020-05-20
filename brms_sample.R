library(rstan)
library(ggfortify)
library(bayesplot)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())
df <- read.csv("C:/Users/akihi/Downloads/pneumocopd_analysis_dryad.csv")
df <- na.omit(df)
head(df)
#design matrix
formula <- formula(hospitalization ~ age + hr)
X <- model.matrix(formula, df)
N <- nrow(df)
#explanatory variables + 1
K <- 3
Y <- df$hospitalization
data_list_design <- list(N=N, K=K, Y=Y, X=X)
MCMC_result_design <- stan(
  file = "design_matrix.stan",
  data = data_list_design,
  seed =1
)
traceplot(MCMC_result_design, inc_warmup=T)
print(
  MCMC_result_design,
  probs = c(0.025, 0.5, 0.975)
)
#brms
library(brms)
lm <- brm(
  formula = hospitalization ~ age + hr,
  family = gaussian(link="identity"),
  data = df,
  seed = 1,
  prior = c(set_prior("", class = "Intercept"),
            set_prior("", class = "Sigma")), #set_prior("normal(0,100000)", class = "b", coef = "name")
  chains = 4,
  iter = 2000,
  warmup = 1000,
  thin =1
  )
lm
as.mcmc(lm, combine_chains = TRUE)
plot(lm)
new_data <- data.frame(age = 70, hr = 100)
#mean (not median)
fitted(lm, new_data)
predict(lm, new_data)
#95% credible interval
eff <- marginal_effects(lm)
plot(eff, points = TRUE)
#95% prediction interval
set.seed(1)
eff_pred <- marginal_effects(lm, methos = "predict")
plot(eff_pred, points = TRUE)
#variance analaysis
df$hospital <- as.character(df$hospital)
anova <- brm(
  formula = hospitalization ~ hospital,
  family = gaussian(),
  data = df,
  seed = 1
)
anova
eff <- marginal_effects(anova)
plot(eff, points = FALSE)
