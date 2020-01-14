<h2>Parametros</h2>
<h4>Horários de funcionamento</h4>
<ul>
    <li><strong>Start Time</strong> - Data de início das operações;</li>
    <li><strong>Closing Time</strong> - A partir dessa hora, não inicia novas operações. As operações abertas continuaram abertas.</li>
    <li><strong>Exit Time</strong> - Todas as operações que ainda se encontram em aberto serão finalizadas a preço de mercado;</li>
</ul>
<h4 id="operacional-basico">Operacional Básico</h4>
<ul>
    <li>
        <strong>Operation type</strong> - Tipo de operações suportadas. As opções disponíveis são:
        <ol>    
            <li><strong>Buy and Sell</strong> - O robô opera tanto comprado como vendido;</li>
            <li><strong>Only Buy</strong> - Opera apenas comprado;</li>
            <li><strong>Only Sell</strong> - Opera apenas vendido;</li>
        </ol>
    </li>
    <li>
        <strong>Asset type</strong> - Tipo de ativo a ser negociado. Esse campo irá influenciar o valor da 
        corretagem a ser contabilizado. Segue abaixo as opções:
        <ol>    
            <li><strong>Indice</strong> - A corretagem será cobrada por contrato negociado;</li>
            <li><strong>Stock</strong> - A corretagem será cobrada por negociação, independente do volume negociado;</li>
        </ol>
    </li>
    <li>
        <strong>Risk Managment</strong> - Gerenciamento de risco modificado. As opções são:
        <ol>    
            <li><strong>Normal</strong> - Risco normal, nada de diferente;</li>
            <li><strong>Progressive</strong> - No risco progressivo, o robô usa lucro conseguido para aumentar o Stop Loss;</li>
        </ol>
    </li>
    <li id="input-condition">
        <strong>Input Condition</strong> - Condição para a entrada na Operação:
        <ol>    
            <li><strong>HiLo/MM T1 (Tick)</strong> - Quando o candle cruza a média móvel no tempo gráfico principal T1, não aguardando o fechamento do candle;</li>
            <li><strong>HiLo/MM T2 (Tick)</strong> - Quando o candle cruza a média móvel no tempo gráfico T2, não aguardando o fechamento do candle;</li>
            <li><strong>HiLo/MM T3 (Tick)</strong> - Quando o candle cruza a média móvel no tempo gráfico T3, não aguardando o fechamento do candle;</li>
            <li><strong>HiLo/MM T1 (Close)</strong> - Quando o candle cruza a média móvel no tempo gráfico principal T1, executa quando o candle fechar;</li>
            <li><strong>HiLo/MM T2 (Close)</strong> - Quando o candle cruza a média móvel no tempo gráfico T2, executa quando o candle fechar;</li>
            <li><strong>HiLo/MM T3 (Close)</strong> - Quando o candle cruza a média móvel no tempo gráfico T3, executa quando o candle fechar;</li>
            <li><strong>Only Trend T1</strong> - Ativa quando o tempo gráfico principal T1 apresenta topos e fundos acendentes;</li>
            <li><strong>Only Trend T2</strong> - Ativa quando o tempo gráfico T2 apresenta topos e fundos acendentes;</li>
            <li><strong>Only Trend T3</strong> - Ativa quando o tempo gráfico T3 apresenta topos e fundos acendentes;</li>
        </ol>
    </li>
    <li>
        <strong>Value per point</strong> - Valor financeiro por ponto ganho ou perdido;
    </li>
</ul>
<h4>Financeiro</h4>
<ul>
    <li>
        <strong>Brokerage value</strong> - Valor da taxa de corretagem. A forma de contabilizar depende da opção <strong>Asset Type</strong>;
    </li>
    <li>
        <strong>Daily Max Gain</strong> - Máximo de ganho financeiro diário. 
        Ao atinguir o limite, o sistema fecha para novas operações;
    </li>
    <li>
        <strong>Daily Max Loss</strong> - Máximo de perda financeira diária. 
        Ao atinguir o limite, o sistema fecha para novas operações;
    </li>
    <li>
        <strong>Operation Max Gain</strong> - Ao atinguir o limite financeiro, a operação é finalizada;
    </li>
