//+------------------------------------------------------------------+
//|                                                   LadinoHiLo.mqh |
//|                                                   Rodrigo Landim |
//|                                        http://www.emagine.com.br |
//+------------------------------------------------------------------+
#property copyright "Rodrigo Landim"
#property link      "http://www.emagine.com.br"
#property version   "1.00"

#resource "\\Indicators\\gann_hi_lo_activator_ssl.ex5"

#include <Utils.mqh>

class LadinoHiLo {
   private:
      SINAL_TENDENCIA _tendenciaAtual;
      int HiLoHandle;
      int _periodo;
   public:
      LadinoHiLo();
      bool inicializar(int periodo = 4, ENUM_TIMEFRAMES tempoGrafico = PERIOD_CURRENT, long chartId = 0);
      double posicaoAtual();
      SINAL_TENDENCIA tendenciaAtual();
      bool verificarTendencia();
      virtual void onTendenciaMudou(SINAL_TENDENCIA novaTendencia);
};

LadinoHiLo::LadinoHiLo() {
   HiLoHandle = 0;
   _tendenciaAtual = INDEFINIDA;
   _periodo = 4;
}

bool LadinoHiLo::inicializar(int periodo = 4, ENUM_TIMEFRAMES tempoGrafico = PERIOD_CURRENT, long chartId = 0) {
   _periodo = periodo;
   HiLoHandle = iCustom(_Symbol, tempoGrafico, "::Indicators\\gann_hi_lo_activator_ssl", _periodo);
   if(HiLoHandle == INVALID_HANDLE) {
      Print("Error creating HiLo indicator");
      return false;
   }
   ChartIndicatorAdd(chartId, 0, HiLoHandle); 
   return true;
}

double LadinoHiLo::posicaoAtual() {
   double hiloBuffer[1];
   if(CopyBuffer(HiLoHandle,0,0,1,hiloBuffer)!=1) {
      Print("CopyBuffer from HiLo failed, no data");
      return -1;
   }
   return hiloBuffer[0];
}

SINAL_TENDENCIA LadinoHiLo::tendenciaAtual() {
   double hiloTendencia[1];
   if(CopyBuffer(HiLoHandle,4,0,1,hiloTendencia)!=1) {
      Print("CopyBuffer from HiLo failed, no data");
      return false;
   }
   if (hiloTendencia[0] > 0)
      return ALTA;
   else if (hiloTendencia[0] < 0) 
      return BAIXA;
   else
      return INDEFINIDA;
}

bool LadinoHiLo::verificarTendencia() {
   SINAL_TENDENCIA tendencia = tendenciaAtual();
   if (_tendenciaAtual != tendencia) {
      _tendenciaAtual = tendencia;
      onTendenciaMudou(_tendenciaAtual);
   }
   return true;
}

void LadinoHiLo::onTendenciaMudou(SINAL_TENDENCIA novaTendencia) {
   // 
}