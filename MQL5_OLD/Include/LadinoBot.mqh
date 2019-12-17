//+------------------------------------------------------------------+
//|                                                    LadinoBot.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <LogPanel.mqh>
#include <LadinoView.mqh>

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
   operacaoAtual = SITUACAO_ABERTA;
   tendenciaMudou = false;
   tentativaCandle = true;
}

void LadinoBot::aoFecharPosicao(double saldo) {
   //currentSL = 0;
   _negociacaoAtual = INDEFINIDA;
   atualizarNegociacaoAtual();
   //operacaoAtual = SITUACAO_FECHADA;
   operacaoAtual = SITUACAO_ABERTA;

}

void LadinoBot::aoAtingirGanhoMax() {
   _logs.adicionarLog("Maximum gains achieved!");
   desativar();
}

void LadinoBot::aoAtingirPerdaMax() {
   _logs.adicionarLog("Maximum loss achieved!");
   desativar();

}