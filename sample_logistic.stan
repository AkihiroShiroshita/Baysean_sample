data {
  int N;
  int<lower=0, upper=1> death[N];
  real age[N];
}

parameters {
  real a;
  real b;
}

model {
  for (i in 1:N){
    death[i] ~ bernoulli_logit(a * age[i] + b);
  }
}
