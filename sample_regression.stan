data {
  int N;
  vector[N] age;
  vector[N] hospitalization;
}

parameters {
  real a;
  real b;
  real<lower=0> sigma;
}

model {
  for (i in 1:N){
    hospitalization[i] ~ normal(a * age[i], sigma);
  }
}