</ul>
<h4>Gráfico T1 (Gráfico Principal)</h4>
<ul>
    <li>
        <strong>T1 Use Trendline</strong> - Cria uma linha de tendência e só inicia a operação for rompida;
    </li>
    <li>
        <strong>T1 Trendline Extra</strong> - Valor extra na linha de tendência;
    </li>
    <li>
        <strong>T1 Support and Resistance</strong> - Só inicia a operação quando o gráfico T1 apresenta 
        topos e fundos acendentes / descendentes;
    </li>
    <li>
        <strong>T1 HiLo Periods</strong> - Quantidade de períodos a serem usados no HiLo;
    </li>
    <li>
        <strong>T1 HiLo set Trend</strong> - O HiLo no gráfico T1 define a tendência. Só abre a operação
        caso o HiLo esteja a favor da operação;
    </li>
    <li>
        <strong>T1 Moving Averange</strong> - Quantidade de períodos usandos na Média Móvel;
    </li>
</ul>
<h4>Gráfico T2 (Gráfico Secundário)</h4>
<ul>
    <li>
        <strong>T2 Graph Extra</strong> - Usa o gráfico secundário T2;
    </li>
    <li>
        <strong>T2 Graph Time</strong> - Período de tempo usado no gráfico T2;
    </li>
    <li>
        <strong>T2 Support and Resistance</strong> - Só inicia a operação quando o gráfico T2 apresenta 
        topos e fundos acendentes / descendentes;
    </li>
    <li>
        <strong>T2 HiLo Periods</strong> - Quantidade de períodos a serem usados no HiLo;
    </li>
    <li>
        <strong>T2 HiLo set Trend</strong> - O HiLo no gráfico T2 define a tendência. Só abre a operação
        caso o HiLo esteja a favor da operação;
    </li>
    <li>
        <strong>T2 Moving Averange</strong> - Quantidade de períodos usandos na Média Móvel;
    </li>
</ul>
<h4>Gráfico T3 (Gráfico Terciário)</h4>
<ul>
    <li>
        <strong>T3 Graph Extra</strong> - Usa o gráfico secundário T3;
    </li>
    <li>
        <strong>T3 Graph Time</strong> - Período de tempo usado no gráfico T3;
    </li>
    <li>
        <strong>T3 Support and Resistance</strong> - Só inicia a operação quando o gráfico T3 apresenta 
        topos e fundos acendentes / descendentes;
    </li>
    <li>
        <strong>T3 HiLo Periods</strong> - Quantidade de períodos a serem usados no HiLo;
    </li>
    <li>
        <strong>T3 HiLo set Trend</strong> - O HiLo no gráfico T3 define a tendência. Só abre a operação
        caso o HiLo esteja a favor da operação;
    </li>
    <li>
        <strong>T3 Moving Averange</strong> - Quantidade de períodos usandos na Média Móvel;
    </li>       
</ul>
<h4 id="stop-loss">Opções de Stop Loss</h4>
<ul>
    <li>
        <strong>Stop Loss Min</strong> - Diferença de pontos mínima entre o preço de entrada na operação e
        o Stop Loss;
    </li>
    <li>
        <strong>Stop Loss Max</strong> - Diferença de pontos máxima entre o preço de entrada na operação e
        o Stop Loss. Se <strong>Force entry</strong> estiver ativo, o Stop Loss será reduzido ao valor do 
        <strong>Stop Loss Max</strong>, caso contrário, a operação não será realizada.
    </li>
    <li>
        <strong>Stop Extra</strong> - Valor adicional de pontos ao Stop Loss;
    </li>
    <li>
        <strong>Stop Initial</strong> - Esse é o modelo de Stop Loss usado na abertura da operação. 
        Os tipos de Stop Loss são válidos para os gráficos T1, T2 ou T3 e são:
        <ol>
            <li><strong>Stop Fixed</strong> - O valor do Stop Loss é um valor fixo, baseado no campo <strong>Stop fixed value</strong>;</li>
            <li><strong>HiLo</strong> - O Stop Loss fica inicialmente na posição do HiLo e vai acompanhando o preço conforma a mudança;</li>
            <li><strong>Top/Bottom</strong> - O Stop Loss sobe/desce de acordo com o surgimento de um novo topo ou fundo;</li>
            <li><strong>Pior Candle</strong> - O Stop Loss sobe/desce se posicionando abaixo/acima do candle anterior;</li>
            <li><strong>Current Candle</strong> - O Stop Loss sobe/desce se posicionando abaixo/acima do candle atual;</li>
        </ol>
    </li>
    <li>
        <strong>Stop fixed value</strong> - Valor fixo do Stop Loss. O <strong>Stop Initial</strong> deve estar marcada como <strong>Stop Fixed</strong>;
    </li>
    <li>
        <strong>Force entry</strong> - Se estiver ativo, a operação será inicializada ajustando o valor do Stop Loss para o <strong>Stop Loss Max</strong>.
        Caso não esteja ativo, só inicializará a operação se o valor do Stop Loss estiver dentro do limite do <strong>Stop Loss Max</strong>;
    </li>
