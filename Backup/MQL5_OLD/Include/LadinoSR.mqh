//+------------------------------------------------------------------+
//|                                                     LadinoSR.mqh |
//|                                                   Rodrigo Landim |
//|                                        http://www.emagine.com.br |
//+------------------------------------------------------------------+
#property copyright "Rodrigo Landim"
#property link      "http://www.emagine.com.br"
#property version   "1.00"

#include "Utils.mqh"
//+------------------------------------------------------------------+
enum TIPO_SR {
   TIPO_SUPORTE,
   TIPO_RESISTENCIA
};
//+------------------------------------------------------------------+
struct DADOS_SR {
   int index;
   datetime data;
   double posicao;
   TIPO_SR tipo;
};
//+------------------------------------------------------------------+
class LadinoSR {
   private:
      ENUM_TIMEFRAMES _periodo;
      int MAX_CANDLE;
      int FractalHandle;
      SINAL_TENDENCIA tendenciaSR;
      double maximaDia;
      double minimaDia;
      double SellBuffer[];
      double BuyBuffer[];
   public:
      LadinoSR();
      ~LadinoSR();
      bool inicializar(ENUM_TIMEFRAMES periodo = PERIOD_CURRENT);
      bool atualizar(DADOS_SR& dados[]);
      double minimaDoDia();
      double maximaDoDia();
      SINAL_TENDENCIA tendenciaAtual(DADOS_SR& dados[], double preco);
      double suporteAtual(DADOS_SR& dados[]);
      double resistenciaAtual(DADOS_SR& dados[]);
      virtual void escreverLog(string msg);
};
//+------------------------------------------------------------------+
LadinoSR::LadinoSR() {
   //SRHandle = 0;
   tendenciaSR = INDEFINIDA;
   maximaDia = 0;
   minimaDia = 0;
   MAX_CANDLE = 100;
}

LadinoSR::~LadinoSR() {
}

bool LadinoSR::inicializar(ENUM_TIMEFRAMES periodo = PERIOD_CURRENT) {

   _periodo = periodo;

   FractalHandle = iFractals(_Symbol, _periodo);
   if(FractalHandle == INVALID_HANDLE) {
      Print("Erro ao criar indicador fractal.");
      return false;
   }
   return true;
}

bool LadinoSR::atualizar(DADOS_SR& dados[]) {

   const int inicio = 1;

   double resistencia[], suporte[];
   
   ArrayResize(resistencia, MAX_CANDLE);
   ArrayResize(suporte, MAX_CANDLE);
   ArrayFree(resistencia);
   ArrayFree(suporte);
   
   if (CopyBuffer(FractalHandle, 0, inicio, MAX_CANDLE, resistencia) <= 0) {
      Print("Erro ao criar indicador de suporte e resistência.");
      return false;
   }
   if (CopyBuffer(FractalHandle, 1, inicio, MAX_CANDLE, suporte) <= 0) {
      Print("Erro ao criar indicador de suporte e resistência.");
      return false;
   }
 
   MqlRates rt[];
   ArrayResize(rt, MAX_CANDLE);
   if(CopyRates(_Symbol, _periodo, inicio, MAX_CANDLE, rt) != MAX_CANDLE) {
      Print("CopyRates of ",_periodo," failed, no history");
      return false;
   }
   
   DADOS_SR dados2[];
   ArrayFree(dados2);
   int a = 0;
   double s = suporte[0];
   double r = resistencia[0];
   for (int i = 0; i < MAX_CANDLE; i++) {
      if (resistencia[i] != EMPTY_VALUE && resistencia[i] != r) {
         r = resistencia[i];
         if (resistencia[i] > 0) {
            ArrayResize(dados2, ArraySize(dados2) + 1);
            dados2[a].index = i;
            dados2[a].data = rt[i].time;
            dados2[a].posicao = NormalizeDouble(r, _Digits);
            dados2[a].tipo = TIPO_RESISTENCIA;
            a++;
         }         
      }
      if (suporte[i] != EMPTY_VALUE && suporte[i] != s) {
         s = suporte[i];
         if (suporte[i] > 0) {
            ArrayResize(dados2, ArraySize(dados2) + 1);
            dados2[a].index = i;
            dados2[a].data = rt[i].time;
            dados2[a].posicao = NormalizeDouble(s, _Digits);
            dados2[a].tipo = TIPO_SUPORTE;
            a++;
         }
      }
   }
   
   if (ArraySize(dados2) > 0) {
      a = -1;
      ArrayFree(dados);
      for (int i = 0; i < ArraySize(dados2); i++) {
         if (ArraySize(dados) > 0 && dados[a].tipo == dados2[i].tipo) {
            if ((dados[a].tipo == TIPO_RESISTENCIA && dados2[i].posicao > dados[a].posicao) ||
                (dados[a].tipo == TIPO_SUPORTE && dados2[i].posicao < dados[a].posicao)) {
               //ArrayResize(dados, ArraySize(dados) + 1);
               dados[a].index = dados2[i].index;
               dados[a].data = dados2[i].data;
               dados[a].posicao = dados2[i].posicao;
               dados[a].tipo = dados2[i].tipo;
               //a++;
            }
         }
         else {
            a++;
            ArrayResize(dados, ArraySize(dados) + 1);
            dados[a].index = dados2[i].index;
            dados[a].data = dados2[i].data;
            dados[a].posicao = dados2[i].posicao;
            dados[a].tipo = dados2[i].tipo;
         }
      }
   }
   
   /*
   string nome;
   for (int i = 1; i < ArraySize(dados); i++) {
      nome = "linha_" + IntegerToString((int)dados[i-1].posicao) + "_" + IntegerToString((int)dados[i].posicao);
      if (ObjectFind(0, nome) < 0) {
         if (!ObjectCreate(0, nome, OBJ_ARROWED_LINE, 0, dados[i-1].data, dados[i-1].posicao, dados[i].data, dados[i].posicao)) {
            Print("Error creating object: ",GetLastError());
         }
         else
            ChartRedraw(0);
      }
   }
   */
   
   return true;
}

