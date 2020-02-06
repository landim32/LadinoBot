//+------------------------------------------------------------------+
//|                                                        Utils.mqh |
//|                                                   Rodrigo Landim |
//|                                        http://www.emagine.com.br |
//+------------------------------------------------------------------+
#property copyright "Rodrigo Landim"
#property link      "http://www.emagine.com.br"
#property version   "0.81"

#include <LadinoBot/Languages/en.mqh>

const int VELA_VERIFICA_QUANTIDADE = 100;

enum ENUM_VELA_FORMATO {
   FORMATO_NENHUM,
   FORMATO_CURTA,
   FORMATO_LONGA,
   FORMATO_DOJI,
   FORMATO_MARTELO,
   FORMATO_MARTELO_INVERTIDO,
   FORMATO_MARIBOZU,
   FORMATO_MARIBOZU_LONGO,
   FORMATO_SPIN_TOP
};

enum ENUM_VELA_PADRAO {
   INDEFINIDO,
   INSIDE_CANDLE_ALTA,
   INSIDE_CANDLE_BAIXA,
   ENFORCADO,
   ESTRELA_CADENTE,
   MARTELO,
   MARTELO_INVERTIDO,
   BELT_HOLD_BULL,
   BELT_HOLD_BEAR
};

enum ENUM_VELA_TIPO {
   NENHUM,
   COMPRADORA,
   VENDEDORA
};

enum ENUM_OPERACAO {
   COMPRAR_VENDER,   // Buy and Sell
   APENAS_COMPRAR,   // Only Buy
   APENAS_VENDER     // Only Sell
};

/*
enum TIPO_OPERACAO {
   LIQUIDO,
   ROMPIMENTO,
   HILO,
   INSIDE_CANDLE,
   PRICE_ACTION,
   SCALPER,
   SCALPER_CONTRA,
   CRUZAMENTO_MM
};
*/

enum ENUM_SITUACAO_ROBO {
   INICIALIZADO,
   ATIVO,
   INATIVO,
   FECHANDO
};

enum ENUM_SINAL_TENDENCIA {
   INDEFINIDA,
   ALTA,
   BAIXA
};

enum ENUM_SINAL_POSICAO {
   NENHUMA,
   COMPRADO,
   VENDIDO
};

enum ENUM_HORARIO {
   HORARIO_0800, // 08:00
   HORARIO_0815, // 08:15
   HORARIO_0830, // 08:30
   HORARIO_0845, // 08:45
   HORARIO_0900, // 09:00
   HORARIO_0915, // 09:15
   HORARIO_0930, // 09:30
   HORARIO_0945, // 09:45
   HORARIO_1000, // 10:00
   HORARIO_1015, // 10:15
   HORARIO_1030, // 10:30
   HORARIO_1045, // 10:45
   HORARIO_1100, // 11:00
   HORARIO_1115, // 11:15
   HORARIO_1130, // 11:30
   HORARIO_1145, // 11:45
   HORARIO_1200, // 12:00
   HORARIO_1215, // 12:15
   HORARIO_1230, // 12:30
   HORARIO_1245, // 12:45
   HORARIO_1300, // 13:00
   HORARIO_1315, // 13:15
   HORARIO_1330, // 13:30
   HORARIO_1345, // 13:45
   HORARIO_1400, // 14:00
   HORARIO_1415, // 14:15
   HORARIO_1430, // 14:30
   HORARIO_1445, // 14:45
   HORARIO_1500, // 15:00
   HORARIO_1515, // 15:15
   HORARIO_1530, // 15:30
   HORARIO_1545, // 15:45
   HORARIO_1600, // 16:00
   HORARIO_1615, // 16:15
   HORARIO_1630, // 16:30
   HORARIO_1645, // 16:45
   HORARIO_1700, // 17:00
   HORARIO_1715, // 17:15
   HORARIO_1730, // 17:30
   HORARIO_1745, // 17:45
   HORARIO_1800  // 18:00
};

enum ENUM_HORARIO_CONDICAO {
   IGUAL_OU_MAIOR_QUE,
   IGUAL_OU_MENOR_QUE,
   MAIOR_QUE,
   MENOR_QUE
};

enum ENUM_TEMPO_GRAFICO {
   T1,
   T2,
   T3
};

