### Guia de Estudo 10 ###

## Quest�o 1
x <- runif(1000,1,20)
u <- rnorm(1000,sd = x)
y <- 15 + 2*x + u
reg <- lm(y~x)
uhat <- residuals(reg)

curtose <- function(amostra){
  mean(amostra^4)/(mean(amostra^2)^2)
}
curtose(uhat)

#Podemos notar a curtose dos res�duos deu uma valor acima de 3, que � a curtose
#de uma v.a. Normal. Portanto, tal distribui��o � leptoc�rtica, com caudas mais
#"pesadas", ou espessas.


## Quest�o 2
x <- 100
for(i in 2:1000){
  x[i] <- x[i-1]+rnorm(1)
}
y <- 100
for(i in 2:1000){
  y[i] <- y[i-1]+rnorm(1)
}
summary(lm(y~x))

#X e Y s�o constru��es independentes. O modelo � uma regress�o esp�ria, por se
#estar erroneamente regredindo um processo estoc�stico n�o-estacion�rio contra
#outro idem.


## Quest�o 3
x <- runif(1000,1,20)
u <- rnorm(1000,mean = x)
y <- 15 + 2 * x + u
uhat <- residuals(lm(y~x))

plot(uhat)       #Nuvem de pontos sem estrutura aparente
plot(x,uhat)     #Nenhuma correla��o vis�vel entre regressor e res�duos
hist(uhat)       #Distribui��o aparentemente normal
curtose(uhat)    #Pr�xima a 3 indica normalidade