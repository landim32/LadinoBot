//+------------------------------------------------------------------+
//|                                                       Ladino.mq5 |
//|                                                   Rodrigo Landim |
//|                                        http://www.emagine.com.br |
//+------------------------------------------------------------------+
#property copyright     "Rodrigo Landim"
#property link          "http://www.emagine.com.br"
#property version       "1.00"
#property description   "Free Expert Advisor working using HiLo and MM starting the"
#property description   "operation when the HiLo change and MM cross the candle."

#include <trade/trade.mqh>
#include "./Include/Utils.mqh"
#include "./Include/LogPanel.mqh"
#include "./Include/LadinoCandlestick.mqh"
#include "./Include/LadinoHiLo.mqh"
#include "./Include/LadinoTrade.mqh"
#include "./Include/LadinoSR.mqh"
#include "./Include/LadinoAutoTrend.mqh"

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

input ENUM_HORARIO      HorarioEntrada = HORARIO_1000;      // Start Time
input ENUM_HORARIO      HorarioFechamento = HORARIO_1600;   // Closing Time
input ENUM_HORARIO      HorarioSaida = HORARIO_1630;        // Exit Time
input SENTIDO_OPERACAO  TipoOperacao = COMPRAR_VENDER;   // Operation type
input ATIVO_TIPO        TipoAtivo = ATIVO_INDICE;        // Asset type
input TIPO_GESTAO_RISCO GestaoRisco = RISCO_NORMAL;      // Risk management
input CONDICAO_ENTRADA  CondicaoEntrada = HILO_CRUZ_MM_T1_FECHAMENTO; // Input condition
input double            Corretagem = 1;                  // Brokerage value
input double            ValorPonto = 0.2;                // Value per point

input bool              T1LinhaTendencia = false;        // T1 Use Trendline
input bool              T1SRTendencia = true;            // T1 Support and Resistance
input int               T1HiloPeriodo = 13;              // T1 HiLo Periods
input bool              T1HiloTendencia = true;          // T1 HiLo set Trend
input int               T1MM = 9;                        // T1 Moving average

input bool              T2GraficoExtra = true;           // T2 Graph Extra
input ENUM_TIMEFRAMES   T2TempoGrafico = PERIOD_H1;     // T2 Graph Time
input int               T2HiloPeriodo = 13;               // T2 HiLo Periods
input bool              T2HiloTendencia = true;          // T2 HiLo set Trend
input bool              T2SRTendencia = false;           // T2 Support and Resistance
input int               T2MM = 9;                        // T2 Moving average

input bool              T3GraficoExtra = false;          // T3 Graph Extra
input ENUM_TIMEFRAMES   T3TempoGrafico = PERIOD_H2;      // T3 Graph Time
input bool              T3HiloAtivo = true;              // T3 HiLo Active
input int               T3HiloPeriodo = 5;               // T3 HiLo Periods
input bool              T3HiloTendencia = true;          // T3 HiLo set Trend
input bool              T3SRTendencia = false;           // T3 Support and Resistance
input int               T3MM = 9;                        // T3 Moving average

input double            StopLossMin = 30;                // Stop Min Loss
input double            StopLossMax = 150;               // Stop Max Loss
input double            StopExtra = 30;                  // Stop Extra
input TIPO_STOP         StopInicial = STOP_T1_HILO;      // Stop Initial
input double            StopFixo = 0;                    // Stop fixed value
input bool              ForcarOperacao = true;           // Force operation
input bool              ForcarEntrada = true;            // Force entry

input double            LTExtra = 0;                     // Trendline Extra
input int               MaxGain = 100;                   // Daily Max Gain
input int               MaxLoss = -30;                   // Daily Max Loss
input double            MaxGainPosition = 100;           // Operation Max Gain
input bool              AumentoAtivo = false;            // Run Position Increase
input double            AumentoStopExtra = 20;           // Run Position Stop Extra
input int               AumentoMinimo = 80;              // Run Position Increase Minimal
input int               BreakEven = 150;                   // Break Even Position
input int               BreakEvenValor = 50;             // Break Even Value
input int               BreakEvenVolume = 0;             // Break Even Volume
input int               InicialVolume = 1;               // Initial Volume
input int               MaximoVolume = 1;                // Max Volume

input TIPO_OBJETIVO     Objetivo1Condicao = OBJETIVO_FIXO; // Goal 1 Condition
input int               Objetivo1Volume = -1;            // Goal 1 Volume
input int               Objetivo1Posicao = 600;          // Goal 1 Position
input TIPO_STOP         Objetivo1Stop = STOP_T1_HILO;    // Goal 1 Stop
input TIPO_OBJETIVO     Objetivo2Condicao = OBJETIVO_FIXO; // Goal 2 Condition
input int               Objetivo2Volume = 0;             // Goal 2 Volume
input int               Objetivo2Posicao = 0;            // Goal 2 Position
input TIPO_STOP         Objetivo2Stop = STOP_T2_HILO;    // Goal 2 Stop
input TIPO_OBJETIVO     Objetivo3Condicao = OBJETIVO_FIXO; // Goal 3 Condition
input int               Objetivo3Volume = 0;             // Goal 3 Volume
input int               Objetivo3Posicao = 0;            // Goal 3 Position
input TIPO_STOP         Objetivo3Stop = STOP_T2_VELA_ATENRIOR; // Goal 3 Stop

double volumeAtual = 0;
int MMT1Handle = 0, MMT2Handle = 0, MMT3Handle = 0;
int tamanhoLinhaTendencia = 0;

enum OPERACAO_SITUACAO {
   SITUACAO_ABERTA,
   SITUACAO_BREAK_EVEN,
   SITUACAO_OBJETIVO1,
   SITUACAO_OBJETIVO2,
   SITUACAO_OBJETIVO3,
   SITUACAO_FECHADA
};

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

//+------------------------------------------------------------------+
class MyLadinoTrade: public LadinoTrade {
   public:
      virtual void escreverLog(string msg);
      virtual void aoAbrirPosicao();
      virtual void aoFecharPosicao(double saldo);
      virtual void aoAtingirGanhoMax();
      virtual void aoAtingirPerdaMax();
};

LogPanel _logs;
MyLadinoTrade _trade;

const string 
   labelPosicaoAtual = "labelPosicaoAtual", 
   labelPosicaoGeral = "labelPosicaoGeral", 
   labelNegociacaoAtual = "labelNegociacaoAtual",
   labelT1SR = "labelT1SR",
   labelT2SR = "labelT2SR",
   labelT3SR = "labelT3SR",
   labelPosicaoAtualTexto = "$+:",
   labelPosicaoGeralTexto = "$$:";

//+------------------------------------------------------------------+

