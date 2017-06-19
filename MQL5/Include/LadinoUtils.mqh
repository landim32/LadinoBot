//+------------------------------------------------------------------+
//|                                               LadinoBotUtils.mqh |
//|                                                   Rodrigo Landim |
//|                                        http://www.emagine.com.br |
//+------------------------------------------------------------------+
#property copyright "Rodrigo Landim"
#property link      "http://www.emagine.com.br"

enum ENUM_TEMPO_GRAFICO {
   T1,
   T2,
   T3
};

enum CONDICAO_ENTRADA {
   HILO_CRUZ_MM_T1_TICK = 0,           // HiLo/MM T1 (Tick)
   HILO_CRUZ_MM_T2_TICK = 1,           // HiLo/MM T2 (Tick)
   HILO_CRUZ_MM_T3_TICK = 2,           // HiLo/MM T3 (Tick)
   HILO_CRUZ_MM_T1_FECHAMENTO = 3,     // HiLo/MM T1 (Close)
   HILO_CRUZ_MM_T2_FECHAMENTO = 4,     // HiLo/MM T2 (Close)
   HILO_CRUZ_MM_T3_FECHAMENTO = 5,     // HiLo/MM T3 (Close)
   //HILO_ROMPEU_MM_T1_TICK = 6,         // Price broke MM T1 (Tick)
   //HILO_ROMPEU_MM_T2_TICK = 7,         // Price broke MM T2 (Tick)
   //HILO_ROMPEU_MM_T3_TICK = 8,         // Price broke MM T3 (Tick)
   //HILO_ROMPEU_MM_T1_FECHAMENTO = 9,   // Price broke MM T1 (Close)
   //HILO_ROMPEU_MM_T2_FECHAMENTO = 10,   // Price broke MM T2 (Close)
   //HILO_ROMPEU_MM_T3_FECHAMENTO = 11,   // Price broke MM T3 (Close)
   APENAS_TENDENCIA_T1 = 12,            // Only Trend T1
   APENAS_TENDENCIA_T2 = 13,            // Only Trend T2
   APENAS_TENDENCIA_T3 = 14             // Only Trend T3
};

enum TIPO_GESTAO_RISCO {
   RISCO_NORMAL = 0,       // Normal
   RISCO_PROGRESSIVO = 1   // Progressive
};

enum TIPO_OBJETIVO {
   OBJETIVO_NENHUM = 0,             // Nothing to do
   OBJETIVO_FIXO = 1,               // Fixed Position
   OBJETIVO_ROMPIMENTO_LT = 2,      // Trendline Break
   OBJETIVO_DUNNIGAN = 3,           // Dunnigan Price Action
   OBJETIVO_T1_FIBO_0382 = 4,       // T1 Fibo 38,2
   OBJETIVO_T2_FIBO_0382 = 5,       // T2 Fibo 38,2
   OBJETIVO_T3_FIBO_0382 = 6,       // T3 Fibo 38,2
   OBJETIVO_T1_FIBO_0618 = 7,       // T1 Fibo 61,8
   OBJETIVO_T2_FIBO_0618 = 8,       // T2 Fibo 61,8
   OBJETIVO_T3_FIBO_0618 = 9,       // T3 Fibo 61,8
   OBJETIVO_T1_FIBO_1000 = 10,      // T1 Fibo 100
   OBJETIVO_T2_FIBO_1000 = 11,      // T2 Fibo 100
   OBJETIVO_T3_FIBO_1000 = 12,      // T3 Fibo 100
   OBJETIVO_T1_FIBO_1382 = 13,      // T1 Fibo 138,2
   OBJETIVO_T2_FIBO_1382 = 14,      // T2 Fibo 138,2
   OBJETIVO_T3_FIBO_1382 = 15,      // T3 Fibo 138,2
   OBJETIVO_T1_FIBO_1618 = 16,      // T1 Fibo 161,8
   OBJETIVO_T2_FIBO_1618 = 17,      // T2 Fibo 161,8
   OBJETIVO_T3_FIBO_1618 = 18,      // T3 Fibo 161,8
   OBJETIVO_T1_FIBO_2000 = 19,      // T1 Fibo 200
   OBJETIVO_T2_FIBO_2000 = 20,      // T2 Fibo 200
   OBJETIVO_T3_FIBO_2000 = 21,      // T3 Fibo 200
   OBJETIVO_T1_FIBO_2618 = 22,      // T1 Fibo 261,8
   OBJETIVO_T2_FIBO_2618 = 23,      // T2 Fibo 261,8
   OBJETIVO_T3_FIBO_2618 = 24       // T3 Fibo 261,8
};

