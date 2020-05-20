data {
  int N;
  real hospitalization[N];
  real age[N];
  real hr[N];
}

parameters {
  real a;
  real b;
  real c;
  real<lower=0> sigma;
}

model {
  real mu;
  for (i in 1:N){
    mu = a * age[i] + b * hr[i] + c;
    hospitalization[i] ~ normal(mu, sigma);
  }
}
