## Estudo de Caso 6

## Questão 1
faturamento <- 500000
desvio_padrao <- 50000
n_vendas <- 60
janela <- 3
vendas <- rnorm(n_vendas,mean = faturamento,sd = desvio_padrao)

mm <- 0
for(i in 1:n_vendas-janela+1){
  c(mm,(vendas[i]+vendas[i+1]+vendas[i+2])/3)
}
mm <- mm[2:length(mm)]

##Questão 2
x0 <- 0
x1 <- 4
while(abs(x1 - x0 > 0.01)){
  x0 <- x1
  x1 <- x0 - (x0^2-x0-2)/(2*x0-1)
}

##Questão 3
# Sim. O comando "break". Veja o exemplo abaixo.
x <- 1
while(x<100){
  x <- x + 1
  if(x%%7== 0){
    break
  }
}

##Questão 4
z <- 2
rep(z,1)

## Questão 5
idade <- readline(prompt = "Digite a sua idade: ")
if(idade<18){
  print("menor de idade")
}else{
  print("adulto")
}
