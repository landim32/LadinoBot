//+------------------------------------------------------------------+
//|                                                   LadinoView.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"

#include <LadinoBot/Trade/TradeOut.mqh>

const string 
   labelPosicaoAtual = "labelPosicaoAtual", 
   labelPosicaoGeral = "labelPosicaoGeral", 
   labelNegociacaoAtual = "labelNegociacaoAtual",
   labelT1SR = "labelT1SR",
   labelT2SR = "labelT2SR",
   labelT3SR = "labelT3SR",
   labelPosicaoAtualTexto = "$+:",
   labelPosicaoGeralTexto = "$$:";

class LadinoView: public TradeOut {
   private:
      long _t2chartid, _t3chartid;
      int _MMT1Handle, _MMT2Handle, _MMT3Handle;
   public:
      LadinoView(void);
      
      double pegarMMT1();
      double pegarMMT2();
      double pegarMMT3();
      
      void atualizarNegociacaoAtual();
      void atualizarT1SRLabel();
      void atualizarT2SRLabel();
      void atualizarT3SRLabel();
      void criarStatusControls();
      void desenharLinhaTendencia();

      void desenharSetaCima(long chartId, datetime tempo, double preco);
      void desenharSetaBaixo(long chartId, datetime tempo, double preco);
      void t1DesenharSetaCima(datetime tempo, double preco);
      void t1DesenharSetaBaixo(datetime tempo, double preco);
      void t2DesenharSetaCima(datetime tempo, double preco);
      void t2DesenharSetaBaixo(datetime tempo, double preco);
      void t3DesenharSetaCima(datetime tempo, double preco);
      void t3DesenharSetaBaixo(datetime tempo, double preco);
      void inicializarPosicao();
      void atualizarPosicao(double precoOperacao, double precoAtual);
      
      int inicializarView();
};

LadinoView::LadinoView(void) {
   _MMT1Handle = 0; 
   _MMT2Handle = 0;
   _MMT3Handle = 0;
   
   _t2chartid = 0;
   _t3chartid = 0;
} 

double LadinoView::pegarMMT1() {
   double mm[1];
   if(CopyBuffer(_MMT1Handle,0,0,1,mm) != 1) {
      Print("CopyBuffer from iMA failed, no data");
      return 0;
   }
   return mm[0];
}

double LadinoView::pegarMMT2() {
   double mm[1];
   if(CopyBuffer(_MMT2Handle,0,0,1,mm) != 1) {
      Print("CopyBuffer from iMA failed, no data");
      return 0;
   }
   return mm[0];
}

double LadinoView::pegarMMT3() {
   double mm[1];
   if(CopyBuffer(_MMT3Handle,0,0,1,mm) != 1) {
      Print("CopyBuffer from iMA failed, no data");
      return 0;
   }
   return mm[0];
}

void LadinoView::atualizarNegociacaoAtual() {
   if (_negociacaoAtual == INDEFINIDA) {
      ObjectDelete(0, labelNegociacaoAtual);
      ObjectDelete(0, labelNegociacaoAtual + "Titulo");
   }
   else {
      if (ObjectFind(0, labelNegociacaoAtual) != 0)
         criarLabel(0, labelNegociacaoAtual, ".", 70, 40, "Wingdings", 12, clrWhiteSmoke);
      if (ObjectFind(0, labelNegociacaoAtual + "Titulo") != 0)
         criarLabel(0, labelNegociacaoAtual + "Titulo", "Trend", 70, 10, "Tahoma", 10, clrWhiteSmoke);
      if (_negociacaoAtual == ALTA) {
         ObjectSetString(0, labelNegociacaoAtual, OBJPROP_TEXT, CharToString(225));
         ObjectSetInteger(0, labelNegociacaoAtual, OBJPROP_COLOR, clrLimeGreen);
         ObjectSetString(0, labelNegociacaoAtual + "Titulo", OBJPROP_TEXT, "BUY");
         ObjectSetInteger(0, labelNegociacaoAtual + "Titulo", OBJPROP_COLOR, clrLimeGreen);
      }   
      else if (_negociacaoAtual == BAIXA) {
         ObjectSetString(0, labelNegociacaoAtual, OBJPROP_TEXT, CharToString(226));
         ObjectSetInteger(0, labelNegociacaoAtual, OBJPROP_COLOR, clrRed);
         ObjectSetString(0, labelNegociacaoAtual + "Titulo", OBJPROP_TEXT, "SELL");
         ObjectSetInteger(0, labelNegociacaoAtual + "Titulo", OBJPROP_COLOR, clrRed);
      }
   }
}