int OnInit() {

   EventSetTimer(60); 

   ChartSetInteger(0, CHART_SHOW_GRID, false);
   ChartSetInteger(0, CHART_MODE, CHART_CANDLES);
   ChartSetInteger(0, CHART_AUTOSCROLL, true);
   
   _logs.inicializar();
   _logs.adicionarLog("Initializing LadinoHiLo...");

   /*
   double tickMinimo = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_SIZE);
   double objetivo1 = (BreakEven > 0) ? BreakEven + (BreakEven * 0.382) : (tickMinimo * 10);
   double objetivo2 = objetivo1 + (objetivo1 * 0.618);
   double objetivo3 = objetivo1 + objetivo2;
   */
   
   _trade.setBreakEven(BreakEven);
   //_trade.setObjetivo1(Objetivo1Posicao);

   _trade.setCorretagem(Corretagem);
   _trade.setMaxGain(MaxGain);
   _trade.setMaxLoss(MaxLoss);
   _trade.setTipoAtivo(TipoAtivo);
   _trade.setValorPonto(ValorPonto);
   _trade.setVolumeBreakEven(BreakEvenVolume);
   //_trade.setVolumeObjetivo1(Objetivo1Volume);
   //_trade.setVolumeObjetivo2(Objetivo2Volume);
   //_trade.setVolumeObjetivo3(Objetivo2Volume);

   if (T2GraficoExtra) {
      int y = (T3GraficoExtra) ? 255 : 10;
      t2chartid = novoGrafico("grafico_secundario", T2TempoGrafico, 240, 200, y, 210);
   }
   if (T3GraficoExtra)
      t3chartid = novoGrafico("grafico_terciario", T3TempoGrafico, 240, 200, 10, 210);

   MMT1Handle = iMA(_Symbol, _Period, T1MM, 0, MODE_EMA, PRICE_CLOSE);
   if(MMT1Handle == INVALID_HANDLE) {
      Print("Error creating MMT1 indicator");
      return(INIT_FAILED);
   }
   ChartIndicatorAdd(ChartID(), 0, MMT1Handle); 

   MMT2Handle = iMA(_Symbol, T2TempoGrafico, T2MM, 0, MODE_EMA, PRICE_CLOSE);
   if(MMT2Handle == INVALID_HANDLE) {
      Print("Error creating MMT2 indicator");
      return(INIT_FAILED);
   }
   ChartIndicatorAdd(t2chartid, 0, MMT2Handle); 

   MMT3Handle = iMA(_Symbol, T3TempoGrafico, T3MM, 0, MODE_EMA, PRICE_CLOSE);
   if(MMT3Handle == INVALID_HANDLE) {
      Print("Error creating MMT3 indicator");
      return(INIT_FAILED);
   }
   ChartIndicatorAdd(t3chartid, 0, MMT3Handle);

   if (!t1hilo.inicializar(T1HiloPeriodo, _Period, ChartID()))
      return(INIT_FAILED);

   if (T2GraficoExtra && !t2hilo.inicializar(T2HiloPeriodo, T2TempoGrafico, t2chartid))
      return(INIT_FAILED);
      
   if (T3GraficoExtra && !t3hilo.inicializar(T3HiloPeriodo, T3TempoGrafico, t3chartid))
      return(INIT_FAILED);
   
   if (!t1sr.inicializar(_Period))
      return(INIT_FAILED);
   if (!t2sr.inicializar(T2TempoGrafico))
      return(INIT_FAILED);
   if (!t3sr.inicializar(T3TempoGrafico))
      return(INIT_FAILED);
   
   _logs.adicionarLog("LadinoHiLo successfully launched.");

   //criarLabel(labelPosicaoAtual, labelPosicaoAtualTexto + "0.00", 30);
   //criarLabel(labelPosicaoGeral, labelPosicaoGeralTexto + "0.00", 45);
   criarStatusControls();
   
   MqlDateTime tempo;
   TimeToStruct(iTimeMQL4(_Symbol,_Period,0), tempo);
   diaAtual = tempo.day_of_year;
   ativo = INICIALIZADO;
   if (horarioCondicao(HorarioEntrada, IGUAL_OU_MAIOR_QUE) && horarioCondicao(HorarioFechamento, IGUAL_OU_MENOR_QUE))
      ativar();       
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason) {
   EventKillTimer();
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick() {
//---
   //_consolida.tick();
   if (ativo == ATIVO) {
      if(PositionSelect(_Symbol))
         verificarSaida();
      else
         verificarEntrada();
   }
   else if (ativo == FECHANDO) {
      if(PositionSelect(_Symbol))
         verificarSaida();
   }
}

void OnTimer(){
   MqlDateTime tempo;
   TimeToStruct(iTimeMQL4(_Symbol,_Period,0), tempo);
   if (diaAtual != tempo.day_of_year) {
      _trade.fecharDia();
      ativo = INICIALIZADO;
      diaAtual = tempo.day_of_year;
   }
   
   if (ativo == INICIALIZADO) {
      //if (tempo.hour >= 10 && tempo.min >= 0)
      if (horarioCondicao(HorarioEntrada, IGUAL_OU_MAIOR_QUE))
         ativar();      
   }   
   else if (ativo == ATIVO) {
      //if (tempo.hour >= 16)
      if (horarioCondicao(HorarioFechamento, IGUAL_OU_MAIOR_QUE))
         fechar();
      //if (tempo.hour >= 16 && tempo.min >= 30)
      if (horarioCondicao(HorarioSaida, IGUAL_OU_MAIOR_QUE))
         desativar();
   }
   else if (ativo == INATIVO) {
      //if (tempo.hour == 10 && tempo.min >= 0 && tempo.min <= 5)
      //   ativar();
   }
   else if (ativo == FECHANDO) {
      //if (tempo.hour >= 16 && tempo.min >= 30)
      if (horarioCondicao(HorarioSaida, IGUAL_OU_MAIOR_QUE))
         desativar();
   }
}

double OnTester() {
   _trade.fecharDia();
   string msg = "TESTE FINALIZADO!";
   msg += " s/f=" + IntegerToString(_trade.getSucessoTotal()) + "/" + IntegerToString(_trade.getFalhaTotal());
   msg += ", c=" + StringFormat("%.2f", _trade.getCorretagemTotal()) + ".";
   msg += ", $=" + StringFormat("%.2f", _trade.getTotal());
   _logs.adicionarLog(msg);
   return 0;
}

void OnTradeTransaction( 
   const MqlTradeTransaction& trans,   // estrutura das transações de negócios 
   const MqlTradeRequest&     request, // estrutura solicitada 
   const MqlTradeResult&      result   // resultado da estrutura 
) {
   _trade.aoNegociar(trans, request, result);
}

//+------------------------------------------------------------------+

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
//+------------------------------------------------------------------+

void atualizarNegociacaoAtual() {
   if (negociacaoAtual == INDEFINIDA) {
      ObjectDelete(0, labelNegociacaoAtual);
      ObjectDelete(0, labelNegociacaoAtual + "Titulo");
   }
   else {
      if (ObjectFind(0, labelNegociacaoAtual) != 0)
         criarLabel(0, labelNegociacaoAtual, ".", 70, 40, "Wingdings", 12, clrWhiteSmoke);
      if (ObjectFind(0, labelNegociacaoAtual + "Titulo") != 0)
         criarLabel(0, labelNegociacaoAtual + "Titulo", "Trend", 70, 10, "Tahoma", 10, clrWhiteSmoke);
      if (negociacaoAtual == ALTA) {
         ObjectSetString(0, labelNegociacaoAtual, OBJPROP_TEXT, CharToString(225));
         ObjectSetInteger(0, labelNegociacaoAtual, OBJPROP_COLOR, clrLimeGreen);
         ObjectSetString(0, labelNegociacaoAtual + "Titulo", OBJPROP_TEXT, "BUY");
         ObjectSetInteger(0, labelNegociacaoAtual + "Titulo", OBJPROP_COLOR, clrLimeGreen);
      }   
      else if (negociacaoAtual == BAIXA) {
         ObjectSetString(0, labelNegociacaoAtual, OBJPROP_TEXT, CharToString(226));
         ObjectSetInteger(0, labelNegociacaoAtual, OBJPROP_COLOR, clrRed);
         ObjectSetString(0, labelNegociacaoAtual + "Titulo", OBJPROP_TEXT, "SELL");
         ObjectSetInteger(0, labelNegociacaoAtual + "Titulo", OBJPROP_COLOR, clrRed);
      }
   }
}

void atualizarT1SRLabel() {
   if (t1TendenciaSR == INDEFINIDA) {
      ObjectDelete(0, labelT1SR);
      ObjectDelete(0, labelT1SR + "Titulo");
   }
   else {
      if (ObjectFind(0, labelT1SR) != 0)
         criarLabel(0, labelT1SR, ".", 31, 160, "Wingdings", 10);
      if (ObjectFind(0, labelT1SR + "Titulo") != 0)
         criarLabel(0, labelT1SR + "Titulo", "Top/Bottom", 30, 100);
      if (t1TendenciaSR == ALTA) {
         ObjectSetString(0, labelT1SR, OBJPROP_TEXT, CharToString(225));
         ObjectSetInteger(0, labelT1SR, OBJPROP_COLOR, clrLimeGreen);
      }   
      else if (t1TendenciaSR == BAIXA) {
         ObjectSetString(0, labelT1SR, OBJPROP_TEXT, CharToString(226));
         ObjectSetInteger(0, labelT1SR, OBJPROP_COLOR, clrRed);
      }
   }
}

void atualizarT2SRLabel() {
   int y = T3GraficoExtra ? 420 : 175;
   if (t2TendenciaSR == INDEFINIDA) {
      ObjectDelete(0, labelT2SR);
      ObjectDelete(0, labelT2SR + "Titulo");
   }
   else {
      if (ObjectFind(0, labelT2SR) != 0)
         criarLabel(0, labelT2SR, ".", 220, y, "Wingdings", 10, clrWhiteSmoke, CORNER_LEFT_LOWER, ANCHOR_LEFT);
      if (ObjectFind(0, labelT2SR + "Titulo") != 0)
         criarLabel(0, labelT2SR + "Titulo", "Top/Bottom", 220, y + 15, "Tahoma", 8, clrWhiteSmoke, CORNER_LEFT_LOWER, ANCHOR_LEFT);
      if (t2TendenciaSR == ALTA) {
         ObjectSetString(0, labelT2SR, OBJPROP_TEXT, CharToString(225));
         ObjectSetInteger(0, labelT2SR, OBJPROP_COLOR, clrLimeGreen);
      }   
      else if (t2TendenciaSR == BAIXA) {
         ObjectSetString(0, labelT2SR, OBJPROP_TEXT, CharToString(226));
         ObjectSetInteger(0, labelT2SR, OBJPROP_COLOR, clrRed);
      }
   }
}

void atualizarT3SRLabel() {
   if (t3TendenciaSR == INDEFINIDA) {
      ObjectDelete(0, labelT3SR);
      ObjectDelete(0, labelT3SR + "Titulo");
   }
   else {
      if (ObjectFind(0, labelT3SR) != 0)
         criarLabel(0, labelT3SR, ".", 220, 175, "Wingdings", 10, clrWhiteSmoke, CORNER_LEFT_LOWER, ANCHOR_LEFT);
      if (ObjectFind(0, labelT3SR + "Titulo") != 0)
         criarLabel(0, labelT3SR + "Titulo", "Top/Bottom", 220, 190, "Tahoma", 8, clrWhiteSmoke, CORNER_LEFT_LOWER, ANCHOR_LEFT);
      if (t3TendenciaSR == ALTA) {
         ObjectSetString(0, labelT3SR, OBJPROP_TEXT, CharToString(225));
         ObjectSetInteger(0, labelT3SR, OBJPROP_COLOR, clrLimeGreen);
      }   
      else if (t3TendenciaSR == BAIXA) {
         ObjectSetString(0, labelT3SR, OBJPROP_TEXT, CharToString(226));
         ObjectSetInteger(0, labelT3SR, OBJPROP_COLOR, clrRed);
      }
   }
}

void criarStatusControls() {
   //const int x = 30;
   
   criarLabel(0, labelPosicaoAtual + "Titulo", labelPosicaoAtualTexto, 30, 60);
   criarLabel(0, labelPosicaoAtual, "0.00", 30, 10);
   
   criarLabel(0, labelPosicaoGeral + "Titulo", labelPosicaoGeralTexto, 45, 60);
   criarLabel(0, labelPosicaoGeral, "0.00", 45, 10);
   
   /*
   t2TendenciaSR = ALTA;
   t3TendenciaSR = BAIXA;
   atualizarT2SRLabel();
   atualizarT3SRLabel();
   */
   //negociacaoAtual = ALTA;
   //atualizarNegociacaoAtual();
}

void ativar() {
   if (ativo != ATIVO) {
      ativo = ATIVO;
      _logs.adicionarLog("LadinoHiLo active for trading!");
      
      double volMinimo = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MIN);
      double volMaximo = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MAX);
      double volPasso = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_STEP);
      
      volumeAtual = InicialVolume;
      volumeAtual = volumeAtual - MathMod(volumeAtual, volPasso);
      
      if (volumeAtual < volMinimo)
         volumeAtual = volMinimo;
      if (volumeAtual > volMaximo)
         volumeAtual = volMaximo;
         
      _logs.adicionarLog("Volume " + IntegerToString((int) volumeAtual) + " to be traded...");
   }
}

