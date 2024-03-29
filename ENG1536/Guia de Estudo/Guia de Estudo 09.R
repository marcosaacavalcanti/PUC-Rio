### Guia de Estudo 09 ###

## Quest�o 1
x1 <- rnorm(25,2,5)
x2 <- rnorm(25,-1,5)
u <- rnorm(25,sd = 2)
y <- 100 + 1.5 * x1 + u

#(n-p) = n�mero de graus de liberdade 
n <- length(x1)    #n:tamanho da amostra
p <- 3             #p:n�mero par�metros do modelo. Nesse caso:beta(i), i = 0,1,2

reg <- lm(y~x1+x2)
summary(reg)

t <- betahat_2 / stderror_2
p_value <- 2*(1-pt(t,n-p))


## Quest�o 2
y <- 100 + 1.5 * x1 - 3 * x2 + u
plot(x2,y)
cor(x2,y)
reg <- lm(y~x1+x2)
summary(reg)


## Quest�o 3
x <- rnorm(25)
y <- x^2
cor(x,y)
plot(x,y)
summary(lm(y~x))

#O modelo de regress�o linear implica em uma rela��o
#linear entre as vari�veis independentes, ou 
#regressoras, e a vari�vel dependente. Nesse caso,
#o modelo linear n�o � adequado.


## Quest�o 4
x <- faithful$waiting
y <- faithful$eruptions
plot(x,y)
cor(x,y)
reg <- lm(y~x)
summary(lm(y~x))