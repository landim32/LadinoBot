//+------------------------------------------------------------------+
//|                                          LadinoConsolidation.mqh |
//|                                                   Rodrigo Landim |
//|                                        http://www.emagine.com.br |
//+------------------------------------------------------------------+
#property copyright "Rodrigo Landim"
#property link      "http://www.emagine.com.br"
#property version   "1.00"

#include <Utils.mqh>

const double SCALPER_TOLERANCIA = 10.0; //5.0;

struct CONSOLIDACAO {
   datetime inicial;
   datetime final;
   bool consolidado;
   double topo;
   double fundo;
};

class LadinoConsolidation {
   private:
      int retangulo_id;
      datetime candleTime;
      datetime primeiroRect;
      datetime ultimoRect;
      bool _estaConsolidado;
      CONSOLIDACAO consolidado;
   public:
      LadinoConsolidation();
      ~LadinoConsolidation();   
      double LadinoConsolidation::highCandle(MqlRates& rt[]);
      double LadinoConsolidation::lowCandle(MqlRates& rt[]);
      bool estaConsolidado(MqlRates& rt[], double candleHigh, double candleLow);
      CONSOLIDACAO verificarConsolidado();
      void tick(double _precoAtual = -1);
      void mudarCandle(datetime time);
      virtual void aoConsolidar(CONSOLIDACAO &consol);
      virtual void aoRomper(datetime time, double posicao, double topo, double fundo);
};

LadinoConsolidation::LadinoConsolidation(){
   ZeroMemory(consolidado);
   _estaConsolidado = false;
}

LadinoConsolidation::~LadinoConsolidation() {
}

double LadinoConsolidation::highCandle(MqlRates& rt[]) {
   double candleHigh = rt[0].high;
   for (int i = 0; i < ArraySize(rt) - 1; i++) {
      if (rt[i].high > candleHigh)
         candleHigh = rt[i].high;
   }
   return candleHigh;
}

double LadinoConsolidation::lowCandle(MqlRates& rt[]) {
   double candleLow = rt[0].low;
   for (int i = 0; i < ArraySize(rt) - 1; i++) {
      if (rt[i].low < candleLow)
         candleLow = rt[i].low;
   }
   return candleLow;
}

bool LadinoConsolidation::estaConsolidado(MqlRates& rt[], double candleHigh, double candleLow) {
   int pontos = 0;
   bool quadrante[4] = {false, false, false, false};
   for (int i = 0; i < ArraySize(rt) - 1; i++) {
      if (MathAbs(candleHigh - rt[i].high) <= SCALPER_TOLERANCIA) {
         if (i < MathFloor(ArraySize(rt) / 2))
            quadrante[0] = true;
         else
            quadrante[1] = true;
      }
      if (MathAbs(rt[i].low - candleLow) <= SCALPER_TOLERANCIA) {
         if (i < MathFloor(ArraySize(rt) / 2))
            quadrante[2] = true;
         else
            quadrante[3] = true;
      }
   }
   for (int i = 0; i < ArraySize(quadrante) - 1; i++)
      if (quadrante[i]) pontos++;
   if (pontos >= 3)
      return true;
   else
      return false;
}

CONSOLIDACAO LadinoConsolidation::verificarConsolidado() {
   CONSOLIDACAO consolidacao;
   consolidacao.consolidado = false;
   consolidacao.topo = 0;
   consolidacao.fundo = 0;
   MqlRates rt[10];
   if(CopyRates(_Symbol, _Period, 0, 10, rt) != 10) {
      Print("CopyRates of " + _Symbol + " failed, no history");
      return consolidacao;
   }
   //consolidacao.inicial = rt[0].time;
   //consolidacao.final = rt[7].time;
   
   MqlRates rtAnterior[2];
   MqlRates rt8[8];
   rtAnterior[0] = rt[0];
   rtAnterior[1] = rt[1];
   for (int i = 2; i < ArraySize(rt) - 1; i++)
      rt8[i-2] = rt[i];      
   double topo = highCandle(rt8);
   double fundo = lowCandle(rt8);
   if (
         estaConsolidado(rt8, topo, fundo) && (
         (rtAnterior[1].high > topo || rtAnterior[0].close > rtAnterior[1].close) ||
         (rtAnterior[1].low < fundo || rtAnterior[0].close < rtAnterior[1].close))
      ) {
      consolidacao.topo = topo;
      consolidacao.fundo = fundo;
      consolidacao.inicial = rt8[0].time;
      consolidacao.final = rt8[6].time + 60;
      if (((consolidacao.topo - consolidacao.fundo) < 120)) {
         consolidacao.consolidado = true;
         return consolidacao;
      }
   }
   
   MqlRates rt7[7];
   rtAnterior[0] = rt[1];
   rtAnterior[1] = rt[2];
   for (int i = 3; i < ArraySize(rt) - 1; i++)
      rt7[i-3] = rt[i];      
   topo = highCandle(rt7);
   fundo = lowCandle(rt7);
   if (
         estaConsolidado(rt7, topo, fundo) && (
         (rtAnterior[1].high > topo || rtAnterior[0].close > rtAnterior[1].close) ||
         (rtAnterior[1].low < fundo || rtAnterior[0].close < rtAnterior[1].close))
      ) {
      consolidacao.topo = topo;
      consolidacao.fundo = fundo;
      consolidacao.inicial = rt7[0].time;
      consolidacao.final = rt7[5].time + 60;
      if (((consolidacao.topo - consolidacao.fundo) < 110)) {
         consolidacao.consolidado = true;
         return consolidacao;
      }
      return consolidacao;
   }
   return consolidacao;
}

void LadinoConsolidation::tick(double _precoAtual = -1) {
   datetime _candleTime = iTimeMQL4(_Symbol,_Period,0);
   if (_estaConsolidado) { 
      if (_precoAtual <= 0)
         _precoAtual = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
      if (_precoAtual > consolidado.topo || _precoAtual < consolidado.fundo) {
         _estaConsolidado = false;
         ZeroMemory(consolidado);
         aoRomper(_candleTime, _precoAtual, consolidado.topo, consolidado.fundo);
      }
   }
   if(candleTime != _candleTime) {
      candleTime = _candleTime;
      mudarCandle(candleTime);
   }
}

void LadinoConsolidation::mudarCandle(datetime time) {
   if (_estaConsolidado) {
      string nome = "rectangle_" + IntegerToString(retangulo_id);
      if (ObjectFind(0, nome) >= 0) {
         if(!ObjectMove(0, nome, 1, time, consolidado.fundo))
            Print("Erro ao redimencionar o retangulo.");
         ChartRedraw();
      }
   }
   else {
      consolidado = verificarConsolidado();
      //if (consolidado.consolidado && !(OrdersTotal() > 0)) {
      if (consolidado.consolidado) {
         if (consolidado.inicial > ultimoRect) {
              
            _estaConsolidado = true;
            retangulo_id++;
            string nome = "rectangle_" + IntegerToString(retangulo_id);
            primeiroRect = consolidado.inicial;
            ultimoRect = consolidado.final;
            ObjectCreate(0, nome, OBJ_RECTANGLE, 0, primeiroRect, consolidado.topo + 5, ultimoRect, consolidado.fundo - 5);
            ChartRedraw();

            aoConsolidar(consolidado);
         }
      }
   }
}

void LadinoConsolidation::aoConsolidar(CONSOLIDACAO &consol) {
   //
}

void LadinoConsolidation::aoRomper(datetime time, double posicao, double topo, double fundo) {
   //
}