void LadinoView::atualizarT1SRLabel() {
   if (_t1TendenciaSR == INDEFINIDA) {
      ObjectDelete(0, labelT1SR);
      ObjectDelete(0, labelT1SR + "Titulo");
   }
   else {
      if (ObjectFind(0, labelT1SR) != 0)
         criarLabel(0, labelT1SR, ".", 31, 160, "Wingdings", 10);
      if (ObjectFind(0, labelT1SR + "Titulo") != 0)
         criarLabel(0, labelT1SR + "Titulo", "Top/Bottom", 30, 100);
      if (_t1TendenciaSR == ALTA) {
         ObjectSetString(0, labelT1SR, OBJPROP_TEXT, CharToString(225));
         ObjectSetInteger(0, labelT1SR, OBJPROP_COLOR, clrLimeGreen);
      }   
      else if (_t1TendenciaSR == BAIXA) {
         ObjectSetString(0, labelT1SR, OBJPROP_TEXT, CharToString(226));
         ObjectSetInteger(0, labelT1SR, OBJPROP_COLOR, clrRed);
      }
   }
}

void LadinoView::atualizarT2SRLabel() {
   int y = getT3GraficoExtra() ? 420 : 175;
   if (_t2TendenciaSR == INDEFINIDA) {
      ObjectDelete(0, labelT2SR);
      ObjectDelete(0, labelT2SR + "Titulo");
   }
   else {
      if (ObjectFind(0, labelT2SR) != 0)
         criarLabel(0, labelT2SR, ".", 220, y, "Wingdings", 10, clrWhiteSmoke, CORNER_LEFT_LOWER, ANCHOR_LEFT);
      if (ObjectFind(0, labelT2SR + "Titulo") != 0)
         criarLabel(0, labelT2SR + "Titulo", "Top/Bottom", 220, y + 15, "Tahoma", 8, clrWhiteSmoke, CORNER_LEFT_LOWER, ANCHOR_LEFT);
      if (_t2TendenciaSR == ALTA) {
         ObjectSetString(0, labelT2SR, OBJPROP_TEXT, CharToString(225));
         ObjectSetInteger(0, labelT2SR, OBJPROP_COLOR, clrLimeGreen);
      }   
      else if (_t2TendenciaSR == BAIXA) {
         ObjectSetString(0, labelT2SR, OBJPROP_TEXT, CharToString(226));
         ObjectSetInteger(0, labelT2SR, OBJPROP_COLOR, clrRed);
      }
   }
}

void LadinoView::atualizarT3SRLabel() {
   if (_t3TendenciaSR == INDEFINIDA) {
      ObjectDelete(0, labelT3SR);
      ObjectDelete(0, labelT3SR + "Titulo");
   }
   else {
      if (ObjectFind(0, labelT3SR) != 0)
         criarLabel(0, labelT3SR, ".", 220, 175, "Wingdings", 10, clrWhiteSmoke, CORNER_LEFT_LOWER, ANCHOR_LEFT);
      if (ObjectFind(0, labelT3SR + "Titulo") != 0)
         criarLabel(0, labelT3SR + "Titulo", "Top/Bottom", 220, 190, "Tahoma", 8, clrWhiteSmoke, CORNER_LEFT_LOWER, ANCHOR_LEFT);
      if (_t3TendenciaSR == ALTA) {
         ObjectSetString(0, labelT3SR, OBJPROP_TEXT, CharToString(225));
         ObjectSetInteger(0, labelT3SR, OBJPROP_COLOR, clrLimeGreen);
      }   
      else if (_t3TendenciaSR == BAIXA) {
         ObjectSetString(0, labelT3SR, OBJPROP_TEXT, CharToString(226));
         ObjectSetInteger(0, labelT3SR, OBJPROP_COLOR, clrRed);
      }
   }
}

void LadinoView::criarStatusControls() {
   criarLabel(0, labelPosicaoAtual + "Titulo", labelPosicaoAtualTexto, 30, 60);
   criarLabel(0, labelPosicaoAtual, "0.00", 30, 10);
   
   criarLabel(0, labelPosicaoGeral + "Titulo", labelPosicaoGeralTexto, 45, 60);
   criarLabel(0, labelPosicaoGeral, "0.00", 45, 10);
}

void LadinoView::desenharLinhaTendencia() {
   if (_negociacaoAtual == ALTA)
      _tamanhoLinhaTendencia = autoTrend.gerarLTB(ultimaLT, _Period, ChartID(), 15);
   else if (_negociacaoAtual == BAIXA)   
      _tamanhoLinhaTendencia = autoTrend.gerarLTA(ultimaLT, _Period, ChartID(), 15);
   else
      autoTrend.limparLinha(ChartID());
}