void fechar() {
   if (ativo != FECHANDO) {
      ativo = FECHANDO;
      _logs.adicionarLog("LadinoHiLo closed to new trades! Current Financial = " + StringFormat("%.2f", _trade.getTotal()));
   }
}

void desativar() {
   if (ativo != INATIVO) {
      ativo = INATIVO;
      if(PositionSelect(_Symbol)) {
         _logs.adicionarLog("Disabling LadinoHiLo, closing all open positions.");
         _trade.finalizarPosicao();
      }
      _logs.adicionarLog("LadinoHiLo disabled for trading! Current Financial =" + StringFormat("%.2f", _trade.getTotal()));
   }
}

bool internoCarregarVela(ENUM_TIMEFRAMES tempo, bool novaVela, VELA& velaAtual, VELA& velaAnterior, VELA& vela3, VELA& vela4) {
   ZeroMemory(velaAtual);
   ZeroMemory(velaAnterior);
   
   MqlRates rt[5];
   if(CopyRates(_Symbol, tempo, 0, 5, rt) != 5) {
      Print("CopyRates of ",_Symbol," failed, no history");
      return false;
   }
   if (novaVela) {
      if (
         candleStick.pegarVela(rt[3], velaAtual) && 
         candleStick.pegarVela(rt[2], velaAnterior) &&
         candleStick.pegarVela(rt[1], vela3) &&
         candleStick.pegarVela(rt[0], vela4)
      )
         return true;
   }
   else {
      if (
         candleStick.pegarVela(rt[4], velaAtual) && 
         candleStick.pegarVela(rt[3], velaAnterior) &&
         candleStick.pegarVela(rt[2], vela3) &&
         candleStick.pegarVela(rt[1], vela4)
      )
         return true;
   }
   return false;
}

bool carregarVelaT1() {   
   t1NovaVela = false;
   datetime candleTime = iTimeMQL4(_Symbol, _Period, 0);
   if(t1Candle != candleTime) {
      t1NovaVela = true;
      t1Candle = candleTime;
   }
   return internoCarregarVela(_Period, t1NovaVela, t1VelaAtual, t1VelaAnterior, t1Vela3, t1Vela4);
}

bool carregarVelaT2() {   
   t2NovaVela = false;
   datetime candleTime = iTimeMQL4(_Symbol, T2TempoGrafico, 0);
   if(t2Candle != candleTime) {
      t2NovaVela = true;
      t2Candle = candleTime;
   }
   return internoCarregarVela(T2TempoGrafico, t2NovaVela, t2VelaAtual, t2VelaAnterior, t2Vela3, t2Vela4);
}

bool carregarVelaT3() {   
   t3NovaVela = false;
   datetime candleTime = iTimeMQL4(_Symbol, T3TempoGrafico, 0);
   if(t3Candle != candleTime) {
      t3NovaVela = true;
      t3Candle = candleTime;
   }
   return internoCarregarVela(T3TempoGrafico, t3NovaVela, t3VelaAtual, t3VelaAnterior, t3Vela3, t3Vela4);
}

void alterarOperacaoAtual() {
   if (operacaoAtual == SITUACAO_ABERTA || operacaoAtual == SITUACAO_BREAK_EVEN)
      operacaoAtual = SITUACAO_OBJETIVO1;
   else if (operacaoAtual == SITUACAO_OBJETIVO1)
      operacaoAtual = SITUACAO_OBJETIVO2;
   else if (operacaoAtual == SITUACAO_OBJETIVO2)
      operacaoAtual = SITUACAO_OBJETIVO3;
}

TIPO_STOP tipoStopAtual() {
   if (operacaoAtual == SITUACAO_OBJETIVO1)
      return Objetivo1Stop;
   else if (operacaoAtual == SITUACAO_OBJETIVO2)
      return Objetivo2Stop;
   else if (operacaoAtual == SITUACAO_OBJETIVO3)
      return Objetivo3Stop;
   else
      return StopInicial;
}

