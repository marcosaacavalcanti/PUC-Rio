## Guia de Estudo 07

## Questão 1
altura <- c(runif(25,1.5,1.8),runif(25,1.6,2.0))
sexof <- factor(c(rep("M",25),c(rep("H",25))))

# Essa questão é uma pegadinha... É claro que
# seria natural comparar as médias amostrais
# de cada um dos níveis dos fatores e analisar
# suas variâncias para determinar diferenças
# estatisticamente siginficativas. Contudo, não
# é necessário estimar nada, uma vez que já
# sabemos a que distribuicão os dados se
# comportam.
ve_dif <- (1.6+2.0)/2 - (1.5+1.8)/2

## Questão 2
max(tapply(altura,sexof,mean))-min(tapply(altura,sexof,mean))
# Note que é um valor próximo do valor esperado.


## Questão 3
sdavg <- function(amostra){
  sd(amostra)/sqrt(length(amostra))
}
tapply(altura,sexof,sdavg)


## Questão 4
altura <- c(runif(2,1.5,1.8),runif(2,1.6,2.0))
sexof <- factor(c(rep("M",2),c(rep("H",2))))

sdavg <- function(amostra){
  sd(amostra)/sqrt(length(amostra))
}
tapply(altura,sexof,sdavg)

max(tapply(altura,sexof,mean))-min(tapply(altura,sexof,mean))

# O desvio padrão da média das amostras deve ser
# maior, uma vez que estamos dividindo por
# sqrt(2) ao invés de sqrt(25). A diferença entre
# as médias deve parecer menos siginificativa
# também.