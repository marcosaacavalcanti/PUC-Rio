### Guia de Estudo 10 ###

## Questão 1
x <- runif(1000,1,20)
u <- rnorm(1000,sd = x)
y <- 15 + 2*x + u
reg <- lm(y~x)
uhat <- residuals(reg)

curtose <- function(amostra){
  mean(amostra^4)/(mean(amostra^2)^2)
}
curtose(uhat)

#Podemos notar a curtose dos resíduos deu uma valor acima de 3, que é a curtose
#de uma v.a. Normal. Portanto, tal distribuição é leptocúrtica, com caudas mais
#"pesadas", ou espessas.


## Questão 2
x <- 100
for(i in 2:1000){
  x[i] <- x[i-1]+rnorm(1)
}
y <- 100
for(i in 2:1000){
  y[i] <- y[i-1]+rnorm(1)
}
summary(lm(y~x))

#X e Y são construções independentes. O modelo é uma regressão espúria, por se
#estar erroneamente regredindo um processo estocástico não-estacionário contra
#outro idem.


## Questão 3
x <- runif(1000,1,20)
u <- rnorm(1000,mean = x)
y <- 15 + 2 * x + u
uhat <- residuals(lm(y~x))

plot(uhat)       #Nuvem de pontos sem estrutura aparente
plot(x,uhat)     #Nenhuma correlação visível entre regressor e resíduos
hist(uhat)       #Distribuição aparentemente normal
curtose(uhat)    #Próxima a 3 indica normalidade