double pegarPosicaoStop(SINAL_POSICAO posicao) {
   //DADOS_SR dados[];
   double posicaoStop = 0;
   TIPO_STOP tipoStop = tipoStopAtual();
   switch (tipoStop) {
      case STOP_FIXO:
         if (posicao == COMPRADO)
            posicaoStop = precoCompra - StopFixo;
         else if (posicao == VENDIDO)
            posicaoStop = precoVenda + StopFixo;
         break;
      case STOP_T1_TOPO_FUNDO:
         if (posicao == COMPRADO)
            posicaoStop = t1SuporteAtual;
         else if (posicao == VENDIDO)
            posicaoStop = t1ResistenciaAtual;
         break;
      case STOP_T2_TOPO_FUNDO:
         if (posicao == COMPRADO)
            posicaoStop = t2SuporteAtual;
         else if (posicao == VENDIDO)
            posicaoStop = t2ResistenciaAtual;
         break;
      case STOP_T3_TOPO_FUNDO:
         if (posicao == COMPRADO)
            posicaoStop = t3SuporteAtual;
         else if (posicao == VENDIDO)
            posicaoStop = t3ResistenciaAtual;
         break;
      case STOP_T1_HILO:
         posicaoStop = t1hilo.posicaoAtual();
         break;
      case STOP_T2_HILO:
         posicaoStop = t2hilo.posicaoAtual();
         break;
      case STOP_T3_HILO:
         posicaoStop = t3hilo.posicaoAtual();
         break;
      case STOP_T1_VELA_ATENRIOR:
         if (posicao == COMPRADO)
            posicaoStop = t1VelaAnterior.minima;
         else if (posicao == VENDIDO)
            posicaoStop = t1VelaAnterior.maxima;
         break;
      case STOP_T2_VELA_ATENRIOR:
         if (posicao == COMPRADO)
            posicaoStop = t2VelaAnterior.minima;
         else if (posicao == VENDIDO)
            posicaoStop = t2VelaAnterior.maxima;
         break;
      case STOP_T3_VELA_ATENRIOR:
         if (posicao == COMPRADO)
            posicaoStop = t3VelaAnterior.minima;
         else if (posicao == VENDIDO)
            posicaoStop = t3VelaAnterior.maxima;
         break;
      case STOP_T1_VELA_ATUAL:
         if (posicao == COMPRADO)
            posicaoStop = t1VelaAtual.minima;
         else if (posicao == VENDIDO)
            posicaoStop = t1VelaAtual.maxima;
         break;
      case STOP_T2_VELA_ATUAL:
         if (posicao == COMPRADO)
            posicaoStop = t2VelaAtual.minima;
         else if (posicao == VENDIDO)
            posicaoStop = t2VelaAtual.maxima;
         break;
      case STOP_T3_VELA_ATUAL:
         if (posicao == COMPRADO)
            posicaoStop = t3VelaAtual.minima;
         else if (posicao == VENDIDO)
            posicaoStop = t3VelaAtual.maxima;
         break;
   }
   if (posicao == COMPRADO) {
      if (operacaoAtual == SITUACAO_ABERTA || operacaoAtual == SITUACAO_BREAK_EVEN)
         posicaoStop -= StopExtra;
      else
         posicaoStop -= AumentoStopExtra;
   }
   else if (posicao == VENDIDO) {
      if (operacaoAtual == SITUACAO_ABERTA || operacaoAtual == SITUACAO_BREAK_EVEN)
         posicaoStop += StopExtra;
      else
         posicaoStop += AumentoStopExtra;
   }
   return posicaoStop;
}

bool inicializarCompra(double price, double stopLoss) {

   if (TipoOperacao != COMPRAR_VENDER && TipoOperacao != APENAS_COMPRAR)
      return false;

   double sl = price - NormalizeDouble(stopLoss - StopExtra, _Digits);
   if (StopLossMax > 0 && sl >= StopLossMax) {
      if (ultimoStopMax != sl) {
         ultimoStopMax = sl;
         _logs.adicionarLog("Stop Loss exceeds max value=" + IntegerToString((int)sl) + ".");
      }
      if (ForcarEntrada)
         sl = StopLossMax;
      else
         return false;
   }
   
   if (StopLossMin > 0 && sl < StopLossMin)
      sl = StopLossMin;
   
   double lot = _trade.validarFinanceiro(InicialVolume, sl);
   if (lot <= 0)
      return false;

   if (TerminalInfoInteger(TERMINAL_TRADE_ALLOWED)) {
      if (ForcarOperacao) {
         if (_trade.comprarForcado(lot, sl, 0, 10)) {
            configurarTakeProfit(COMPRADO, price);
            return true;
         }
      }
      else {
         if (_trade.comprar(lot, price, sl)) {
            configurarTakeProfit(COMPRADO, price);
            return true;
         }
      }
   }
   return false;
}

bool inicializarVenda(double price, double stopLoss) {

   if (TipoOperacao != COMPRAR_VENDER && TipoOperacao != APENAS_VENDER)
      return false;

   double tickMinimo = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_SIZE);
   double sl = NormalizeDouble(stopLoss + StopExtra, _Digits) - price;
   
   if (StopLossMax > 0 && sl >= StopLossMax) {
      if (ultimoStopMax != sl) {
         ultimoStopMax = sl;
         _logs.adicionarLog("Stop Loss exceeds max value=" + IntegerToString((int)sl) + ".");
      }
      if (ForcarEntrada)
         sl = StopLossMax;
      else
         return false;      
   }
   if (StopLossMin > 0 && sl < StopLossMin)
      sl = StopLossMin;
   
   double lot = _trade.validarFinanceiro(volumeAtual, sl);
   if (lot <= 0)
      return false;
   
   if (TerminalInfoInteger(TERMINAL_TRADE_ALLOWED)) {      
      if (ForcarOperacao) {
         if (_trade.venderForcado(lot, sl, 0, 10)) {
            configurarTakeProfit(VENDIDO, price);
            return true;
         }      
      }
      else {
         if (_trade.vender(lot, price, sl)) {
            configurarTakeProfit(VENDIDO, price);
            return true;
         }
      }
   }
   return false;
}

bool eTakeProfitT1(TIPO_OBJETIVO condicao) {
   return (
      condicao == OBJETIVO_T1_FIBO_0382 ||
      condicao == OBJETIVO_T1_FIBO_0618 ||
      condicao == OBJETIVO_T1_FIBO_1000 ||
      condicao == OBJETIVO_T1_FIBO_1382 ||
      condicao == OBJETIVO_T1_FIBO_1618 ||
      condicao == OBJETIVO_T1_FIBO_2000 ||
      condicao == OBJETIVO_T1_FIBO_2618
   );
}

bool eTakeProfitT2(TIPO_OBJETIVO condicao) {
   return (
      condicao == OBJETIVO_T2_FIBO_0382 ||
      condicao == OBJETIVO_T2_FIBO_0618 ||
      condicao == OBJETIVO_T2_FIBO_1000 ||
      condicao == OBJETIVO_T2_FIBO_1382 ||
      condicao == OBJETIVO_T2_FIBO_1618 ||
      condicao == OBJETIVO_T2_FIBO_2000 ||
      condicao == OBJETIVO_T2_FIBO_2618
   );
}

bool eTakeProfitT3(TIPO_OBJETIVO condicao) {
   return (
      condicao == OBJETIVO_T3_FIBO_0382 ||
      condicao == OBJETIVO_T3_FIBO_0618 ||
      condicao == OBJETIVO_T3_FIBO_1000 ||
      condicao == OBJETIVO_T3_FIBO_1382 ||
      condicao == OBJETIVO_T3_FIBO_1618 ||
      condicao == OBJETIVO_T3_FIBO_2000 ||
      condicao == OBJETIVO_T3_FIBO_2618
   );
}

double pegarValorFibo(TIPO_OBJETIVO condicao, double preco) {
   double retorno = 0;
   switch (condicao) {
      case OBJETIVO_T1_FIBO_0382:
      case OBJETIVO_T2_FIBO_0382:
      case OBJETIVO_T3_FIBO_0382:
         retorno = preco * 0.382;
         break;
      case OBJETIVO_T1_FIBO_0618:
      case OBJETIVO_T2_FIBO_0618:
      case OBJETIVO_T3_FIBO_0618:
         retorno = preco * 0.618;
         break;
      case OBJETIVO_T1_FIBO_1000:
      case OBJETIVO_T2_FIBO_1000:
      case OBJETIVO_T3_FIBO_1000:
         retorno = preco;
         break;
      case OBJETIVO_T1_FIBO_1382:
      case OBJETIVO_T2_FIBO_1382:
      case OBJETIVO_T3_FIBO_1382:
         retorno = preco * 1.382;
         break;
      case OBJETIVO_T1_FIBO_1618:
      case OBJETIVO_T2_FIBO_1618:
      case OBJETIVO_T3_FIBO_1618:
         retorno = preco * 1.618;
         break;
      case OBJETIVO_T1_FIBO_2000:
      case OBJETIVO_T2_FIBO_2000:
      case OBJETIVO_T3_FIBO_2000:
         retorno = preco * 2;
         break;
      case OBJETIVO_T1_FIBO_2618:
      case OBJETIVO_T2_FIBO_2618:
      case OBJETIVO_T3_FIBO_2618:
         retorno = preco * 2.618;
         break;
      default:
         retorno = 0;
         break;
   }
   return retorno;
}

double pegarTakeProfitFibo(SINAL_POSICAO tendencia, ENUM_TEMPO_GRAFICO tempo, TIPO_OBJETIVO condicao, double preco) {
   double suporteAtual = 0;
   double resistenciaAtual = 0;
   DADOS_SR dados[];
   if (tempo == T1) {
      t1sr.atualizar(dados);
      suporteAtual = t1sr.suporteAtual(dados);
      resistenciaAtual = t1sr.resistenciaAtual(dados);
   }
   else if (tempo == T2) {
      t2sr.atualizar(dados);
      suporteAtual = t2sr.suporteAtual(dados);
      resistenciaAtual = t2sr.resistenciaAtual(dados);
   }
   else if (tempo == T3) {
      t3sr.atualizar(dados);
      suporteAtual = t3sr.suporteAtual(dados);
      resistenciaAtual = t3sr.resistenciaAtual(dados);
   }
   
   double variacao = MathAbs(resistenciaAtual - suporteAtual);
   variacao = pegarValorFibo(condicao, variacao);
   if (variacao > 0) {
      if (tendencia == COMPRADO)
         return suporteAtual + variacao;
      else if (tendencia == VENDIDO)
         return resistenciaAtual - variacao;
   }
   return 0;
}

