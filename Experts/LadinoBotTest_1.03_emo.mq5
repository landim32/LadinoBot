//+------------------------------------------------------------------+
//|                                       LadinoBotTest_1.03_emo.mq5 |
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

// □ ■ ●
input const  string S01 = "■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■"; //■ HORÁRIOS DE FUNCIONAMENTO
input ENUM_HORARIO      HorarioEntrada = HORARIO_0900;                  // Start Time
input ENUM_HORARIO      HorarioFechamento = HORARIO_1700;               // Closing Time
input ENUM_HORARIO      HorarioSaida = HORARIO_1730;                    // Exit Time

input const  string S02 = "■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■"; //■ OPERACIONAL BÁSICO
input ENUM_OPERACAO     TipoOperacao = COMPRAR_VENDER;                  // Operation type
input ENUM_ATIVO        TipoAtivo = ATIVO_INDICE;                       // Asset type
input ENUM_RISCO        GestaoRisco = RISCO_NORMAL;                     // Risk management
input ENUM_ENTRADA      CondicaoEntrada = HILO_CRUZ_MM_T1_FECHAMENTO;   // Input condition
input double            ValorPonto = 0.2;                               // Value per point (R$)

input const  string S03 = "■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■"; //■ FINANCEIRO
input double            ValorCorretagem = 0.16;                         // Brokerage value
input int               GanhoMaximo = 99999;                            // Daily Max Gain
input int               PerdaMaxima = -99999     ;                      // Daily Max Loss
input double            GanhoMaximoPosicao = 999999;                    // Operation Max Gain

input const  string S04 = "■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■"; //■ GRÁFICO T1 (GRÁFICO PRINCIPAL)
input bool              T1LinhaTendencia = false;                       // T1 Use Trendline
input double            LTExtra = 0;                                    // T1 Trendline Extra
input bool              T1SRTendencia = false;                          // T1 Support and Resistance
input int               T1HiloPeriodo = 3;                              // T1 HiLo Periods
input bool              T1HiloTendencia = false;                        // T1 HiLo set Trend
input int               T1MM = 9;                                       // T1 Moving average

input const  string S05 = "■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■"; //■ GRÁFICO T2 (GRÁFICO SECUNDÁRIO)
input bool              T2GraficoExtra = false;                         // T2 Graph Extra
input ENUM_TIMEFRAMES   T2TempoGrafico = PERIOD_CURRENT;                // T2 Graph Time
input bool              T2SRTendencia = false;                          // T2 Support and Resistance
input int               T2HiloPeriodo = 13;                             // T2 HiLo Periods
input bool              T2HiloTendencia = false;                        // T2 HiLo set Trend
input int               T2MM = 9;                                       // T2 Moving average

input const  string S06 = "■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■"; //■ GRÁFICO T3 (GRÁFICO TERCIÁRIO)
input bool              T3GraficoExtra = false;                         // T3 Graph Extra
input ENUM_TIMEFRAMES   T3TempoGrafico = PERIOD_CURRENT;                // T3 Graph Time
input bool              T3SRTendencia = false;                          // T3 Support and Resistance
input bool              T3HiloAtivo = false;                            // T3 HiLo Active
input int               T3HiloPeriodo = 13;                             // T3 HiLo Periods
input bool              T3HiloTendencia = false;                        // T3 HiLo set Trend
input int               T3MM = 9;                                       // T3 Moving average

input const  string S07 = "■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■"; //■ OPÇÕES DE STOP LOSS
input double            StopLossMin = 0;                                // Stop Loss Min
input double            StopLossMax = 0;                                // Stop Loss Max 
input double            StopExtra = 0;                                  // Stop Extra
input ENUM_STOP         StopInicial = STOP_FIXO;                        // Stop Initial
input double            StopFixo = 0;                                   // Stop fixed value
input bool              ForcarEntrada = false;                          // Force entry
input bool              ForcarOperacao = false;                         // Force operation(verificar)

input const  string S08 = "■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■"; //■ AUMENTO DE POSIÇÃO
input bool              AumentoAtivo = false;                            // Run Position Increase
input double            AumentoStopExtra = 0;                           // Run Position Stop Extra
input int               AumentoMinimo = 0;                              // Run Position Increase Minimal

input const  string S09 = "■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■"; //■ OPÇÕES DE BREAK EVEN
input int               BreakEven = 0;                                  // Break Even Position
input int               BreakEvenValor = 0;                             // Break Even Value
input int               BreakEvenVolume = 0;                            // Break Even Volume

input const  string S10 = "■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■"; //■ OPÇÕES DE VOLUME
input int               InicialVolume = 1;                              // Initial Volume
input int               MaximoVolume = 2;                               // Max Volume

