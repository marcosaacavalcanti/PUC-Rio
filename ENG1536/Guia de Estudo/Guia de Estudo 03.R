### Guia de Estudo 3 ###


## Quest�o 1

## xlab e ylab


## Quest�o 2

## col = rgb(alfa,beta,gamma) ; no qual 0=< alfa,beta,gamma <= 1
## Exemplo: Pear color
hist(rnorm(1000),col = rgb(0.87,1.00,0.20))


## Quest�o 3

hist(rnorm(10000),breaks = 100)

lines(x,dnorm(x))


## Quest�o 4

hist(rnorm(1000),breaks = 4)
hist(rnorm(1000),breaks = 20)
hist(rnorm(1000),breaks = 50)
hist(rnorm(1000),breaks = 100)
hist(rnorm(1000),breaks = 1000)


## Quest�o 5

plot(ecdf(rnorm(50)))
x <- seq(-3,3,by = .1)
lines(x,pnorm(x))