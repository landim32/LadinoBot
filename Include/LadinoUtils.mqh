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