## Estudo de Caso 4


## Questão 1

aluna <- list(nome = "Mary",idade = 19, CR = 7.8,estrangeiro = TRUE)
aluna$nome
aluna$idade
aluna$CR
aluna$estrangeiro


## Questão 2

aluna$nome <- "Magdalene"


## Questão 3

dst <- c("Normal","Uniforme","Poisson")
rn <- c(rnorm(1),runif(1),rpois(1,2))
sorteios <- data.frame(distribuicao = dst,exemplo = rn)


## Questão 4

## detach()


## Questão 5

turma <- read.csv("turma.csv")
turma <- read.csv2("turma2.csv")


## Questão 6

## Supondo que o arquivo seja turmafw.txt
turma <- read.fwf("turma.csv",widths = c(15,2,4,5))