enum ENUM_ENTRADA {
   HILO_CRUZ_MM_T1_TICK = 0,           // HiLo/MM T1 (Tick)
   HILO_CRUZ_MM_T2_TICK = 1,           // HiLo/MM T2 (Tick)
   HILO_CRUZ_MM_T3_TICK = 2,           // HiLo/MM T3 (Tick)
   HILO_CRUZ_MM_T1_FECHAMENTO = 3,     // HiLo/MM T1 (Close)
   HILO_CRUZ_MM_T2_FECHAMENTO = 4,     // HiLo/MM T2 (Close)
   HILO_CRUZ_MM_T3_FECHAMENTO = 5,     // HiLo/MM T3 (Close)
   APENAS_TENDENCIA_T1 = 12,           // Only Trend T1
   APENAS_TENDENCIA_T2 = 13,           // Only Trend T2
   APENAS_TENDENCIA_T3 = 14            // Only Trend T3
};

enum ENUM_RISCO {
   RISCO_NORMAL = 0,       // Normal
   RISCO_PROGRESSIVO = 1   // Progressive
};

enum ENUM_OBJETIVO {
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

enum ENUM_STOP {
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

enum ENUM_OPERACAO_SITUACAO {
   SITUACAO_ABERTA,
   SITUACAO_BREAK_EVEN,
   SITUACAO_OBJETIVO1,
   SITUACAO_OBJETIVO2,
   SITUACAO_OBJETIVO3,
   SITUACAO_FECHADA
};

enum ENUM_SR {
   TIPO_SUPORTE,
   TIPO_RESISTENCIA
};

enum ENUM_ATIVO {
   ATIVO_INDICE,  // Indice
   ATIVO_ACAO     // Stock
};

struct TRADE_POSICAO {
   double precoEntrada;
   double corretagem;
   double volumeInicial;
   double volumeAtual;
};

struct TRADE_FECHADO {
   datetime data;
   int sucesso;
   int falha;
   double corretagem;
   double financeiro;
};

struct DADOS_SR {
   int index;
   datetime data;
   double posicao;
   ENUM_SR tipo;
};

struct VELA {
   datetime tempo;
   double abertura;
   double maxima;
   double minima;
   double fechamento;
   double corpo;
   double pavil;
   double sombra_superior;
   double sombra_inferior;
   double tamanho;
   ENUM_SINAL_TENDENCIA tendencia;
   ENUM_VELA_TIPO tipo;
   ENUM_VELA_FORMATO formato;
};

datetime iTimeMQL4(string symbol,int tf,int index) {
   if(index < 0) return(-1);
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   datetime Arr[];
   if(CopyTime(symbol, timeframe, index, 1, Arr)>0)
        return(Arr[0]);
   else return(-1);
}

ENUM_TIMEFRAMES TFMigrate(int tf) {
   switch(tf) {
      case 0: return(PERIOD_CURRENT);
      case 1: return(PERIOD_M1);
      case 5: return(PERIOD_M5);
      case 15: return(PERIOD_M15);
      case 30: return(PERIOD_M30);
      case 60: return(PERIOD_H1);
      case 240: return(PERIOD_H4);
      case 1440: return(PERIOD_D1);
      case 10080: return(PERIOD_W1);
      case 43200: return(PERIOD_MN1);
      
      case 2: return(PERIOD_M2);
      case 3: return(PERIOD_M3);
      case 4: return(PERIOD_M4);      
      case 6: return(PERIOD_M6);
      case 10: return(PERIOD_M10);
      case 12: return(PERIOD_M12);
      case 16385: return(PERIOD_H1);
      case 16386: return(PERIOD_H2);
      case 16387: return(PERIOD_H3);
      case 16388: return(PERIOD_H4);
      case 16390: return(PERIOD_H6);
      case 16392: return(PERIOD_H8);
      case 16396: return(PERIOD_H12);
      case 16408: return(PERIOD_D1);
      case 32769: return(PERIOD_W1);
      case 49153: return(PERIOD_MN1);      
      default: return(PERIOD_CURRENT);
   }
}

bool calcularFibo(double origem, double destino, double &projecao[]) {
   double valores[];
   ArrayFree(valores);
   ArrayResize(valores, ArraySize(projecao));
   double saldo = (origem > destino) ? origem - destino : destino - origem;   
   
   for (int i = 0; i < ArraySize(valores); i++) {
      if (i == 0)
         valores[i] = saldo * 0.382;
      else if (i == 1)
         valores[i] = saldo * 0.618;
      else if (i == 2)
         valores[i] = saldo;
      else if (i == 3)
         valores[i] = saldo + (saldo * 0.618);
      else if (i > 3) 
         valores[i] = valores[i - 1] + valores[i - 2];
   }
   if (origem < destino) {
      for (int i = 0; i < ArraySize(projecao); i++)
         projecao[i] = destino - valores[i];
   }
   else {
      for (int i = 0; i < ArraySize(projecao); i++) 
         projecao[i] = destino + valores[i]; 
   }
   return true;
}

long novoGrafico(string nome, ENUM_TIMEFRAMES periodo = PERIOD_CURRENT, int largura = 320, int altura = 240, int x = 10, int y = 250) {
   long subChartId = 0;
   if( ObjectCreate(0, nome, OBJ_CHART, 0, 0, 0) ) {
   
      ObjectSetInteger(0,nome,OBJPROP_CORNER, CORNER_LEFT_LOWER);   // chart corner
      ObjectSetInteger(0,nome,OBJPROP_XDISTANCE, x);       // X-coordinate
      ObjectSetInteger(0,nome,OBJPROP_YDISTANCE, y);       // Y-coordinate
      ObjectSetInteger(0,nome,OBJPROP_XSIZE, largura);               // width
      ObjectSetInteger(0,nome,OBJPROP_YSIZE, altura);               // height
      ObjectSetInteger(0,nome,OBJPROP_CHART_SCALE, 4);
      ObjectSetInteger(0,nome,OBJPROP_DATE_SCALE, false);
      ObjectSetInteger(0,nome,OBJPROP_PRICE_SCALE, false);
      ObjectSetString(0, nome, OBJPROP_SYMBOL, _Symbol);
      ObjectSetInteger(0, nome, OBJPROP_PERIOD, periodo);
      ObjectSetInteger(0, nome, OBJPROP_BACK, false);
      ObjectSetInteger(0, nome, OBJPROP_SELECTABLE, false);
      ObjectSetInteger(0, nome, OBJPROP_COLOR, clrWhite);
      
      subChartId = ObjectGetInteger(0, nome, OBJPROP_CHART_ID);
      ChartSetInteger(subChartId, CHART_SHOW_GRID, false);
      ChartSetInteger(subChartId, CHART_MODE, CHART_CANDLES);
      ChartSetInteger(subChartId, CHART_AUTOSCROLL, true);
      ChartSetInteger(subChartId, CHART_SHOW_OHLC, false);           // OHLC
      ChartSetInteger(subChartId, CHART_SHOW_TRADE_LEVELS, true); // trade levels
      ChartSetInteger(subChartId, CHART_SHOW_BID_LINE, false);    // bid level
      ChartSetInteger(subChartId, CHART_SHOW_ASK_LINE, false);    // ask level
      ChartSetInteger(subChartId, CHART_COLOR_LAST, clrLimeGreen);       // color of the level of the last executed deal 
      ChartSetInteger(subChartId, CHART_COLOR_STOP_LEVEL, clrRed);       // color of Stop order levels 
      
      ChartRedraw(subChartId);
      ChartRedraw();
   }
   return subChartId;
}

void criarLabel(
   long chartId, 
   string nome, 
   string texto, 
   int x, int y, 
   string fonte = "Tahoma", 
   int size = 8, 
   int cor = clrWhiteSmoke, 
   int chart_corner = CORNER_RIGHT_UPPER,
   int anchor_point = ANCHOR_RIGHT
) {
   if (ObjectCreate(chartId, nome, OBJ_LABEL, 0, 0, 0)) {
      ObjectSetInteger(chartId, nome, OBJPROP_XDISTANCE, y);
      ObjectSetInteger(chartId, nome, OBJPROP_YDISTANCE, x);
      ObjectSetInteger(chartId, nome, OBJPROP_CORNER, chart_corner);
      ObjectSetInteger(chartId, nome, OBJPROP_ANCHOR, anchor_point);
      ObjectSetInteger(chartId, nome, OBJPROP_COLOR, cor);
      ObjectSetString(chartId, nome, OBJPROP_TEXT, texto);
      ObjectSetString(chartId, nome, OBJPROP_FONT, fonte);
      ObjectSetInteger(chartId, nome, OBJPROP_FONTSIZE, size);
      ObjectSetInteger(chartId, nome, OBJPROP_SELECTABLE, false);   
      ObjectSetInteger(chartId, nome, OBJPROP_HIDDEN, true);
   }
}

bool horarioCondicao(ENUM_HORARIO horario, ENUM_HORARIO_CONDICAO condicao) {
   int hora = 0, minuto = 0, segundos1 = 0, segundos2 = 0;
   MqlDateTime tempo;
   TimeToStruct(iTimeMQL4(_Symbol,_Period,0), tempo);
   switch (horario) {
      case HORARIO_0800:   hora = 8;   minuto = 0;    break;
      case HORARIO_0815:   hora = 8;   minuto = 15;   break;
      case HORARIO_0830:   hora = 8;   minuto = 30;   break;
      case HORARIO_0845:   hora = 8;   minuto = 45;   break;
      case HORARIO_0900:   hora = 9;   minuto = 0;    break;
      case HORARIO_0915:   hora = 9;   minuto = 15;   break;
      case HORARIO_0930:   hora = 9;   minuto = 30;   break;
      case HORARIO_0945:   hora = 9;   minuto = 45;   break;
      case HORARIO_1000:   hora = 10;  minuto = 0;    break;
      case HORARIO_1015:   hora = 10;  minuto = 15;   break;
      case HORARIO_1030:   hora = 10;  minuto = 30;   break;
      case HORARIO_1045:   hora = 10;  minuto = 45;   break;
      case HORARIO_1100:   hora = 11;  minuto = 0;    break;
      case HORARIO_1115:   hora = 11;  minuto = 15;   break;
      case HORARIO_1130:   hora = 11;  minuto = 30;   break;
      case HORARIO_1145:   hora = 11;  minuto = 45;   break;
      case HORARIO_1200:   hora = 12;  minuto = 0;    break;
      case HORARIO_1215:   hora = 12;  minuto = 15;   break;
      case HORARIO_1230:   hora = 12;  minuto = 30;   break;
      case HORARIO_1245:   hora = 12;  minuto = 45;   break;
      case HORARIO_1300:   hora = 13;  minuto = 0;    break;
      case HORARIO_1315:   hora = 13;  minuto = 15;   break;
      case HORARIO_1330:   hora = 13;  minuto = 30;   break;
      case HORARIO_1345:   hora = 13;  minuto = 45;   break;
      case HORARIO_1400:   hora = 14;  minuto = 0;    break;
      case HORARIO_1415:   hora = 14;  minuto = 15;   break;
      case HORARIO_1430:   hora = 14;  minuto = 30;   break;
      case HORARIO_1445:   hora = 14;  minuto = 45;   break;
      case HORARIO_1500:   hora = 15;  minuto = 0;    break;
      case HORARIO_1515:   hora = 15;  minuto = 15;   break;
      case HORARIO_1530:   hora = 15;  minuto = 30;   break;
      case HORARIO_1545:   hora = 15;  minuto = 45;   break;
      case HORARIO_1600:   hora = 16;  minuto = 0;    break;
      case HORARIO_1615:   hora = 16;  minuto = 15;   break;
      case HORARIO_1630:   hora = 16;  minuto = 30;   break;
      case HORARIO_1645:   hora = 16;  minuto = 45;   break;
      case HORARIO_1700:   hora = 17;  minuto = 0;    break;
      case HORARIO_1715:   hora = 17;  minuto = 15;   break;
      case HORARIO_1730:   hora = 17;  minuto = 30;   break;
      case HORARIO_1745:   hora = 17;  minuto = 15;   break;
      case HORARIO_1800:   hora = 18;  minuto = 0;    break;
      default: 
         return false;
         break;
   }
   segundos1 = (tempo.hour * 60 * 60) + (tempo.min * 60);
   segundos2 = (hora * 60 * 60) + (minuto * 60);
   bool retorno = false;
   switch (condicao) {
      case IGUAL_OU_MAIOR_QUE:   
         retorno = (segundos1 >= segundos2);
      break;   
      case IGUAL_OU_MENOR_QUE:   
         retorno = (segundos1 <= segundos2);
      break;   
      case MAIOR_QUE:   
         retorno = (segundos1 > segundos2);
      break;   
      case MENOR_QUE:   
         retorno = (segundos1 < segundos2);
      break;   
   }
   return retorno;
}

string MoneyToString(double money) {
   return StringFormat("%.2f", NormalizeDouble(money, 2));
}