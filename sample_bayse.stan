data {
  int N;
  vector[N] age;
}

parameters {
  real mu;
  real<lower=0> sigma;
}

model {
  for (i in 1:N){
    age[i] ~ normal(mu, sigma);
  }
}
