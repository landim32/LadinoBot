//+------------------------------------------------------------------+
//|                                                    AutoTrend.mqh |
//|                                                   Rodrigo Landim |
//|                                        http://www.emagine.com.br |
//+------------------------------------------------------------------+
#property copyright "Rodrigo Landim"
#property link      "http://www.emagine.com.br"

class AutoTrend {
   private:
   public:
      AutoTrend();
      ~AutoTrend();

      double posicaoLTB(long chart_id, datetime tempo);
      double posicaoLTA(long chart_id, datetime tempo);
      bool rompeuLTB(long chart_id, datetime tempo);
      bool rompeuLTA(long chart_id, datetime tempo);
      int gerarLTB(datetime inicio, ENUM_TIMEFRAMES periodo = PERIOD_M1, long chart_id = 0, int velas = 15);
      int gerarLTA(datetime inicio, ENUM_TIMEFRAMES periodo = PERIOD_M1, long chart_id = 0, int velas = 15);
      void limparLinha(long chart_id = 0);
      double ultimoSuporte(ENUM_TIMEFRAMES periodo = PERIOD_M1, long chart_id = 0, int velas = 15);
      double ultimaResistencia(ENUM_TIMEFRAMES periodo = PERIOD_M1, long chart_id = 0, int velas = 15);
};

double AutoTrend::posicaoLTB(long chart_id, datetime tempo) {
   string nome = "ltb_" + IntegerToString(chart_id);
   return ObjectGetValueByTime(chart_id, nome, tempo);
}

double AutoTrend::posicaoLTA(long chart_id, datetime tempo) {
   string nome = "lta_" + IntegerToString(chart_id);
   return ObjectGetValueByTime(chart_id, nome, tempo);
}

bool AutoTrend::rompeuLTB(long chart_id, datetime tempo) {
   double tickMinimo = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   double preco = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   preco = NormalizeDouble(preco, _Digits);
   preco = preco - MathMod(preco, tickMinimo);
   
   string nome = "ltb_" + IntegerToString(chart_id);
   double posicaoAtual = ObjectGetValueByTime(chart_id, nome, tempo);
   return preco > posicaoAtual;
}

bool AutoTrend::rompeuLTA(long chart_id, datetime tempo) {
   double tickMinimo = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   double preco = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   preco = NormalizeDouble(preco, _Digits);
   preco = preco - MathMod(preco, tickMinimo);
   
   string nome = "lta_" + IntegerToString(chart_id);
   double posicaoAtual = ObjectGetValueByTime(chart_id, nome, tempo);
   return preco < posicaoAtual;
}

int AutoTrend::gerarLTB(datetime inicio, ENUM_TIMEFRAMES periodo = PERIOD_M1, long chart_id = 0, int velas = 15) {

   MqlRates rt[];
   if(CopyRates(_Symbol, periodo, 0, velas, rt) != velas) {
      Print("CopyRates of ",_Symbol," failed, no history");
      return 0;
   }

   int velaEsquerdaIndex = 1;
   int velaDireitaIndex = ArraySize(rt) - 1;
   MqlRates velaEsquerda = rt[velaEsquerdaIndex];
   MqlRates velaDireita = rt[velaDireitaIndex];

   for (int i = 1; i < ArraySize(rt); i++) {
      if (rt[i].time < inicio) {
         velaEsquerda = rt[i];
         velaEsquerdaIndex = i;
      }
      else if (rt[i].high >= velaEsquerda.high) {
         velaEsquerda = rt[i];
         velaEsquerdaIndex = i;
      }
   }
   bool emBaixa = true;
   for (int i = velaEsquerdaIndex + 1; i < ArraySize(rt); i++) {
      if (emBaixa && (rt[i-1].high < rt[i].high))
         emBaixa = false;
      if (!emBaixa && (rt[i-1].high > rt[i].high)) {
         velaDireita = rt[i];
         velaDireitaIndex = i;
         break;
      }
   }
   
   ObjectDelete(chart_id, "lta_" + IntegerToString(chart_id));
   string nome = "ltb_" + IntegerToString(chart_id);
   if (ObjectFind(chart_id, nome) < 0) {
      if (ObjectCreate(chart_id, nome, OBJ_TREND, 0, velaEsquerda.time, velaEsquerda.high, velaDireita.time, velaDireita.high)) {
         ObjectSetInteger(chart_id, nome, OBJPROP_WIDTH, 2);
         ObjectSetInteger(chart_id, nome, OBJPROP_COLOR, clrRed);
         ObjectSetInteger(chart_id, nome, OBJPROP_RAY_RIGHT, true);
         ObjectSetInteger(chart_id, nome, OBJPROP_SELECTABLE, true);
      }
      else {
         Print("Erro ao criar a LTB.");
         return 0;
      }
   }
   else {
      ObjectMove(chart_id, nome, 0, velaEsquerda.time, velaEsquerda.high);
      ObjectMove(chart_id, nome, 1, velaDireita.time, velaDireita.high);
   }

   double posicaoAtual = 0;
   for (int i = velaEsquerdaIndex; i < velaDireitaIndex; i++) {
      posicaoAtual = ObjectGetValueByTime(0, nome, rt[i].time);
      if (posicaoAtual != 0 && posicaoAtual < rt[i].high) {
         ObjectMove(chart_id, nome, 1, rt[i].time, rt[i].high);
         ChartRedraw(chart_id);
      }
   }
   return velaDireitaIndex - velaEsquerdaIndex;
}

