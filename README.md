# LadinoBot

[![Package version](https://img.shields.io/github/release/landim32/LadinoBot.svg?style=flat-square)](https://github.com/landim32/LadinoBot/releases)
[![Open Source Love png2](https://badges.frapsoft.com/os/v2/open-source.png?v=103)](https://github.com/landim32/LadinoBot/)
[![GitHub license](https://img.shields.io/github/license/landim32/LadinoBot.svg)](https://github.com/landim32/LadinoBot/blob/master/LICENSE)

[![GitHub stars](https://img.shields.io/github/stars/landim32/LadinoBot.svg?style=social)](https://github.com/landim32/LadinoBot/stargazers)
[![GitHub watchers](https://img.shields.io/github/watchers/landim32/LadinoBot.svg?style=social)](https://github.com/landim32/LadinoBot/watchers)
[![GitHub issues](https://img.shields.io/github/issues/landim32/LadinoBot.svg?style=social)](https://github.com/landim32/LadinoBot/issues)
[![GitHub pulls](https://img.shields.io/github/issues-pr/landim32/LadinoBot.svg?style=social)](https://github.com/landim32/LadinoBot/pulls)
![GitHub forks](https://img.shields.io/github/forks/landim32/LadinoBot.svg?style=social)

**LadinoBot** é um **Expert Advisor** (Robô) para **Metatrader 5**. 
Com ele você pode ter uma ferramenta trabalhando para você. O robô funciona com várias estratégias, podendo 
combinar tempos gráficos diferentes. Objetivos diferentes podem ser usados, e as estratégias de saída da 
operação podem ser modificadas de acordo com a evolução dos objetivos.

## Downloads

- [Baixe aqui LadinoBot 1.02](./Archives/LadinoBot-1.02.zip)

## Vídeo

Segue abaixo um vídeo com as operações de Janeiro de 2020, onde foi obtido um **lucro de R$ 2.435** com a negociação de **10 mini-contratos**. 
[![Watch the video](https://img.youtube.com/vi/HtU_yZhYQls/maxresdefault.jpg)](https://youtu.be/HtU_yZhYQls)

## Paramêtros

### Horários de funcionamento

- **Start Time** - Data de início das operações;
- **Closing Time** - A partir dessa hora, não inicia novas operações. As operações abertas continuaram abertas.
- **Exit Time** - Todas as operações que ainda se encontram em aberto serão finalizadas a preço de mercado;

### Operacional Básico

- **Operation type** - Tipo de operações suportadas. As opções disponíveis são:
    * **Buy and Sell** - O robô opera tanto comprado como vendido;
    * **Only Buy** - Opera apenas comprado;
    * **Only Sell** - Opera apenas vendido;
- **Asset type** - Tipo de ativo a ser negociado. Esse campo irá influenciar o valor da corretagem a ser contabilizado. Segue abaixo as opções:
    * **Indice** - A corretagem será cobrada por contrato negociado;
    * **Stock** - A corretagem será cobrada por negociação, independente do volume negociado;
- **Risk Managment** - Gerenciamento de risco modificado. As opções são:
    * **Normal** - Risco normal, nada de diferente;
    * **Progressive** - No risco progressivo, o robô usa lucro conseguido para aumentar o Stop Loss;
- **Input Condition** - Condição para a entrada na Operação:
    * **HiLo/MM T1 (Tick)** - Quando o candle cruza a média móvel no tempo gráfico principal T1, não aguardando o fechamento do candle;
    * **HiLo/MM T2 (Tick)** - Quando o candle cruza a média móvel no tempo gráfico T2, não aguardando o fechamento do candle;
    * **HiLo/MM T3 (Tick)** - Quando o candle cruza a média móvel no tempo gráfico T3, não aguardando o fechamento do candle;
    * **HiLo/MM T1 (Close)** - Quando o candle cruza a média móvel no tempo gráfico principal T1, executa quando o candle fechar;
    * **HiLo/MM T2 (Close)** - Quando o candle cruza a média móvel no tempo gráfico T2, executa quando o candle fechar;
    * **HiLo/MM T3 (Close)** - Quando o candle cruza a média móvel no tempo gráfico T3, executa quando o candle fechar;
    * **Only Trend T1** - Ativa quando o tempo gráfico principal T1 apresenta topos e fundos acendentes;
- **Value per point** - Valor financeiro por ponto ganho ou perdido;
    
### Financeiro
- **Brokerage value** - Valor da taxa de corretagem. A forma de contabilizar depende da opção **Asset Type**;
- **Daily Max Gain** - Máximo de ganho financeiro diário. Ao atinguir o limite, o sistema fecha para novas operações;
- **Daily Max Loss** - Máximo de perda financeira diária. Ao atinguir o limite, o sistema fecha para novas operações;
- **Operation Max Gain** - Ao atinguir o limite financeiro, a operação é finalizada;

### Gráfico T1 (Gráfico Principal)
- **T1 Use Trendline** - Cria uma linha de tendência e só inicia a operação for rompida;
- **T1 Trendline Extra** - Valor extra na linha de tendência;
- **T1 Support and Resistance** - Só inicia a operação quando o gráfico T1 apresenta topos e fundos acendentes / descendentes;
- **T1 HiLo Periods** - Quantidade de períodos a serem usados no HiLo;
- **T1 HiLo set Trend** - O HiLo no gráfico T1 define a tendência. Só abre a operação caso o HiLo esteja a favor da operação;
- **T1 Moving Averange** - Quantidade de períodos usandos na Média Móvel;

### Gráfico T2 (Gráfico Secundário)
- **T2 Graph Extra** - Usa o gráfico secundário T2;
- **T2 Graph Time** - Período de tempo usado no gráfico T2;
- **T2 Support and Resistance** - Só inicia a operação quando o gráfico T2 apresenta topos e fundos acendentes / descendentes;
- **T2 HiLo Periods** - Quantidade de períodos a serem usados no HiLo;
- **T2 HiLo set Trend** - O HiLo no gráfico T2 define a tendência. Só abre a operação caso o HiLo esteja a favor da operação;
- **T2 Moving Averange** - Quantidade de períodos usandos na Média Móvel;

### Gráfico T3 (Gráfico Terciário)
- **T3 Graph Extra** - Usa o gráfico secundário T3;
- **T3 Graph Time** - Período de tempo usado no gráfico T3;
- **T3 Support and Resistance** - Só inicia a operação quando o gráfico T3 apresenta topos e fundos acendentes / descendentes;
- **T3 HiLo Periods** - Quantidade de períodos a serem usados no HiLo;
- **T3 HiLo set Trend** - O HiLo no gráfico T3 define a tendência. Só abre a operação caso o HiLo esteja a favor da operação;
- **T3 Moving Averange** - Quantidade de períodos usandos na Média Móvel;

### Opções de Stop Loss
- **Stop Loss Min** - Diferença de pontos mínima entre o preço de entrada na operação e o Stop Loss;
- **Stop Loss Max** - Diferença de pontos máxima entre o preço de entrada na operação e o Stop Loss. Se **Force entry** estiver ativo, o Stop Loss será reduzido ao valor do **Stop Loss Max**, caso contrário, a operação não será realizada.
- **Stop Extra** - Valor adicional de pontos ao Stop Loss;
- **Stop Initial** - Esse é o modelo de Stop Loss usado na abertura da operação. Os tipos de Stop Loss são válidos para os gráficos T1, T2 ou T3 e são:
    * **Stop Fixed** - O valor do Stop Loss é um valor fixo, baseado no campo **Stop fixed value**;
    * **HiLo** - O Stop Loss fica inicialmente na posição do HiLo e vai acompanhando o preço conforma a mudança;
    * **Top/Bottom** - O Stop Loss sobe/desce de acordo com o surgimento de um novo topo ou fundo;
    * **Pior Candle** - O Stop Loss sobe/desce se posicionando abaixo/acima do candle anterior;
    * **Current Candle** - O Stop Loss sobe/desce se posicionando abaixo/acima do candle atual;
- **Stop fixed value** - Valor fixo do Stop Loss. O <strong>Stop Initial</strong> deve estar marcada como **Stop Fixed**;
- **Force entry** - Se estiver ativo, a operação será inicializada ajustando o valor do Stop Loss para o **Stop Loss Max**. Caso não esteja ativo, só inicializará a operação se o valor do Stop Loss estiver dentro do limite do **Stop Loss Max**;

### Aumento de posição
- **Run Position Increase** - Usa o aumento de posição. Ao atinguir um novo objetivo, caso o volume seja maior que zero a posição será aumentada;
- **Run Position Stop Extra** - Valor extra do Stop Loss usado apenas para o aumento da posição;
- **Run Position Increase Minimal** - Valor mínimo que o preço precisa se movimentar para permitir uma nova entrada;

### Opções de Break Even
- **Break Even Position** - Posição onde o Break Even move o Stop Loss para a posição de preço de entrada na operação + **Break Even Value**;
- **Break Even Value** - Preço de entrada na operação + esse campo para mover o Stop Loss;
- **Break Even Volume** - Volume à ser realizado quando o Break Even é atingido. Quando for negativo vai realizar a posição, quando for positivo vai aumentar a posição;

### Opções de Volume
- **Initial Volume** - Volume inicial da operação;
- **Max Volume** - Maximum volume of the operation. If the Run Position Increase is enabled, the volume may not pass this value;

### Objetivo 1
- **Goal 1 Condition** - Condição para atingir o objetivo 1. Veja as opções em **Input Condition**;
- **Goal 1 Volume** - Volume à ser realizado quando o Objetivo 1 é atingido. Quando for negativo vai realizar a posição, quando for positivo vai aumentar a posição;
- **Goal 1 Position** - Valor fixo para se atingir o objetivo 1. O **Goal 1 Condition** deve estar marcada como **Fixed Position**;
- **Goal 1 Stop** - Esse é o modelo de Stop Loss usado a partir do momento que atingir o objetivo 1. Veja mais detalhes nos campo **Stop Inicial**;

### Objetivo 2
- **Goal 2 Condition** - Condição para atingir o objetivo 2. Veja as opções em **Input Condition**;
- **Goal 2 Volume** - Volume à ser realizado quando o objetivo 2 é atingido. Quando for negativo vai realizar a posição, quando for positivo vai aumentar a posição;
- **Goal 2 Position** - Valor fixo para se atingir o objetivo 2. O **Goal 2 Condition** deve estar marcada como **Fixed Position**;
- **Goal 2 Stop** - Esse é o modelo de Stop Loss usado a partir do momento que atingir o objetivo 2. Veja mais detalhes nos campo **Stop Inicial**;

### Objetivo 3
- **Goal 3 Condition** - Condição para atingir o objetivo 3. Veja as opções em **Input Condition**;
- **Goal 3 Volume** - Volume à ser realizado quando o objetivo 3 é atingido. Quando for negativo vai realizar a posição, quando for positivo vai aumentar a posição;
- **Goal 3 Position** - Valor fixo para se atingir o objetivo 3. O <strong>Goal 3 Condition</strong> deve estar marcada como **Fixed Position**;
- **Goal 3 Stop** - Esse é o modelo de Stop Loss usado a partir do momento que atingir o objetivo 3. Veja mais detalhes nos campo **Stop Inicial**;

## Histórico de lançamentos

* 1.02
    * Configuração inicial revisada e funcionando
* 1.01
    * Versão inicial com código organizado e objetos não utilizandos removidos
* 1.00
    * Versão inicial

## Meta

Rodrigo Landim – [@Landim32Oficial](https://twitter.com/landim32oficial) – rodrigo@emagine.com.br

Distribuído sob a licença GPLv2. Veja `LICENSE` para mais informações.

[https://github.com/landim32/LadinoBot](https://github.com/landim32/LadinoBot)

## Contributing

1. Faça o _fork_ do projeto (<https://github.com/landim32/LadinoBot/fork>)
2. Crie uma _branch_ para sua modificação (`git checkout -b landim32/LadinoBot`)
3. Faça o _commit_ (`git commit -am 'Add some fooBar'`)
4. Push_ (`git push origin landim32/LadinoBot`)
5. Crie um novo _Pull Request_

## Donations

1. BTC: 18muAc1ktnJRbucfru4fkcgCwUNcTEbnJG



 
