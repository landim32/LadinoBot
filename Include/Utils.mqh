//+------------------------------------------------------------------+
//|                                                        Utils.mqh |
//|                                                   Rodrigo Landim |
//|                                        http://www.emagine.com.br |
//+------------------------------------------------------------------+
#property copyright "Rodrigo Landim"
#property link      "http://www.emagine.com.br"
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+

enum SENTIDO_OPERACAO {
   COMPRAR_VENDER,   // Buy and Sell
   APENAS_COMPRAR,   // Only Buy
   APENAS_VENDER     // Only Sell
};

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

enum SITUACAO_ROBO {
   INICIALIZADO,
   ATIVO,
   INATIVO,
   FECHANDO
};

enum SINAL_TENDENCIA {
   INDEFINIDA,
   ALTA,
   BAIXA
};

enum SINAL_POSICAO {
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
   
      //int chart_scale = (int)ChartGetInteger(0,CHART_SCALE);
      //int chart_width=(int)ChartGetInteger(0,CHART_WIDTH_IN_PIXELS,subwindow_number);
      //int chart_height=(int)ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS,subwindow_number);
   
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
      //ObjectSetString(0, name, OBJPROP_TOOLTIP, tooltip);
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
      
      
      /*
      fractalHandle = iFractals(_Symbol, TempoSecundario);
      if(fractalHandle == INVALID_HANDLE) {
         Print("Erro ao criar indicador fractal.");
         return false;
      }
      ChartIndicatorAdd(subchart_id, 0, fractalHandle); 
      */
      
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

/*
void criarLabelRect(string nome, string texto, int x, int y, int cor = clrWhite) {
   if (ObjectCreate(0, nome, OBJ_RECTANGLE_LABEL, 0, 0, 0)) {
      ObjectSetInteger(0, nome, OBJPROP_XDISTANCE, y);
      ObjectSetInteger(0, nome, OBJPROP_YDISTANCE, x);
      ObjectSetInteger(0, nome, OBJPROP_CORNER, CORNER_RIGHT_UPPER);
      ObjectSetInteger(0, nome, OBJPROP_ANCHOR, ANCHOR_RIGHT);
      ObjectSetInteger(0, nome, OBJPROP_COLOR, cor);
      ObjectSetString(0, nome, OBJPROP_TEXT, texto);
      ObjectSetString(0, nome, OBJPROP_FONT, "Tahoma");
      ObjectSetInteger(0, nome, OBJPROP_FONTSIZE, 8);
      ObjectSetInteger(0, nome, OBJPROP_SELECTABLE, false);   
   }
}
*/

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
         //retorno = (tempo.hour >= hora && tempo.min >= minuto);
         retorno = (segundos1 >= segundos2);
      break;   
      case IGUAL_OU_MENOR_QUE:   
         //retorno = (tempo.hour <= hora && tempo.min <= minuto);
         retorno = (segundos1 <= segundos2);
      break;   
      case MAIOR_QUE:   
         //retorno = (tempo.hour >= hora && tempo.min > minuto);
         retorno = (segundos1 > segundos2);
      break;   
      case MENOR_QUE:   
         //retorno = (tempo.hour <= hora && tempo.min < minuto);
         retorno = (segundos1 < segundos2);
      break;   
   }
   return retorno;
}