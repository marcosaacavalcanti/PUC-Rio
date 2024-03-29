### Guia de Estudo 08 ###

metodologia <- factor(sample(c("mA","mB","mC"),500,replace = T))
notas <- 0
for(i in 1:500){
  if(metodologia[i]=="mA"){
    notas[i] <- runif(1,4,8)
  }else{
    if(metodologia[i]=="mB"){
      notas[i] <- runif(1,5,9)
    }else{
      notas[i] <- runif(1,6,10)
    }
  }
}

## Quest�o 1
tapply(notas,metodologia,var)

## Quest�o 2
tapply(notas,metodologia,length)

## Quest�o 3
sigmafat <- tapply(notas,metodologia,var)   #C�lculo direto
n <- tapply(notas,metodologia,length) - 1
sqe <- sum(n*sigmafat)
sqt <- (length(notas)-1)*var(notas)
sqfat <- sqt - sqe

anova(lm(notas~metodologia))   #Simplesmente usando a fun��o ANOVA

#Sim! Valores id�nticos.


## Quest�o 4
#O n�mero de graus de liberdade do fator � dado
#pelo n�mero de n�veis, menos 1. J� o n�mero
#de graus de liberdade dos res�duos � dado
#pelo n�mero de graus de liberdade dos fatores,
#menos 1.
df_fat <- length(levels(metodologia)) - 1
df_e <- length(notas) - df_fat - 1


## Quest�o 5
mqfat <- sqfat / df_fat 
mqe <- sqe / df_e

anova(lm(notas~metodologia))
