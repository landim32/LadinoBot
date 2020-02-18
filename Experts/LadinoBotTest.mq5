//+------------------------------------------------------------------+
//|                                                       Ladino.mq5 |
//|                                                   Rodrigo Landim |
//|                                        http://www.emagine.com.br |
//+------------------------------------------------------------------+
#property copyright     "Rodrigo Landim"
#property link          "http://www.emagine.com.br"
#property version       "1.03"
#property description   "Free Expert Advisor working using HiLo and MM starting the"
#property description   "operation when the HiLo change and MM cross the candle."

#include <Trade/Trade.mqh>
#include <LadinoBot/Utils.mqh>
#include <LadinoBot/Views/LogPanel.mqh>
#include <LadinoBot/LadinoBot.mqh>

LadinoBot _ladinoBot;

ENUM_HORARIO      HorarioEntrada = HORARIO_1000;                  // Start Time
ENUM_HORARIO      HorarioFechamento = HORARIO_1600;               // Closing Time
ENUM_HORARIO      HorarioSaida = HORARIO_1630;                    // Exit Time
ENUM_OPERACAO     TipoOperacao = COMPRAR_VENDER;                  // Operation type
ENUM_ATIVO        TipoAtivo = ATIVO_INDICE;                       // Asset type
ENUM_RISCO        GestaoRisco = RISCO_PROGRESSIVO;                // Risk management
ENUM_ENTRADA      CondicaoEntrada = HILO_CRUZ_MM_T1_TICK;         // Input condition
double            ValorCorretagem = 0.16;                         // Brokerage value
double            ValorPonto = 0.2;                               // Value per point

bool              T1LinhaTendencia = true;                        // T1 Use Trendline
bool              T1SRTendencia = true;                           // T1 Support and Resistance
int               T1HiloPeriodo = 13;                             // T1 HiLo Periods
bool              T1HiloTendencia = true;                         // T1 HiLo set Trend
int               T1MM = 9;                                       // T1 Moving average

bool              T2GraficoExtra = false;                         // T2 Graph Extra
ENUM_TIMEFRAMES   T2TempoGrafico = PERIOD_M20;                    // T2 Graph Time
int               T2HiloPeriodo = 13;                             // T2 HiLo Periods
bool              T2HiloTendencia = false;                        // T2 HiLo set Trend
bool              T2SRTendencia = false;                          // T2 Support and Resistance
int               T2MM = 9;                                       // T2 Moving average

bool              T3GraficoExtra = false;                         // T3 Graph Extra
ENUM_TIMEFRAMES   T3TempoGrafico = PERIOD_H2;                     // T3 Graph Time
bool              T3HiloAtivo = false;                            // T3 HiLo Active
int               T3HiloPeriodo = 5;                              // T3 HiLo Periods
bool              T3HiloTendencia = true;                         // T3 HiLo set Trend
bool              T3SRTendencia = false;                          // T3 Support and Resistance
int               T3MM = 9;                                       // T3 Moving average

double            StopLossMin = 30;                               // Stop Min Loss
double            StopLossMax = 50;                               // Stop Max Loss
double            StopExtra = 10;                                 // Stop Extra
ENUM_STOP         StopInicial = STOP_FIXO;                        // Stop Initial
double            StopFixo = 20;                                  // Stop fixed value
bool              ForcarOperacao = true;                          // Force operation
bool              ForcarEntrada = true;                           // Force entry

double            LTExtra = 10;                                   // Trendline Extra
int               GanhoMaximo = 1000;                             // Daily Max Gain
int               PerdaMaxima = -30;                              // Daily Max Loss
double            GanhoMaximoPosicao = 400;                       // Operation Max Gain
bool              AumentoAtivo = true;                            // Run Position Increase
double            AumentoStopExtra = 20;                          // Run Position Stop Extra
int               AumentoMinimo = 80;                             // Run Position Increase Minimal
int               BreakEven = 100;                                 // Break Even Position
int               BreakEvenValor = 0;                            // Break Even Value
int               BreakEvenVolume = 1;                            // Break Even Volume
int               InicialVolume = 2;                              // Initial Volume
int               MaximoVolume = 2;                               // Max Volume

ENUM_OBJETIVO     ObjetivoCondicao1 = OBJETIVO_FIXO;              // Goal 1 Condition
int               ObjetivoVolume1 = 1;                            // Goal 1 Volume
int               ObjetivoPosicao1 = 40;                          // Goal 1 Position
ENUM_STOP         ObjetivoStop1 = STOP_FIXO;                      // Goal 1 Stop
ENUM_OBJETIVO     ObjetivoCondicao2 = OBJETIVO_NENHUM;            // Goal 2 Condition
int               ObjetivoVolume2 = 1;                            // Goal 2 Volume
int               ObjetivoPosicao2 = 0;                           // Goal 2 Position
ENUM_STOP         ObjetivoStop2 = STOP_T1_HILO;                   // Goal 2 Stop
ENUM_OBJETIVO     ObjetivoCondicao3 = OBJETIVO_FIXO;              // Goal 3 Condition
int               ObjetivoVolume3 = 0;                            // Goal 3 Volume
int               ObjetivoPosicao3 = 0;                           // Goal 3 Position
ENUM_STOP         ObjetivoStop3 = STOP_T2_VELA_ATENRIOR;          // Goal 3 Stop