void adicionarTakeProfitFibo(SINAL_POSICAO tendencia, TIPO_OBJETIVO condicao, double preco, double posicao, double vol) {

   double tp = 0;
   if (condicao == OBJETIVO_FIXO) {
      if (posicao > 0) {
         if (tendencia == COMPRADO)
            tp = preco + posicao;
         else if (tendencia == VENDIDO)
            tp = preco - posicao;
      }
   }
   else if (eTakeProfitT1(condicao)) {
      tp = pegarTakeProfitFibo(tendencia, T1, condicao, preco);      
   }
   else if (eTakeProfitT2(condicao)) {
      tp = pegarTakeProfitFibo(tendencia, T2, condicao, preco);      
   }
   else if (eTakeProfitT3(condicao)) {
      tp = pegarTakeProfitFibo(tendencia, T3, condicao, preco);
   }
   if (tp != 0) {
      if (vol > 0) {
         if (tendencia == COMPRADO)
            _trade.comprarTP(vol, tp);
         else if (tendencia == VENDIDO)
            _trade.venderTP(vol, tp);
      }
      else if (vol < 0) {
         if (tendencia == COMPRADO)
            _trade.venderTP(MathAbs(vol), tp);
         else if (tendencia == VENDIDO)
            _trade.comprarTP(MathAbs(vol), tp);
      }
   }
}

void configurarTakeProfit(SINAL_POSICAO tendencia, double preco) {
   adicionarTakeProfitFibo(tendencia, Objetivo1Condicao, preco, Objetivo1Posicao, Objetivo1Volume);
   adicionarTakeProfitFibo(tendencia, Objetivo2Condicao, preco, Objetivo2Posicao, Objetivo2Volume);
   adicionarTakeProfitFibo(tendencia, Objetivo3Condicao, preco, Objetivo3Posicao, Objetivo3Volume);
}

bool aumentarCompra(double lot, double price, double stopLoss) {

   if (!(price > (_trade.ultimoPrecoEntrada() + AumentoMinimo)))
      return false;      
   if ((MathAbs(_trade.getVolume()) + lot) > MaximoVolume)
      return false;

   //double sl = price - NormalizeDouble(stopLoss - AumentoPosicaoStopExtra, _Digits);   
   double sl = NormalizeDouble(stopLoss, _Digits);   
   if (StopLossMin > 0 && sl < StopLossMin)
      sl = StopLossMin;

   if (TerminalInfoInteger(TERMINAL_TRADE_ALLOWED)) {
      if (_trade.comprar(lot, price, sl)) {
         return true;
      }
   }
   return false;
}

bool aumentarVenda(double lot, double price, double stopLoss) {

   if (!(price < (_trade.ultimoPrecoEntrada() - AumentoMinimo)))
      return false;
   if ((MathAbs(_trade.getVolume()) + lot) > MaximoVolume)
      return false;

   //double sl = price + NormalizeDouble(stopLoss + AumentoPosicaoStopExtra, _Digits);   
   double sl = NormalizeDouble(stopLoss, _Digits);   
   if (StopLossMin > 0 && sl < StopLossMin)
      sl = StopLossMin;

   if (TerminalInfoInteger(TERMINAL_TRADE_ALLOWED)) {
      if (_trade.vender(lot, price, sl)) {
         return true;
      }
   }
   return false;
}

bool comprarCruzouHiLo(SINAL_TENDENCIA tendenciaHiLo, ENUM_TIMEFRAMES tempo, VELA& velaAtual, VELA& velaAnterior, double mm) {
   if (tendenciaHiLo == ALTA && negociacaoAtual != ALTA) {
      if (velaAtual.tipo == COMPRADORA && velaAnterior.tipo == COMPRADORA && precoCompra > velaAtual.abertura) { // Rompeu a anterior
         if (precoCompra > mm && mm >= velaAtual.minima && mm <= velaAtual.maxima) {
            if (T1LinhaTendencia) {
               negociacaoAtual = ALTA;
               atualizarNegociacaoAtual();
               tamanhoLinhaTendencia = autoTrend.gerarLTB(ultimaLT, tempo, ChartID(), 15);
               return true;
            }
            else {
               double posicaoStop = pegarPosicaoStop(COMPRADO);
               if (inicializarCompra(precoCompra, posicaoStop)) {
                  ultimaLT = velaAtual.tempo;
                  return true;
               }
            }
         }
      }
   }
   return false;
}

bool venderCruzouHiLo(SINAL_TENDENCIA tendenciaHiLo, ENUM_TIMEFRAMES tempo, VELA& velaAtual, VELA& velaAnterior, double mm) {
   if (tendenciaHiLo == BAIXA && negociacaoAtual != BAIXA) {
      if (velaAtual.tipo == VENDEDORA && velaAnterior.tipo == VENDEDORA && precoVenda < velaAtual.abertura) { // Rompeu a anterior
         if (precoVenda < mm && mm <= velaAtual.maxima && mm >= velaAtual.minima) {
         
            if (T1LinhaTendencia) {
               negociacaoAtual = BAIXA;
               atualizarNegociacaoAtual();
               tamanhoLinhaTendencia = autoTrend.gerarLTA(ultimaLT, tempo, ChartID(), 15);
               return true;
            }
            else {
               double posicaoStop = pegarPosicaoStop(VENDIDO);
               if (inicializarVenda(precoVenda, posicaoStop)) {
                  ultimaLT = velaAtual.tempo;
                  return true;
               }
            }
            
         }
      }
   }
   return false;
}

bool comprarNaTendencia(VELA& velaAtual, VELA& velaAnterior) {
   //if (negociacaoAtual != ALTA)
   //   return false;
   if (T1HiloTendencia && t1TendenciaHiLo != ALTA) 
      return false;
   if (T2HiloTendencia && t2TendenciaHiLo != ALTA) 
      return false;
   if (T3HiloTendencia && t3TendenciaHiLo != ALTA) 
      return false;
      
   if (T1SRTendencia && t1TendenciaSR != ALTA)
      return false;
   if (T2SRTendencia && t2TendenciaSR != ALTA)
      return false;
   if (T3SRTendencia && t3TendenciaSR != ALTA)
      return false;
      
   if (!(velaAtual.tipo == COMPRADORA && precoCompra > velaAtual.abertura)) 
      return false;
   if (!(velaAnterior.tipo == COMPRADORA && precoCompra > velaAnterior.maxima)) 
      return false;
   negociacaoAtual = ALTA;
   atualizarNegociacaoAtual();
   tamanhoLinhaTendencia = autoTrend.gerarLTB(ultimaLT, PERIOD_CURRENT, ChartID(), 15);
   return true;
}

bool venderNaTendencia(VELA& velaAtual, VELA& velaAnterior) {
   //if (negociacaoAtual != BAIXA)
   //   return false;
   if (T1HiloTendencia && t1TendenciaHiLo != BAIXA) 
      return false;
   if (T2HiloTendencia && t2TendenciaHiLo != BAIXA) 
      return false;
   if (T3HiloTendencia && t3TendenciaHiLo != BAIXA) 
      return false;
      
   if (T1SRTendencia && t1TendenciaSR != BAIXA)
      return false;
   if (T2SRTendencia && t2TendenciaSR != BAIXA)
      return false;
   if (T3SRTendencia && t3TendenciaSR != BAIXA)
      return false;
      
   if (!(velaAtual.tipo == VENDEDORA && precoVenda < velaAtual.abertura)) 
      return false;
   if (!(velaAnterior.tipo == VENDEDORA && precoVenda < velaAnterior.minima)) 
      return false;
   negociacaoAtual = BAIXA;
   atualizarNegociacaoAtual();
   tamanhoLinhaTendencia = autoTrend.gerarLTA(ultimaLT, PERIOD_CURRENT, ChartID(), 15);
   return true;
}

void comprarDunnigan(ENUM_TIMEFRAMES tempo, VELA& velaAtual, VELA& velaAnterior, VELA& vela3, VELA& vela4) {
}

void venderDunnigan(ENUM_TIMEFRAMES tempo, VELA& velaAtual, VELA& velaAnterior, VELA& vela3, VELA& vela4) {
}