input const  string S11 = "■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■"; //■ OBJETIVO 1
input ENUM_OBJETIVO     ObjetivoCondicao1 = OBJETIVO_NENHUM;            // Goal 1 Condition
input int               ObjetivoVolume1 = 0;                            // Goal 1 Volume
input int               ObjetivoPosicao1 = 0;                           // Goal 1 Position
input ENUM_STOP         ObjetivoStop1 = STOP_FIXO;                      // Goal 1 Stop

input const  string S12 = "■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■"; //■ OBJETIVO 2
input ENUM_OBJETIVO     ObjetivoCondicao2 = OBJETIVO_NENHUM;            // Goal 2 Condition
input int               ObjetivoVolume2 = 0;                            // Goal 2 Volume
input int               ObjetivoPosicao2 = 0;                           // Goal 2 Position
input ENUM_STOP         ObjetivoStop2 = STOP_FIXO;                      // Goal 2 Stop

input const  string S13 = "■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■"; //■ OBJETIVO 3
input ENUM_OBJETIVO     ObjetivoCondicao3 = OBJETIVO_NENHUM;            // Goal 3 Condition
input int               ObjetivoVolume3 = 0;                            // Goal 3 Volume
input int               ObjetivoPosicao3 = 0;                           // Goal 3 Position
input ENUM_STOP         ObjetivoStop3 = STOP_FIXO;                      // Goal 3 Stop

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void inicializarParametro()
  {
//### HORÁRIOS DE FUNCIONAMENTO
   _ladinoBot.setHorarioEntrada(HorarioEntrada);         // Start Time
   _ladinoBot.setHorarioFechamento(HorarioFechamento);   // Closing Time
   _ladinoBot.setHorarioSaida(HorarioSaida);             // Exit Time


//### OPERACIONAL BÁSICO
   _ladinoBot.setTipoOperacao(TipoOperacao);             // Operation type
   _ladinoBot.setTipoAtivo(TipoAtivo);                   // Asset type
   _ladinoBot.setGestaoRisco(GestaoRisco);               // Risk management
   _ladinoBot.setCondicaoEntrada(CondicaoEntrada);       // Input condition


//### FINANCEIRO
   _ladinoBot.setValorCorretagem(ValorCorretagem);       // Brokerage value
   _ladinoBot.setValorPonto(ValorPonto);                 // Value per point
   _ladinoBot.setGanhoMaximo(GanhoMaximo);               // Daily Max Gain
   _ladinoBot.setPerdaMaxima(PerdaMaxima);               // Daily Max Loss
   _ladinoBot.setGanhoMaximoPosicao(GanhoMaximoPosicao); // Operation Max Gain


//### GRÁFICO T1 (GRÁFICO PRINCIPAL)
   _ladinoBot.setT1LinhaTendencia(T1LinhaTendencia);   // T1 Use Trendline
   _ladinoBot.setLTExtra(LTExtra);                     // T1 Trendline Extra
   _ladinoBot.setT1SRTendencia(T1SRTendencia);         // T1 Support and Resistance
   _ladinoBot.setT1HiloPeriodo(T1HiloPeriodo);         // T1 HiLo Periods
   _ladinoBot.setT1HiloTendencia(T1HiloTendencia);     // T1 HiLo set Trend
   _ladinoBot.setT1MM(T1MM);                           // T1 Moving average

//### GRÁFICO T2 (GRÁFICO SECUNDÁRIO)
   _ladinoBot.setT2GraficoExtra(T2GraficoExtra);       // T2 Graph Extra
   _ladinoBot.setT2TempoGrafico(T2TempoGrafico);       // T2 Graph Time
   _ladinoBot.setT2HiloPeriodo(T2HiloPeriodo);         // T2 HiLo Periods
   _ladinoBot.setT2HiloTendencia(T2HiloTendencia);     // T2 HiLo set Trend
   _ladinoBot.setT2SRTendencia(T2SRTendencia);         // T2 Support and Resistance
   _ladinoBot.setT2MM(T2MM);                           // T2 Moving average

//### GRÁFICO T3 (GRÁFICO TERCIÁRIO)
   _ladinoBot.setT3GraficoExtra(T3GraficoExtra);       // T3 Graph Extra
   _ladinoBot.setT3TempoGrafico(T3TempoGrafico);       // T3 Graph Time
   _ladinoBot.setT3HiloAtivo(T3HiloAtivo);             // T3 HiLo Active
   _ladinoBot.setT3HiloPeriodo(T3HiloPeriodo);         // T3 HiLo Periods
   _ladinoBot.setT3HiloTendencia(T3HiloTendencia);     // T3 HiLo set Trend
   _ladinoBot.setT3SRTendencia(T3SRTendencia);         // T3 Support and Resistance
   _ladinoBot.setT3MM(T3MM);                           // T3 Moving average

//### OPÇÕES DE STOP LOSS
   _ladinoBot.setStopLossMin(StopLossMin);             // Stop Min Loss
   _ladinoBot.setStopLossMax(StopLossMax);             // Stop Max Loss
   _ladinoBot.setStopExtra(StopExtra);                 // Stop Extra
   _ladinoBot.setStopInicial(StopInicial);             // Stop Initial
   _ladinoBot.setStopFixo(StopFixo);                   // Stop fixed value
   _ladinoBot.setForcarOperacao(ForcarOperacao);       // Force operation
   _ladinoBot.setForcarEntrada(ForcarEntrada);         // Force entry

//### AUMENTO DE POSIÇÃO
   _ladinoBot.setAumentoAtivo(AumentoAtivo);           // Run Position Increase
   _ladinoBot.setAumentoStopExtra(AumentoStopExtra);   // Run Position Stop Extra
   _ladinoBot.setAumentoMinimo(AumentoMinimo);         // Run Position Increase Minimal

//### OPÇÕES DE BREAK EVEN
   _ladinoBot.setBreakEven(BreakEven);                 // Break Even Position
   _ladinoBot.setBreakEvenValor(BreakEvenValor);       // Break Even Value
   _ladinoBot.setBreakEvenVolume(BreakEvenVolume);     // Break Even Volume

//### OPÇÕES DE VOLUME
   _ladinoBot.setInicialVolume(InicialVolume);         // Initial Volume
   _ladinoBot.setMaximoVolume(MaximoVolume);           // Max Volume

//### OBJETIVO 1
   _ladinoBot.setObjetivoCondicao1(ObjetivoCondicao1); // Goal 1 Condition
   _ladinoBot.setObjetivoVolume1(ObjetivoVolume1);     // Goal 1 Volume
   _ladinoBot.setObjetivoPosicao1(ObjetivoPosicao1);   // Goal 1 Position
   _ladinoBot.setObjetivoStop1(ObjetivoStop1);         // Goal 1 Stop

//### OBJETIVO 2
   _ladinoBot.setObjetivoCondicao2(ObjetivoCondicao2); // Goal 2 Condition
   _ladinoBot.setObjetivoVolume2(ObjetivoVolume2);     // Goal 2 Volume
   _ladinoBot.setObjetivoPosicao2(ObjetivoPosicao2);   // Goal 2 Position
   _ladinoBot.setObjetivoStop2(ObjetivoStop2);         // Goal 2 Stop

//### OBJETIVO 3
   _ladinoBot.setObjetivoCondicao3(ObjetivoCondicao3); // Goal 3 Condition
   _ladinoBot.setObjetivoVolume3(ObjetivoVolume3);     // Goal 3 Volume
   _ladinoBot.setObjetivoPosicao3(ObjetivoPosicao3);   // Goal 3 Position
   _ladinoBot.setObjetivoStop3(ObjetivoStop3);         // Goal 3 Stop

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
//EventSetTimer devem ser gerados com a periodicidade especificada.
   EventSetTimer(60);

//Remove grade no gráfico
   ChartSetInteger(0, CHART_SHOW_GRID, false);
//CHART_MODE — tipo de gráfico candle
   ChartSetInteger(0, CHART_MODE, CHART_CANDLES);
//CHART_AUTOSCROLL — modo de movimentação automática para a borda direita do gráfico.
   ChartSetInteger(0, CHART_AUTOSCROLL, true);

   _logs.inicializar();
   _logs.adicionarLog(INFO_INIT);

   inicializarParametro();
   _ladinoBot.criarStatusControls();
   _ladinoBot.inicializar();

   _logs.adicionarLog(INFO_INIT_SUCCESS);

   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//Especifica o terminal que é necessário para finalizar a geração de eventos do Timer.
   EventKillTimer();
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   _ladinoBot.onTick();
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTimer()
  {
   _ladinoBot.onTimer();
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double OnTester()
  {
   return _ladinoBot.onTester();
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTradeTransaction(
   const MqlTradeTransaction& trans,   // estrutura das transações de negócios
   const MqlTradeRequest&     request, // estrutura solicitada
   const MqlTradeResult&      result   // resultado da estrutura
)
  {
   _ladinoBot.aoNegociar(trans, request, result);
  }
//+------------------------------------------------------------------+