</ul>
<h4>Aumento de posição</h4>
<ul>
    <li>
        <strong>Run Position Increase</strong> - Usa o aumento de posição. Ao atinguir um novo objetivo, caso o 
        volume seja maior que zero a posição será aumentada;
    </li>
    <li>
        <strong>Run Position Stop Extra</strong> - Valor extra do Stop Loss usado apenas para o aumento da posição;
    </li>
    <li>
        <strong>Run Position Increase Minimal</strong> - Valor mínimo que o preço precisa se movimentar 
        para permitir uma nova entrada;
    </li>
</ul>
<h4>Opções de Break Even</h4>
<ul>
    <li>
        <strong>Break Even Position</strong> - 
        Posição onde o Break Even move o Stop Loss para a posição de preço de 
        entrada na operação + <strong>Break Even Value</strong>;
    </li>
    <li>
        <strong>Break Even Value</strong> - Preço de entrada na operação + esse campo para mover o Stop Loss;
    </li>
    <li>
        <strong>Break Even Volume</strong> - Volume à ser realizado quando o Break Even é atingido. Quando for 
        negativo vai realizar a posição, quando for positivo vai aumentar a posição;
    </li>
</ul>
<h4>Opções de Volume</h4>
<ul>
    <li>
        <strong>Initial Volume</strong> - Volume inicial da operação;
    </li>
    <li>
        <strong>Max Volume</strong> - 
        Maximum volume of the operation. If the Run Position Increase is enabled, the volume may not pass this value;
    </li>
</ul>
<h4>Objetivo 1</h4>
<ul>
    <li>
        <strong>Goal 1 Condition</strong> -
        Condição para atingir o objetivo 1. Veja as opções em <a href="#operacional-basico">Input Condition</a>;
    </li>
    <li>
        <strong>Goal 1 Volume</strong> - Volume à ser realizado quando o Objetivo 1 é atingido. Quando for 
        negativo vai realizar a posição, quando for positivo vai aumentar a posição;
    </li>
    <li>
        <strong>Goal 1 Position</strong> - Valor fixo para se atingir o objetivo 1. O <strong>Goal 1 Condition</strong> 
        deve estar marcada como <strong>Fixed Position</strong>;
    </li>
    <li>
        <strong>Goal 1 Stop</strong> - Esse é o modelo de Stop Loss usado a partir do momento que atingir o
        objetivo 1. Veja mais detalhes nos campo <a href="#stop-loss">Stop Inicial</a>;
    </li>
</ul>
<h4>Objetivo 2</h4>
<ul>
    <li>
        <strong>Goal 2 Condition</strong> -
        Condição para atingir o objetivo 2. Veja as opções em <a href="#operacional-basico">Input Condition</a>;
    </li>
    <li>
        <strong>Goal 2 Volume</strong> - Volume à ser realizado quando o objetivo 2 é atingido. Quando for 
        negativo vai realizar a posição, quando for positivo vai aumentar a posição;
    </li>
    <li>
        <strong>Goal 2 Position</strong> - Valor fixo para se atingir o objetivo 2. O <strong>Goal 2 Condition</strong> 
        deve estar marcada como <strong>Fixed Position</strong>;
    </li>
    <li>
        <strong>Goal 2 Stop</strong> - Esse é o modelo de Stop Loss usado a partir do momento que atingir o
        objetivo 2. Veja mais detalhes nos campo <a href="#stop-loss">Stop Inicial</a>;
    </li>
</ul>
<h4>Objetivo 3</h4>
<ul>
    <li>
        <strong>Goal 3 Condition</strong> -
        Condição para atingir o objetivo 3. Veja as opções em <a href="#operacional-basico">Input Condition</a>;
    </li>
    <li>
        <strong>Goal 3 Volume</strong> - Volume à ser realizado quando o objetivo 3 é atingido. Quando for 
        negativo vai realizar a posição, quando for positivo vai aumentar a posição;
    </li>
    <li>
        <strong>Goal 3 Position</strong> - Valor fixo para se atingir o objetivo 3. O <strong>Goal 3 Condition</strong> 
        deve estar marcada como <strong>Fixed Position</strong>;
    </li>
    <li>
        <strong>Goal 3 Stop</strong> - Esse é o modelo de Stop Loss usado a partir do momento que atingir o
        objetivo 3. Veja mais detalhes nos campo <a href="#stop-loss">Stop Inicial</a>;
    </li>
</ul>