bool iniciandoExecucaoCompra() {
   double posicaoLTB = 0, posicaoStop = 0;
   if (negociacaoAtual != ALTA)
      return false;
   if (T1HiloTendencia && t1TendenciaHiLo != ALTA) 
      return false;
   if (T2GraficoExtra && T2HiloTendencia && t2TendenciaHiLo != ALTA)
      return false;
   if (T3GraficoExtra && T3HiloTendencia && t3TendenciaHiLo != ALTA) 
      return false;
      
   if (T1SRTendencia && t1TendenciaSR != ALTA)
      return false;
   if (T2GraficoExtra && T2SRTendencia && t2TendenciaSR != ALTA)
      return false;
   if (T3GraficoExtra && T3SRTendencia && t3TendenciaSR != ALTA)
      return false;
      
   if (tamanhoLinhaTendencia >= 3 && t1VelaAnterior.tipo == COMPRADORA)
      posicaoLTB = autoTrend.posicaoLTB(ChartID(), t1VelaAtual.tempo) + LTExtra;
   else
      return false;
   if (posicaoLTB > 0 && precoCompra > posicaoLTB && posicaoLTB >= t1VelaAtual.minima && posicaoLTB <= t1VelaAtual.maxima && precoCompra > t1VelaAnterior.maxima)
      posicaoStop = pegarPosicaoStop(COMPRADO);
   else
      return false;
   if (inicializarCompra(precoCompra, posicaoStop)) {
      autoTrend.limparLinha(ChartID());
      ultimaLT = t1VelaAtual.tempo;
      return true;
   }
   return false;
}

bool iniciandoExecucaoVenda() {
   double posicaoLTA = 0, posicaoStop = 0;
   if (negociacaoAtual != BAIXA)
      return false;
   if (T1HiloTendencia && t1TendenciaHiLo != ALTA) 
      return false;
   if (T2GraficoExtra && T2HiloTendencia && t2TendenciaHiLo != BAIXA) 
      return false;
   if (T3GraficoExtra && T3HiloTendencia && t3TendenciaHiLo != BAIXA) 
      return false;
      
   if (T1SRTendencia && t1TendenciaSR != BAIXA)
      return false;
   if (T2GraficoExtra && T2SRTendencia && t2TendenciaSR != BAIXA)
      return false;
   if (T3GraficoExtra && T3SRTendencia && t3TendenciaSR != BAIXA)
      return false;

   if (tamanhoLinhaTendencia >= 3 && t1VelaAnterior.tipo == VENDEDORA)
      posicaoLTA = autoTrend.posicaoLTA(ChartID(), t1VelaAtual.tempo) - LTExtra;
   else
      return false;
   if (posicaoLTA > 0 && precoVenda < posicaoLTA && posicaoLTA >= t1VelaAtual.minima && posicaoLTA <= t1VelaAtual.maxima && precoVenda < t1VelaAnterior.minima)
      posicaoStop = pegarPosicaoStop(VENDIDO);
   else
      return false;
   if (inicializarVenda(precoVenda, posicaoStop)) {
      autoTrend.limparLinha(ChartID());
      ultimaLT = t1VelaAtual.tempo;
      return true;
   }
   return false;
}

double pegarProximoObjetivoVolume() {
   if (operacaoAtual == SITUACAO_ABERTA || operacaoAtual == SITUACAO_BREAK_EVEN)
      return Objetivo1Volume;
   else if (operacaoAtual == SITUACAO_OBJETIVO1)
      return Objetivo2Volume;
   else if (operacaoAtual == SITUACAO_OBJETIVO2)
      return Objetivo3Volume;
   else 
      return 0;
}

bool executarAumento(SINAL_POSICAO tendencia, double volume) {
   double sl = 0;
   double stopLoss = pegarPosicaoStop(tendencia);
   if (tendencia == COMPRADO)
      sl = (precoCompra - stopLoss) + AumentoStopExtra;
   else if (tendencia == VENDIDO)
      sl = (stopLoss - precoVenda) + AumentoStopExtra;
   
   double volumeLocal = volume;
   if (GestaoRisco == RISCO_PROGRESSIVO) {
      double precoSR = 0;
      if (tendencia == COMPRADO)
         precoSR = precoCompra + sl;
      else if (tendencia == VENDIDO)
         precoSR = precoVenda - sl;
      double pontos = _trade.posicaoPontoEmAberto(precoSR);
      volumeLocal = MathFloor(pontos / sl);
   }
   if (volumeLocal > 0) {
      if (tendencia == COMPRADO) {
         if (aumentarCompra(volumeLocal, precoCompra, sl)) {
            autoTrend.limparLinha(ChartID());
            ultimaLT = t1VelaAtual.tempo;
            if (GestaoRisco == RISCO_PROGRESSIVO) {
               double volumeTP = MathAbs(_trade.getVolume());
               _trade.venderTP(volumeTP, precoCompra + 100);
            }
            return true;
         }
      }
      else if (tendencia == VENDIDO) {
         if (aumentarVenda(volumeLocal, precoVenda, sl)) {
            autoTrend.limparLinha(ChartID());
            ultimaLT = t1VelaAtual.tempo;
            if (GestaoRisco == RISCO_PROGRESSIVO) {
               double volumeTP = MathAbs(_trade.getVolume());
               _trade.comprarTP(volumeTP, precoVenda - 100);
            }
            return true;
         }
      }
   }
   else 
      ultimaLT = t1VelaAtual.tempo;
   return false;
}

void executarObjetivo(SINAL_POSICAO tendencia) {
   if (Objetivo1Condicao == OBJETIVO_ROMPIMENTO_LT) {   
      double volume = pegarProximoObjetivoVolume();
      if (volume > 0) {
         if (executarAumento(tendencia, volume))
            alterarOperacaoAtual();
      }
      else
         alterarOperacaoAtual();
   }
}

void verificarRompimentoLTB() {
   //if (_trade.getPosicaoAtual() == COMPRADO && t1TendenciaSR == ALTA && negociacaoAtual == ALTA && tamanhoLinhaTendencia >= 3) {
   if (_trade.getPosicaoAtual() == COMPRADO && negociacaoAtual == ALTA && tamanhoLinhaTendencia >= 3) {
      double posicaoLTB = autoTrend.posicaoLTB(ChartID(), t1VelaAtual.tempo);
      if (posicaoLTB > 0 && precoCompra > posicaoLTB && posicaoLTB >= t1VelaAtual.minima && posicaoLTB <= t1VelaAtual.maxima && precoCompra > t1VelaAnterior.maxima) {
         executarObjetivo(_trade.getPosicaoAtual());
      }
   }
}

void verificarRompimentoLTA() {
   //if (_trade.getPosicaoAtual() == VENDIDO && t1TendenciaSR == BAIXA && negociacaoAtual == BAIXA && tamanhoLinhaTendencia >= 3) {
   if (_trade.getPosicaoAtual() == VENDIDO && negociacaoAtual == BAIXA && tamanhoLinhaTendencia >= 3) {
      double posicaoLTA = autoTrend.posicaoLTA(ChartID(), t1VelaAtual.tempo);
      if (posicaoLTA > 0 && precoVenda < posicaoLTA && posicaoLTA >= t1VelaAtual.minima && posicaoLTA <= t1VelaAtual.maxima && precoVenda < t1VelaAnterior.minima) {
         executarObjetivo(_trade.getPosicaoAtual());
      }
   }
}

void verificarObjetivoFixo() {
   double preco = _trade.getPrecoEntrada();
   if (_trade.getPosicaoAtual() == COMPRADO) {
      if (operacaoAtual == SITUACAO_ABERTA || operacaoAtual == SITUACAO_BREAK_EVEN)
         preco += Objetivo1Posicao;
      else if (operacaoAtual == SITUACAO_OBJETIVO1) 
         preco += Objetivo2Posicao;
      else if (operacaoAtual == SITUACAO_OBJETIVO2)
         preco += Objetivo3Posicao;
      if (precoCompra >= preco)
         alterarOperacaoAtual();
   }
   else if (_trade.getPosicaoAtual() == VENDIDO) {
      if (operacaoAtual == SITUACAO_ABERTA || operacaoAtual == SITUACAO_BREAK_EVEN)
         preco -= Objetivo1Posicao;
      else if (operacaoAtual == SITUACAO_OBJETIVO1) 
         preco -= Objetivo2Posicao;
      else if (operacaoAtual == SITUACAO_OBJETIVO2)
         preco -= Objetivo3Posicao;
      if (precoVenda <= preco)
         alterarOperacaoAtual();
   }
}

