### Guia de Estudo 07 ###

## Quest�o 1
altura <- c(runif(25,1.5,1.8),runif(25,1.6,2.0))
sexof <- factor(c(rep("M",25),c(rep("H",25))))

# Essa quest�o � uma pegadinha... � claro que
# seria natural comparar as m�dias amostrais
# de cada um dos n�veis dos fatores e analisar
# suas vari�ncias para determinar diferen�as
# estatisticamente siginficativas. Contudo, n�o
# � necess�rio estimar nada, uma vez que j�
# sabemos a que distribuic�o os dados se
# comportam.
ve_dif <- (1.6+2.0)/2 - (1.5+1.8)/2

## Quest�o 2
max(tapply(altura,sexof,mean))-min(tapply(altura,sexof,mean))
# Note que � um valor pr�ximo do valor esperado.


## Quest�o 3
sdavg <- function(amostra){
  sd(amostra)/sqrt(length(amostra))
}
tapply(altura,sexof,sdavg)


## Quest�o 4
altura <- c(runif(2,1.5,1.8),runif(2,1.6,2.0))
sexof <- factor(c(rep("M",2),c(rep("H",2))))

sdavg <- function(amostra){
  sd(amostra)/sqrt(length(amostra))
}
tapply(altura,sexof,sdavg)

max(tapply(altura,sexof,mean))-min(tapply(altura,sexof,mean))

# O desvio padr�o da m�dia das amostras deve ser
# maior, uma vez que estamos dividindo por
# sqrt(2) ao inv�s de sqrt(25). A diferen�a entre
# as m�dias deve parecer menos siginificativa
# tamb�m.