enum TIPO_STOP {
   STOP_FIXO = 0,             // Stop Fixed
   STOP_T1_HILO = 1,          // T1 HiLo
   STOP_T2_HILO = 2,          // T2 HiLo
   STOP_T3_HILO = 3,          // T3 HiLo
   STOP_T1_TOPO_FUNDO = 4,    // T1 Top/Bottom
   STOP_T2_TOPO_FUNDO = 5,    // T2 Top/Bottom
   STOP_T3_TOPO_FUNDO = 6,    // T3 Top/Bottom
   STOP_T1_VELA_ATENRIOR = 7, // T1 Prior Candle
   STOP_T2_VELA_ATENRIOR = 8, // T2 Prior Candle
   STOP_T3_VELA_ATENRIOR = 9, // T3 Prior Candle
   STOP_T1_VELA_ATUAL = 10,    // T1 Current Candle
   STOP_T2_VELA_ATUAL = 11,   // T2 Current Candle
   STOP_T3_VELA_ATUAL = 12    // T3 Current Candle
};

enum OPERACAO_SITUACAO {
   SITUACAO_ABERTA,
   SITUACAO_BREAK_EVEN,
   SITUACAO_OBJETIVO1,
   SITUACAO_OBJETIVO2,
   SITUACAO_OBJETIVO3,
   SITUACAO_FECHADA
};

/*
double volumeAtual = 0;
int MMT1Handle = 0, MMT2Handle = 0, MMT3Handle = 0;
int tamanhoLinhaTendencia = 0;

SINAL_TENDENCIA 
   negociacaoAtual   = INDEFINIDA,
   t1TendenciaHiLo   = INDEFINIDA, 
   t2TendenciaHiLo   = INDEFINIDA, 
   t3TendenciaHiLo   = INDEFINIDA,
   t1TendenciaSR     = INDEFINIDA, 
   t2TendenciaSR     = INDEFINIDA, 
   t3TendenciaSR     = INDEFINIDA;

double 
   t1SuporteAtual = 0, 
   t2SuporteAtual = 0, 
   t3SuporteAtual = 0,
   t1ResistenciaAtual = 0, 
   t2ResistenciaAtual = 0, 
   t3ResistenciaAtual = 0;

bool tendenciaMudou = false;
bool posicionado = false;

LadinoCandlestick candleStick;
LadinoHiLo t1hilo, t2hilo, t3hilo;
LadinoSR t1sr, t2sr, t3sr;
LadinoAutoTrend autoTrend;

double hiloAtual = 0;
double precoCompra = 0, precoVenda = 0;

OPERACAO_SITUACAO operacaoAtual = SITUACAO_FECHADA;

VELA t1VelaAtual, t1VelaAnterior, t1Vela3, t1Vela4;
VELA t2VelaAtual, t2VelaAnterior, t2Vela3, t2Vela4;
VELA t3VelaAtual, t3VelaAnterior, t3Vela3, t3Vela4;

bool t1NovaVela = false, t2NovaVela = false, t3NovaVela = false;
datetime t1Candle, t2Candle, t3Candle;

datetime ultimaLT;
bool tentativaCandle = false;

//Relatorio
double ultimoStopMax = 0;
int diaAtual = 0;

int fractalHandle = 0;

SITUACAO_ROBO ativo = INATIVO;

long t2chartid = 0, t3chartid = 0;
*/

//+------------------------------------------------------------------+

/*
class MyLadinoTrade: public LadinoTrade {
   public:
      virtual void escreverLog(string msg);
      virtual void aoAbrirPosicao();
      virtual void aoFecharPosicao(double saldo);
      virtual void aoAtingirGanhoMax();
      virtual void aoAtingirPerdaMax();
};

void MyLadinoTrade::escreverLog(string msg) {
   _logs.adicionarLog(msg);
}

void MyLadinoTrade::aoAbrirPosicao() {
   operacaoAtual = SITUACAO_ABERTA;
   tendenciaMudou = false;
   tentativaCandle = true;
}

void MyLadinoTrade::aoFecharPosicao(double saldo) {
   //currentSL = 0;
   negociacaoAtual = INDEFINIDA;
   atualizarNegociacaoAtual();
   //operacaoAtual = SITUACAO_FECHADA;
   operacaoAtual = SITUACAO_ABERTA;
}

void MyLadinoTrade::aoAtingirGanhoMax() {
   _logs.adicionarLog("Maximum gains achieved!");
   desativar();
}

void MyLadinoTrade::aoAtingirPerdaMax() {
   _logs.adicionarLog("Maximum loss achieved!");
   desativar();
}
*/

//+------------------------------------------------------------------+

//LogPanel _logs;
//MyLadinoTrade _trade;