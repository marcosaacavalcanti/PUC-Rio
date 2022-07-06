### Guia de Estudo 05 ###


## Questão 1

{rep(5:2,each = 2) ; 2*3 ; rnorm(10)}
## um vetor de dez elementos distribuídos por uma normal padronizada.

{sqrt(2) ; x^2}
## Uma mensagem de erro, pois "x" não está na memória do R


## Questão 2

medpot <- function(v,n) mean(v^n)


## Questão 3

trimhist <- function(x,desvpad = 2) {
  xtrim <- x[x > mean(x)- desvpad*sd(x)]
  xtrim <- x[x < mean(x)+ desvpad*sd(x)]
  hist(xtrim, main = "Observações Centrais")
}


## Questão 4

acoef <- function(x){
  mean(x^3)
  acoef(rnorm(1000))
  acoef(rexp(1000,1))
}


## Questão 5

"%doido%" <- function(x,y) sqrt(x)/y^3