void inicializarParametro() {

   _ladinoBot.setHorarioEntrada(HorarioEntrada);
   _ladinoBot.setHorarioFechamento(HorarioFechamento);
   _ladinoBot.setHorarioSaida(HorarioSaida);
   _ladinoBot.setTipoOperacao(TipoOperacao);
   _ladinoBot.setTipoAtivo(TipoAtivo);
   _ladinoBot.setGestaoRisco(GestaoRisco);
   _ladinoBot.setCondicaoEntrada(CondicaoEntrada);
   _ladinoBot.setValorCorretagem(ValorCorretagem);
   _ladinoBot.setValorPonto(ValorPonto);

   _ladinoBot.setT1LinhaTendencia(T1LinhaTendencia);
   _ladinoBot.setT1SRTendencia(T1SRTendencia);
   _ladinoBot.setT1HiloPeriodo(T1HiloPeriodo);
   _ladinoBot.setT1HiloTendencia(T1HiloTendencia);
   _ladinoBot.setT1MM(T1MM);

   _ladinoBot.setT2GraficoExtra(T2GraficoExtra);
   _ladinoBot.setT2TempoGrafico(T2TempoGrafico);
   _ladinoBot.setT2HiloPeriodo(T2HiloPeriodo);
   _ladinoBot.setT2HiloTendencia(T2HiloTendencia);
   _ladinoBot.setT2SRTendencia(T2SRTendencia);
   _ladinoBot.setT2MM(T2MM);

   _ladinoBot.setT3GraficoExtra(T3GraficoExtra);
   _ladinoBot.setT3TempoGrafico(T3TempoGrafico);
   _ladinoBot.setT3HiloAtivo(T3HiloAtivo);
   _ladinoBot.setT3HiloPeriodo(T3HiloPeriodo);
   _ladinoBot.setT3HiloTendencia(T3HiloTendencia);
   _ladinoBot.setT3SRTendencia(T3SRTendencia);
   _ladinoBot.setT3MM(T3MM);

   _ladinoBot.setStopLossMin(StopLossMin);
   _ladinoBot.setStopLossMax(StopLossMax);
   _ladinoBot.setStopExtra(StopExtra);
   _ladinoBot.setStopInicial(StopInicial);
   _ladinoBot.setStopFixo(StopFixo);
   _ladinoBot.setForcarOperacao(ForcarOperacao);
   _ladinoBot.setForcarEntrada(ForcarEntrada);

   _ladinoBot.setLTExtra(LTExtra);
   _ladinoBot.setGanhoMaximo(GanhoMaximo);
   _ladinoBot.setPerdaMaxima(PerdaMaxima);
   _ladinoBot.setGanhoMaximoPosicao(GanhoMaximoPosicao);
   _ladinoBot.setAumentoAtivo(AumentoAtivo);
   _ladinoBot.setAumentoStopExtra(AumentoStopExtra);
   _ladinoBot.setAumentoMinimo(AumentoMinimo);
   _ladinoBot.setBreakEven(BreakEven);
   _ladinoBot.setBreakEvenValor(BreakEvenValor);
   _ladinoBot.setBreakEvenVolume(BreakEvenVolume);
   _ladinoBot.setInicialVolume(InicialVolume);
   _ladinoBot.setMaximoVolume(MaximoVolume);

   _ladinoBot.setObjetivoCondicao1(ObjetivoCondicao1);
   _ladinoBot.setObjetivoVolume1(ObjetivoVolume1);
   _ladinoBot.setObjetivoPosicao1(ObjetivoPosicao1);
   _ladinoBot.setObjetivoStop1(ObjetivoStop1);
   _ladinoBot.setObjetivoCondicao2(ObjetivoCondicao2);
   _ladinoBot.setObjetivoVolume2(ObjetivoVolume2);
   _ladinoBot.setObjetivoPosicao2(ObjetivoPosicao2);
   _ladinoBot.setObjetivoStop2(ObjetivoStop2);
   _ladinoBot.setObjetivoCondicao3(ObjetivoCondicao3);
   _ladinoBot.setObjetivoVolume3(ObjetivoVolume3);
   _ladinoBot.setObjetivoPosicao3(ObjetivoPosicao3);
   _ladinoBot.setObjetivoStop3(ObjetivoStop3);
}

int OnInit() {

   EventSetTimer(60); 

   ChartSetInteger(0, CHART_SHOW_GRID, false);
   ChartSetInteger(0, CHART_MODE, CHART_CANDLES);
   ChartSetInteger(0, CHART_AUTOSCROLL, true);
   
   _logs.inicializar();
   _logs.adicionarLog(INFO_INIT);
   
   inicializarParametro();
   _ladinoBot.criarStatusControls();
   _ladinoBot.inicializar();
   
   _logs.adicionarLog(INFO_INIT_SUCCESS);
   
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason) {
   EventKillTimer();
}

void OnTick() {
   _ladinoBot.onTick();
}

void OnTimer(){
   _ladinoBot.onTimer();
}

double OnTester() {
   return _ladinoBot.onTester();
}

void OnTradeTransaction( 
   const MqlTradeTransaction& trans,   // estrutura das transações de negócios 
   const MqlTradeRequest&     request, // estrutura solicitada 
   const MqlTradeResult&      result   // resultado da estrutura 
) {
   _ladinoBot.aoNegociar(trans, request, result);
}