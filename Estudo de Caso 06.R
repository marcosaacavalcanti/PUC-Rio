## Estudo de Caso 6

## Questão 1
faturamento <- 500000
desvio_padrao <- 50000
janela <- 3
vendas <- rnorm(60,mean = faturamento,sd = desvio_padrao)

mm <- c((vendas[1]+vendas[1+1]+vendas[1+2])/3)
for(i in c(length(vendas)-janela-1)){
  print(i)
  mm <- c(mm,c(vendas[i+2]+vendas[i+3]+vendas[i+4])/3)
}

##Questão 4



## Questão 5
idade <- readline(prompt = "Digite a sua idade: ")
if(idade<18){
  print("menor de idade")
}else{
  print("adulto")
}