void executarBreakEven() {
   if (_trade.getPosicaoAtual() == COMPRADO) {
      //if (operacaoAtual == SITUACAO_ABERTA && BreakEven > 0 && precoCompra >= (_trade.getPrecoEntrada() + BreakEven)) {
      if (BreakEven > 0 && precoCompra >= (_trade.getPrecoEntrada() + BreakEven)) {
         if (operacaoAtual == SITUACAO_ABERTA)
            operacaoAtual = SITUACAO_BREAK_EVEN;
         double sl = _trade.getPrecoEntrada() + BreakEvenValor;
         if (sl > _trade.getStopLoss()) {
            if (_trade.modificarPosicao(sl, 0))
               _logs.adicionarLog("Moving Stop to BreakEven in " + IntegerToString((int)_trade.getStopLoss()));
            else
               _logs.adicionarLog("Could not change Stop! Current StopLoss=" + IntegerToString((int)_trade.getStopLoss()));
         }
      }
   }
   else if (_trade.getPosicaoAtual() == VENDIDO) {
      //if (operacaoAtual == SITUACAO_ABERTA && BreakEven > 0 && precoVenda <= (_trade.getPrecoEntrada() - BreakEven)) {      
      if (BreakEven > 0 && precoVenda <= (_trade.getPrecoEntrada() - BreakEven)) {      
         if (operacaoAtual == SITUACAO_ABERTA)
            operacaoAtual = SITUACAO_BREAK_EVEN;
         double sl = _trade.getPrecoEntrada() - BreakEvenValor;
         if (sl < _trade.getStopLoss()) {
            if (_trade.modificarPosicao(sl, 0))
               _logs.adicionarLog("Moving Stop to BreakEven in " + IntegerToString((int)_trade.getStopLoss()));
            else
               _logs.adicionarLog("Could not change Stop! Current StopLoss=" + IntegerToString((int)_trade.getStopLoss()));
         }
      }
   }
}

void modificarStop() {
   double tickMinimo = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_SIZE);
   if (_trade.getPosicaoAtual() == COMPRADO) {
      double sl = pegarPosicaoStop(COMPRADO);
      sl = sl - MathMod(sl, tickMinimo);
      if (sl > _trade.getStopLoss() && sl < precoCompra) {
         if (_trade.modificarPosicao(sl, 0))
            _logs.adicionarLog("STOP changed to " + IntegerToString((int)_trade.getStopLoss()));
         else
            _logs.adicionarLog("Could not change Stop! Current StopLoss=" + IntegerToString((int)_trade.getStopLoss()));
      }
   }
   else if (_trade.getPosicaoAtual() == VENDIDO) {
      double sl = pegarPosicaoStop(VENDIDO);
      sl = sl - MathMod(sl, tickMinimo);
      if (sl < _trade.getStopLoss() && sl > precoVenda) {
         if (_trade.modificarPosicao(sl, 0))
            _logs.adicionarLog("STOP changed to " + IntegerToString((int)_trade.getStopLoss()));
         else
            _logs.adicionarLog("Could not change Stop! Current StopLoss=" + IntegerToString((int)_trade.getStopLoss()));
      }
   }
}

void desenharLinhaTendencia() {
   if (negociacaoAtual == ALTA)
      tamanhoLinhaTendencia = autoTrend.gerarLTB(ultimaLT, _Period, ChartID(), 15);
   else if (negociacaoAtual == BAIXA)   
      tamanhoLinhaTendencia = autoTrend.gerarLTA(ultimaLT, _Period, ChartID(), 15);
   else
      autoTrend.limparLinha(ChartID());
}

void atualizarPreco() {
   // Preço atual
   double tickMinimo = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   double preco = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   preco = NormalizeDouble(preco, _Digits);
   preco = preco - MathMod(preco, tickMinimo);
   if (preco != precoCompra)
      precoCompra = preco;
   
   preco = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   preco = NormalizeDouble(preco, _Digits);
   preco = preco - MathMod(preco, tickMinimo);
   if (preco != precoVenda)
      precoVenda = preco;
}

void atualizarSR(SINAL_TENDENCIA tendencia) {
   double preco = (tendencia == BAIXA) ? precoVenda : precoCompra;
   DADOS_SR dados[];
   
   t1sr.atualizar(dados);
   t1TendenciaSR = t1sr.tendenciaAtual(dados, preco);
   t1SuporteAtual = t1sr.suporteAtual(dados);
   t1ResistenciaAtual = t1sr.resistenciaAtual(dados);
   atualizarT1SRLabel();
   
   if (T2GraficoExtra) {
      atualizarT2SRLabel();
      t2sr.atualizar(dados);
      t2TendenciaSR = t2sr.tendenciaAtual(dados, preco);
      t2SuporteAtual = t2sr.suporteAtual(dados);
      t2ResistenciaAtual = t2sr.resistenciaAtual(dados);
      atualizarT2SRLabel();
   }
   
   if (T3GraficoExtra) {
      atualizarT3SRLabel();
      t3sr.atualizar(dados);
      t3TendenciaSR = t3sr.tendenciaAtual(dados, preco);
      t3SuporteAtual = t3sr.suporteAtual(dados);
      t3ResistenciaAtual = t3sr.resistenciaAtual(dados);
   }
}

