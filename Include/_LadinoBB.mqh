//+------------------------------------------------------------------+
//|                                                     LadinoBB.mqh |
//|                                                   Rodrigo Landim |
//|                                        http://www.emagine.com.br |
//+------------------------------------------------------------------+
#property copyright "Rodrigo Landim"
#property link      "http://www.emagine.com.br"
#property version   "1.00"

class LadinoBB {
   private:
      int BBHandle;
   public:
      LadinoBB();
      ~LadinoBB();
      bool inicializar();
      double topo();
      double meio();
      double fundo();
};
//+------------------------------------------------------------------+
LadinoBB::LadinoBB() {
   BBHandle = 0;
}

LadinoBB::~LadinoBB() {
};
//+------------------------------------------------------------------+
bool LadinoBB::inicializar() {
   BBHandle = iCustom(NULL, 0, "bb", 21);
   if(BBHandle == INVALID_HANDLE) {
      Print("Erro ao criar indicador de suporte e resistência.");
      return false;
   }
   ChartIndicatorAdd(ChartID(), 0, BBHandle); 
   return true;
}

double LadinoBB::topo() {
   double mm[1];
   if(CopyBuffer(BBHandle,1,0,1,mm) != 1) {
      Print("CopyBuffer from iMA failed, no data");
      return 0;
   }
   return mm[0];
}

double LadinoBB::meio() {
   double mm[1];
   if(CopyBuffer(BBHandle,0,0,1,mm) != 1) {
      Print("CopyBuffer from iMA failed, no data");
      return 0;
   }
   return mm[0];
}

double LadinoBB::fundo() {
   double mm[1];
   if(CopyBuffer(BBHandle,2,0,1,mm) != 1) {
      Print("CopyBuffer from iMA failed, no data");
      return 0;
   }
   return mm[0];
}