int AutoTrend::gerarLTA(datetime inicio, ENUM_TIMEFRAMES periodo = PERIOD_M1, long chart_id = 0, int velas = 15) {

   MqlRates rt[];
   if(CopyRates(_Symbol, periodo, 0, velas, rt) != velas) {
      Print("CopyRates of ",_Symbol," failed, no history");
      return 0;
   }

   int velaEsquerdaIndex = 1;
   int velaDireitaIndex = ArraySize(rt) - 1;
   MqlRates velaEsquerda = rt[velaEsquerdaIndex];
   MqlRates velaDireita = rt[velaDireitaIndex];

   for (int i = 1; i < ArraySize(rt); i++) {
      if (rt[i].time < inicio) {
         velaEsquerda = rt[i];
         velaEsquerdaIndex = i;
      }
      else if (rt[i].low <= velaEsquerda.low) {
         velaEsquerda = rt[i];
         velaEsquerdaIndex = i;
      }
   }
   //int emQueda = velaEsquerdaIndex;
   bool emAlta = true;
   for (int i = velaEsquerdaIndex + 1; i < ArraySize(rt); i++) {
      if (emAlta && (rt[i-1].low > rt[i].low))
         emAlta = false;
      if (!emAlta && (rt[i-1].low < rt[i].low)) {
         velaDireita = rt[i];
         velaDireitaIndex = i;
         break;
      }
   }
   
   ObjectDelete(chart_id, "ltb_" + IntegerToString(chart_id));
   string nome = "lta_" + IntegerToString(chart_id);
   if (ObjectFind(chart_id, nome) < 0) {
      if (ObjectCreate(chart_id, nome, OBJ_TREND, 0, velaEsquerda.time, velaEsquerda.low, velaDireita.time, velaDireita.low)) {
         ObjectSetInteger(chart_id, nome, OBJPROP_WIDTH, 2);
         ObjectSetInteger(chart_id, nome, OBJPROP_COLOR, clrGreen);
         ObjectSetInteger(chart_id, nome, OBJPROP_RAY_RIGHT, true);
         ObjectSetInteger(chart_id, nome, OBJPROP_SELECTABLE, true);
      }
      else {
         Print("Erro ao criar a LTA.");
         return 0;
      }
   }
   else {
      ObjectMove(chart_id, nome, 0, velaEsquerda.time, velaEsquerda.low);
      ObjectMove(chart_id, nome, 1, velaDireita.time, velaDireita.low);
   }

   double posicaoAtual = 0;
   for (int i = velaEsquerdaIndex; i < velaDireitaIndex; i++) {
      posicaoAtual = ObjectGetValueByTime(0, nome, rt[i].time);
      if (posicaoAtual != 0 && posicaoAtual > rt[i].low) {
         ObjectMove(chart_id, nome, 1, rt[i].time, rt[i].low);
         ChartRedraw(chart_id);
      }
   }
      
   return velaDireitaIndex - velaEsquerdaIndex;
}

void AutoTrend::limparLinha(long chart_id = 0) {
   ObjectDelete(chart_id, "lta_" + IntegerToString(chart_id));
   ObjectDelete(chart_id, "ltb_" + IntegerToString(chart_id));
}

double AutoTrend::ultimoSuporte(ENUM_TIMEFRAMES periodo = PERIOD_M1, long chart_id = 0, int velas = 15) {
   MqlRates rt[];
   if(CopyRates(_Symbol, periodo, 0, velas, rt) != velas) {
      Print("CopyRates of ",_Symbol," failed, no history");
      return 0;
   }
   double suporte = rt[ArraySize(rt) - 1].low;
   for (int i = ArraySize(rt) - 2; i >= 0; i--) {
      if (rt[i].low <= suporte)
         suporte = rt[i].low;
   }
   return suporte;
}

double AutoTrend::ultimaResistencia(ENUM_TIMEFRAMES periodo = PERIOD_M1, long chart_id = 0, int velas = 15) {
   MqlRates rt[];
   if(CopyRates(_Symbol, periodo, 0, velas, rt) != velas) {
      Print("CopyRates of ",_Symbol," failed, no history");
      return 0;
   }
   double resistencia = rt[ArraySize(rt) - 1].high;
   for (int i = ArraySize(rt) - 2; i >= 0; i--) {
      if (rt[i].high >= resistencia)
         resistencia = rt[i].high;
   }
   return resistencia;
}

AutoTrend::AutoTrend() {
}

AutoTrend::~AutoTrend() {
}