void LadinoView::desenharSetaCima(long chartId, datetime tempo, double preco) {
   string nome = "arrow_" + TimeToString(tempo);
   ObjectCreate(_t2chartid, nome, OBJ_ARROW_UP, 0, tempo, preco);
   ObjectSetInteger(_t2chartid, nome, OBJPROP_COLOR, clrLimeGreen);
}

void LadinoView::desenharSetaBaixo(long chartId, datetime tempo, double preco) {
   string nome = "arrow_" + TimeToString(tempo);
   ObjectCreate(_t2chartid, nome, OBJ_ARROW_DOWN, 0, tempo, preco);
   ObjectSetInteger(_t2chartid, nome, OBJPROP_COLOR, clrRed);
}

void LadinoView::t1DesenharSetaCima(datetime tempo, double preco) {
   desenharSetaCima(ChartID(), tempo, preco);
}

void LadinoView::t1DesenharSetaBaixo(datetime tempo, double preco) {
   desenharSetaBaixo(ChartID(), tempo, preco);
}

void LadinoView::t2DesenharSetaCima(datetime tempo, double preco) {
   desenharSetaCima(_t2chartid, tempo, preco);
}

void LadinoView::t2DesenharSetaBaixo(datetime tempo, double preco) {
   desenharSetaBaixo(_t2chartid, tempo, preco);
}

void LadinoView::t3DesenharSetaCima(datetime tempo, double preco) {
   desenharSetaCima(_t3chartid, tempo, preco);
}

void LadinoView::t3DesenharSetaBaixo(datetime tempo, double preco) {
   desenharSetaBaixo(_t3chartid, tempo, preco);
}

void LadinoView::inicializarPosicao() {
   ObjectSetString(0, labelPosicaoAtual, OBJPROP_TEXT, "0.00");
   ObjectSetString(0, labelPosicaoGeral, OBJPROP_TEXT, StringFormat("%.2f", this.precoAtual()));
}

void LadinoView::atualizarPosicao(double precoOperacao, double precoAtual) {
   ObjectSetString(0, labelPosicaoAtual, OBJPROP_TEXT, StringFormat("%.2f", precoOperacao));
   ObjectSetString(0, labelPosicaoGeral, OBJPROP_TEXT, StringFormat("%.2f", precoAtual));
}

int LadinoView::inicializarView() {
   if (getT2GraficoExtra()) {
      int y = (getT3GraficoExtra()) ? 255 : 10;
      _t2chartid = novoGrafico("grafico_secundario", getT2TempoGrafico(), 240, 200, y, 210);
   }
   if (getT3GraficoExtra())
      _t3chartid = novoGrafico("grafico_terciario", getT3TempoGrafico(), 240, 200, 10, 210);

   _MMT1Handle = iMA(_Symbol, _Period, getT1MM(), 0, MODE_EMA, PRICE_CLOSE);
   if(_MMT1Handle == INVALID_HANDLE) {
      Print("Error creating MMT1 indicator");
      return(INIT_FAILED);
   }
   ChartIndicatorAdd(ChartID(), 0, _MMT1Handle); 

   _MMT2Handle = iMA(_Symbol, getT2TempoGrafico(), getT2MM(), 0, MODE_EMA, PRICE_CLOSE);
   if(_MMT2Handle == INVALID_HANDLE) {
      Print("Error creating MMT2 indicator");
      return(INIT_FAILED);
   }
   ChartIndicatorAdd(_t2chartid, 0, _MMT2Handle); 

   _MMT3Handle = iMA(_Symbol, getT3TempoGrafico(), getT3MM(), 0, MODE_EMA, PRICE_CLOSE);
   if(_MMT3Handle == INVALID_HANDLE) {
      Print("Error creating MMT3 indicator");
      return(INIT_FAILED);
   }
   ChartIndicatorAdd(_t3chartid, 0, _MMT3Handle);
   
   if (t1hilo.inicializar(getT1HiloPeriodo(), _Period, ChartID())) {
      escreverLog("T1 HiLo initialized.");
   }
   else {
      escreverLog("T1 HiLo CANNOT be initialized.");
      return(INIT_FAILED);
   }

   if (getT2GraficoExtra()) {
      if (t2hilo.inicializar(getT2HiloPeriodo(), getT2TempoGrafico(), _t2chartid))
         escreverLog("T2 HiLo initialized.");
      else {
         escreverLog("T2 HiLo CANNOT be initialized.");
         return(INIT_FAILED);
      }
   }
      
   if (getT3GraficoExtra()) {
      if (t3hilo.inicializar(getT3HiloPeriodo(), getT3TempoGrafico(), _t3chartid))
         escreverLog("T3 HiLo initialized.");
      else {
         escreverLog("T3 HiLo CANNOT be initialized.");
         return(INIT_FAILED);
      }
   }
   
   return(INIT_SUCCEEDED);
}