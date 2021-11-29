## Guia de Estudo 08

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

## Questão 1
tapply(notas,metodologia,var)

## Questão 2
tapply(notas,metodologia,length)

## Questão 3
sigmafat <- tapply(notas,metodologia,var)   #Cálculo direto
n <- tapply(notas,metodologia,length) - 1
sqe <- sum(n*sigmafat)
sqt <- (length(notas)-1)*var(notas)
sqfat <- sqt - sqe

anova(lm(notas~metodologia))   #Simplesmente usando a função ANOVA

#Sim! Valores idênticos.


## Questão 4
#O número de graus de liberdade do fator é dado
#pelo número de níveis, menos 1. Já o número
#de graus de liberdade dos resíduos é dado
#pelo número de graus de liberdade dos fatores,
#menos 1.
df_fat <- length(levels(metodologia)) - 1
df_e <- length(notas) - df_fat - 1


## Questão 5
mqfat <- sqfat / df_fat 
mqe <- sqe / df_e

anova(lm(notas~metodologia))


