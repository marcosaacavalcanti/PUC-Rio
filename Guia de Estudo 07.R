## Estudo de Caso 7

sobrevida <- c(12.3,10.6,8.8,11.5,13.7,6.2,6.5,7.4)
tratamento <- c("M","M","P","M","M","P","P","P")

tratamentof <- factor(tratamento)

tapply(sobrevida,tratamentof,mean)


## Questão 1

altura <- c(runif(25,1.5,1.8),runif(25,1.6,2.0))
sexof <- factor(c(rep("F",25),rep("M",25)))


## Questão 2

tapply(altura,sexof,mean)


## Questão 3

tapply(altura,sexof,sd)