bool verificarEntrada() {

   if(Bars(_Symbol,_Period)<100)
      return false;
    
   atualizarPreco();
      
   carregarVelaT1();
   carregarVelaT2();
   carregarVelaT3();

   if(t1NovaVela)
      tentativaCandle = false;
   if (tentativaCandle)
      return false;

   if(t1NovaVela) {
      atualizarSR(ALTA);
      SINAL_TENDENCIA tendencia = t1hilo.tendenciaAtual();
      if (tendencia != t1TendenciaHiLo) {
         if (CondicaoEntrada == HILO_CRUZ_MM_T1_TICK || CondicaoEntrada == HILO_CRUZ_MM_T1_FECHAMENTO) {
            negociacaoAtual = INDEFINIDA;
            atualizarNegociacaoAtual();
         }
         t1TendenciaHiLo = tendencia;
      }
   }

   // De acordo com cruzamento de média no HiLo
   if (t2NovaVela) {
      SINAL_TENDENCIA tendencia = t2hilo.tendenciaAtual();
      if (tendencia != t2TendenciaHiLo) {
         if (CondicaoEntrada == HILO_CRUZ_MM_T2_TICK || CondicaoEntrada == HILO_CRUZ_MM_T2_FECHAMENTO) {
            negociacaoAtual = INDEFINIDA;
            atualizarNegociacaoAtual();
         }
         t2TendenciaHiLo = tendencia;
      }
   }
   if (t3NovaVela) {
      SINAL_TENDENCIA tendencia = t3hilo.tendenciaAtual();
      if (tendencia != t3TendenciaHiLo) {
         if (CondicaoEntrada == HILO_CRUZ_MM_T3_TICK || CondicaoEntrada == HILO_CRUZ_MM_T3_FECHAMENTO) {
            negociacaoAtual = INDEFINIDA;
            atualizarNegociacaoAtual();
         }
         t3TendenciaHiLo = tendencia;
      }
   }

   if (CondicaoEntrada == HILO_CRUZ_MM_T1_TICK) {
      double mm = pegarMMT1();
      string nome = "arrow_" + TimeToString(t1VelaAtual.tempo);
      if (comprarCruzouHiLo(t1TendenciaHiLo, _Period, t1VelaAtual, t1VelaAnterior, mm)) {
         ObjectCreate(ChartID(), nome, OBJ_ARROW_UP, 0, t1VelaAtual.tempo, precoCompra);
         ObjectSetInteger(ChartID(), nome, OBJPROP_COLOR, clrLimeGreen); 
      }
      if (venderCruzouHiLo(t1TendenciaHiLo, _Period, t1VelaAtual, t1VelaAnterior, mm)) {
         ObjectCreate(ChartID(), nome, OBJ_ARROW_DOWN, 0, t1VelaAtual.tempo, precoVenda);
         ObjectSetInteger(ChartID(), nome, OBJPROP_COLOR, clrRed); 
      }
   }   
   else if (CondicaoEntrada == HILO_CRUZ_MM_T2_TICK) {
      double mm = pegarMMT2();
      string nome = "arrow_" + TimeToString(t2VelaAtual.tempo);
      if (comprarCruzouHiLo(t2TendenciaHiLo, T2TempoGrafico, t2VelaAtual, t2VelaAnterior, mm)) {
         ObjectCreate(t2chartid, nome, OBJ_ARROW_UP, 0, t2VelaAtual.tempo, precoCompra);
         ObjectSetInteger(t2chartid, nome, OBJPROP_COLOR, clrLimeGreen); 
      }
      if (venderCruzouHiLo(t2TendenciaHiLo, T2TempoGrafico, t2VelaAtual, t2VelaAnterior, mm)) {
         ObjectCreate(t2chartid, nome, OBJ_ARROW_DOWN, 0, t2VelaAtual.tempo, precoVenda);
         ObjectSetInteger(t2chartid, nome, OBJPROP_COLOR, clrRed); 
      }
   }
   else if (CondicaoEntrada == HILO_CRUZ_MM_T3_TICK) {
      double mm = pegarMMT3();
      string nome = "arrow_" + TimeToString(t3VelaAtual.tempo);
      if (comprarCruzouHiLo(t3TendenciaHiLo, T3TempoGrafico, t3VelaAtual, t3VelaAnterior, mm)) {
         ObjectCreate(t3chartid, nome, OBJ_ARROW_UP, 0, t3VelaAtual.tempo, precoCompra);
         ObjectSetInteger(t3chartid, nome, OBJPROP_COLOR, clrLimeGreen); 
      }
      if (venderCruzouHiLo(t3TendenciaHiLo, T3TempoGrafico, t3VelaAtual, t3VelaAnterior, mm)) {
         ObjectCreate(t3chartid, nome, OBJ_ARROW_DOWN, 0, t3VelaAtual.tempo, precoVenda);
         ObjectSetInteger(t3chartid, nome, OBJPROP_COLOR, clrRed); 
      }
   }
   else if (CondicaoEntrada == HILO_CRUZ_MM_T1_FECHAMENTO && t1NovaVela) {
      double mm = pegarMMT1();
      string nome = "arrow_" + TimeToString(t1VelaAtual.tempo);
      if (comprarCruzouHiLo(t1TendenciaHiLo, _Period, t1VelaAtual, t1VelaAnterior, mm)) {
         ObjectCreate(ChartID(), nome, OBJ_ARROW_UP, 0, t1VelaAtual.tempo, precoCompra);
         ObjectSetInteger(ChartID(), nome, OBJPROP_COLOR, clrLimeGreen); 
      }
      if (venderCruzouHiLo(t1TendenciaHiLo, _Period, t1VelaAtual, t1VelaAnterior, mm)) {
         ObjectCreate(ChartID(), nome, OBJ_ARROW_DOWN, 0, t1VelaAtual.tempo, precoVenda);
         ObjectSetInteger(ChartID(), nome, OBJPROP_COLOR, clrRed); 
      }
   }
   else if (CondicaoEntrada == HILO_CRUZ_MM_T2_FECHAMENTO && t2NovaVela) {
      double mm = pegarMMT2();
      string nome = "arrow_" + TimeToString(t2VelaAtual.tempo);
      if (comprarCruzouHiLo(t2TendenciaHiLo, T2TempoGrafico, t2VelaAtual, t2VelaAnterior, mm)) {
         ObjectCreate(t2chartid, nome, OBJ_ARROW_UP, 0, t2VelaAtual.tempo, precoCompra);
         ObjectSetInteger(t2chartid, nome, OBJPROP_COLOR, clrLimeGreen); 
      }
      if (venderCruzouHiLo(t2TendenciaHiLo, T2TempoGrafico, t2VelaAtual, t2VelaAnterior, mm)) {
         ObjectCreate(t2chartid, nome, OBJ_ARROW_DOWN, 0, t2VelaAtual.tempo, precoVenda);
         ObjectSetInteger(t2chartid, nome, OBJPROP_COLOR, clrRed); 
      }
   }
   else if (CondicaoEntrada == HILO_CRUZ_MM_T3_FECHAMENTO && t3NovaVela) {
      double mm = pegarMMT3();
      string nome = "arrow_" + TimeToString(t3VelaAtual.tempo);
      if (comprarCruzouHiLo(t3TendenciaHiLo, T3TempoGrafico, t3VelaAtual, t3VelaAnterior, mm)) {
         ObjectCreate(t3chartid, nome, OBJ_ARROW_UP, 0, t2VelaAtual.tempo, precoCompra);
         ObjectSetInteger(t3chartid, nome, OBJPROP_COLOR, clrLimeGreen); 
      }
      if (venderCruzouHiLo(t3TendenciaHiLo, T3TempoGrafico, t3VelaAtual, t3VelaAnterior, mm)) {
         ObjectCreate(t3chartid, nome, OBJ_ARROW_DOWN, 0, t2VelaAtual.tempo, precoVenda);
         ObjectSetInteger(t3chartid, nome, OBJPROP_COLOR, clrRed); 
      }
   }
   else if (CondicaoEntrada == APENAS_TENDENCIA_T1) {
      comprarNaTendencia(t1VelaAtual, t1VelaAnterior);
      venderNaTendencia(t1VelaAtual, t1VelaAnterior);
   }
   else if (CondicaoEntrada == APENAS_TENDENCIA_T2) {
      comprarNaTendencia(t2VelaAtual, t2VelaAnterior);
      venderNaTendencia(t2VelaAtual, t2VelaAnterior);
   }
   else if (CondicaoEntrada == APENAS_TENDENCIA_T3) {
      comprarNaTendencia(t3VelaAtual, t3VelaAnterior);
      venderNaTendencia(t3VelaAtual, t3VelaAnterior);
   }
   
   if (t1NovaVela && T1LinhaTendencia)
      desenharLinhaTendencia();

   iniciandoExecucaoCompra();
   iniciandoExecucaoVenda();
   
   //ObjectSetString(0, labelPosicaoAtual, OBJPROP_TEXT, labelPosicaoAtualTexto + "0.00");
   //ObjectSetString(0, labelPosicaoGeral, OBJPROP_TEXT, labelPosicaoGeralTexto +  + StringFormat("%.2f", _trade.precoAtual()));
   ObjectSetString(0, labelPosicaoAtual, OBJPROP_TEXT, "0.00");
   ObjectSetString(0, labelPosicaoGeral, OBJPROP_TEXT, StringFormat("%.2f", _trade.precoAtual()));
   
   return false;
}

bool verificarSaida() {
   
   atualizarPreco();
   
   carregarVelaT1();
   carregarVelaT2();
   carregarVelaT3();
   
   if(t1NovaVela)
      atualizarSR(negociacaoAtual);
   if(t2NovaVela)
      t2TendenciaHiLo = t2hilo.tendenciaAtual();
   if(t3NovaVela)
      t3TendenciaHiLo = t3hilo.tendenciaAtual();
      
   executarBreakEven();
   
   if (t1NovaVela) {
      desenharLinhaTendencia();
      modificarStop();
   }

   TIPO_OBJETIVO objetivo = OBJETIVO_NENHUM;
   if (operacaoAtual == SITUACAO_ABERTA || operacaoAtual == SITUACAO_BREAK_EVEN)
      objetivo = Objetivo1Condicao;
   else if (operacaoAtual == SITUACAO_OBJETIVO1)
      objetivo = Objetivo2Condicao;
   else if (operacaoAtual == SITUACAO_OBJETIVO2)
      objetivo = Objetivo3Condicao;
    
   if (objetivo == OBJETIVO_FIXO) {
      verificarObjetivoFixo();
   }  
   else if (objetivo == OBJETIVO_ROMPIMENTO_LT) {   
      verificarRompimentoLTB();
      verificarRompimentoLTA();
   }
   
   double precoOperacao = _trade.precoOperacaoAtual();
   if (MaxGainPosition > 0 && precoOperacao > MaxGainPosition)
      _trade.finalizarPosicao();
   
   //ObjectSetString(0, labelPosicaoAtual, OBJPROP_TEXT, labelPosicaoAtualTexto + StringFormat("%.2f", precoOperacao));
   //ObjectSetString(0, labelPosicaoGeral, OBJPROP_TEXT, labelPosicaoGeralTexto + StringFormat("%.2f", _trade.precoAtual()));
   ObjectSetString(0, labelPosicaoAtual, OBJPROP_TEXT, StringFormat("%.2f", precoOperacao));
   ObjectSetString(0, labelPosicaoGeral, OBJPROP_TEXT, StringFormat("%.2f", _trade.precoAtual()));
   return false;
}

double pegarMMT1() {
   double mm[1];
   if(CopyBuffer(MMT1Handle,0,0,1,mm) != 1) {
      Print("CopyBuffer from iMA failed, no data");
      return 0;
   }
   return mm[0];
}

double pegarMMT2() {
   double mm[1];
   if(CopyBuffer(MMT2Handle,0,0,1,mm) != 1) {
      Print("CopyBuffer from iMA failed, no data");
      return 0;
   }
   return mm[0];
}

double pegarMMT3() {
   double mm[1];
   if(CopyBuffer(MMT3Handle,0,0,1,mm) != 1) {
      Print("CopyBuffer from iMA failed, no data");
      return 0;
   }
   return mm[0];
}