//+------------------------------------------------------------------+
//|                                                    LadinoBot.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <LadinoBot/Views/LogPanel.mqh>
#include <LadinoBot/Views/LadinoView.mqh>

LogPanel _logs;

class LadinoBot : public LadinoView {
   private:

   public:
      LadinoBot();
      
      void escreverLog(string msg);
      void aoAbrirPosicao();
      void aoFecharPosicao(double saldo);
      void aoAtingirGanhoMax();
      void aoAtingirPerdaMax();
};

LadinoBot::LadinoBot() {
}

void LadinoBot::escreverLog(string msg) {
   _logs.adicionarLog(msg);
}

void LadinoBot::aoAbrirPosicao() {
   _operacaoAtual = SITUACAO_ABERTA;
   tendenciaMudou = false;
   tentativaCandle = true;
}

void LadinoBot::aoFecharPosicao(double saldo) {
   _negociacaoAtual = INDEFINIDA;
   atualizarNegociacaoAtual();
   _operacaoAtual = SITUACAO_ABERTA;
}

void LadinoBot::aoAtingirGanhoMax() {
   //_logs.adicionarLog("Maximum gains achieved!");
   _logs.adicionarLog(INFO_MAXIMUM_GAIN);
   desativar();
}

void LadinoBot::aoAtingirPerdaMax() {
   //_logs.adicionarLog("Maximum loss achieved!");
   _logs.adicionarLog(INFO_MAXIMUM_LOSS);
   desativar();

}