double LadinoSR::minimaDoDia() {
   return minimaDia;
}

double LadinoSR::maximaDoDia() {
   return maximaDia;
}

SINAL_TENDENCIA LadinoSR::tendenciaAtual(DADOS_SR& dados[], double preco) {
   SINAL_TENDENCIA tendencia = INDEFINIDA;
   double sAtual = -1;
   double rAtual = -1;
   double sAnterior = -1;
   double rAnterior = -1;
   for (int i = ArraySize(dados) - 1; i >= 0; i--) {
      if (rAtual > 0 && rAnterior > 0 && sAtual > 0 && sAnterior > 0)
         break;
      if (dados[i].tipo == TIPO_RESISTENCIA) {
         if (rAtual > 0 && rAnterior < 0) 
            rAnterior = dados[i].posicao;
         else if (rAtual < 0) 
            rAtual = dados[i].posicao;
      }
      else if (dados[i].tipo == TIPO_SUPORTE) {
         if (sAtual > 0 && sAnterior < 0) 
            sAnterior = dados[i].posicao;
         else if (sAtual < 0) 
            sAtual = dados[i].posicao;
      }
   }
   if (sAtual > sAnterior && rAtual > rAnterior && preco > sAtual)
      tendencia = ALTA;
   if (sAtual < sAnterior && rAtual < rAnterior && preco < rAtual)
      tendencia = BAIXA;
   return tendencia;
}

double LadinoSR::suporteAtual(DADOS_SR& dados[]) {
   double suporte = -1;
   //for (int i = 0; i <= ArraySize(dados); i++) {
   for (int i = ArraySize(dados) - 1; i >= 0; i--) {
      if (dados[i].tipo == TIPO_SUPORTE) {
         suporte = dados[i].posicao;
         break;
      }
   }  
   return suporte;
}

double LadinoSR::resistenciaAtual(DADOS_SR& dados[]) {
   double resistencia = -1;
   //for (int i = 0; i <= ArraySize(dados); i++) {
   for (int i = ArraySize(dados) - 1; i >= 0; i--) {
      if (dados[i].tipo == TIPO_RESISTENCIA) {
         resistencia = dados[i].posicao;
         break;
      }
   }  
   return resistencia;
}

void LadinoSR::escreverLog(string msg){
   Print(msg);
}
