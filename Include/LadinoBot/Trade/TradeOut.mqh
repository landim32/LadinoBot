//+------------------------------------------------------------------+
//|                                                    LadinoBot.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"

#include <LadinoBot/Strategies/Candlestick.mqh>
#include <LadinoBot/Strategies/SR.mqh>
#include <LadinoBot/Trade/TradeIn.mqh>

class TradeOut: public TradeIn {
   private:
   public:
      ENUM_STOP tipoStopAtual();
      double pegarPosicaoStop(ENUM_SINAL_POSICAO posicao);
      bool eTakeProfitT1(ENUM_OBJETIVO condicao);
      bool eTakeProfitT2(ENUM_OBJETIVO condicao);
      bool eTakeProfitT3(ENUM_OBJETIVO condicao);
      double pegarValorFibo(ENUM_OBJETIVO condicao, double preco);

      double pegarTakeProfitFibo(ENUM_SINAL_POSICAO tendencia, ENUM_TEMPO_GRAFICO tempo, ENUM_OBJETIVO condicao, double preco);
      void adicionarTakeProfitFibo(ENUM_SINAL_POSICAO tendencia, ENUM_OBJETIVO condicao, double preco, double posicao, double vol);
      void configurarTakeProfit(ENUM_SINAL_POSICAO tendencia, double preco);
      double pegarProximoObjetivoVolume();
      void verificarObjetivoFixo();
      void executarBreakEven();
      void modificarStop();
      void executarObjetivo(ENUM_SINAL_POSICAO tendencia);
      bool verificarSaida();
};

ENUM_STOP TradeOut::tipoStopAtual() {
   if (_operacaoAtual == SITUACAO_OBJETIVO1)
      return getObjetivoStop1();
   else if (_operacaoAtual == SITUACAO_OBJETIVO2)
      return getObjetivoStop2();
   else if (_operacaoAtual == SITUACAO_OBJETIVO3)
      return getObjetivoStop3();
   else
      return getStopInicial();
}

double TradeOut::pegarPosicaoStop(ENUM_SINAL_POSICAO posicao) {
   double posicaoStop = 0;
   ENUM_STOP tipoStop = tipoStopAtual();
   switch (tipoStop) {
      case STOP_FIXO:
         if (posicao == COMPRADO)
            posicaoStop = _precoCompra - getStopFixo();
         else if (posicao == VENDIDO)
            posicaoStop = _precoVenda + getStopFixo();
         break;
      case STOP_T1_TOPO_FUNDO:
         if (posicao == COMPRADO)
            posicaoStop = t1SuporteAtual;
         else if (posicao == VENDIDO)
            posicaoStop = t1ResistenciaAtual;
         break;
      case STOP_T2_TOPO_FUNDO:
         if (posicao == COMPRADO)
            posicaoStop = t2SuporteAtual;
         else if (posicao == VENDIDO)
            posicaoStop = t2ResistenciaAtual;
         break;
      case STOP_T3_TOPO_FUNDO:
         if (posicao == COMPRADO)
            posicaoStop = t3SuporteAtual;
         else if (posicao == VENDIDO)
            posicaoStop = t3ResistenciaAtual;
         break;
      case STOP_T1_HILO:
         posicaoStop = t1hilo.posicaoAtual();
         break;
      case STOP_T2_HILO:
         posicaoStop = t2hilo.posicaoAtual();
         break;
      case STOP_T3_HILO:
         posicaoStop = t3hilo.posicaoAtual();
         break;
      case STOP_T1_VELA_ATENRIOR:
         if (posicao == COMPRADO)
            posicaoStop = _t1VelaAnterior.minima;
         else if (posicao == VENDIDO)
            posicaoStop = _t1VelaAnterior.maxima;
         break;
      case STOP_T2_VELA_ATENRIOR:
         if (posicao == COMPRADO)
            posicaoStop = _t2VelaAnterior.minima;
         else if (posicao == VENDIDO)
            posicaoStop = _t2VelaAnterior.maxima;
         break;
      case STOP_T3_VELA_ATENRIOR:
         if (posicao == COMPRADO)
            posicaoStop = _t3VelaAnterior.minima;
         else if (posicao == VENDIDO)
            posicaoStop = _t3VelaAnterior.maxima;
         break;
      case STOP_T1_VELA_ATUAL:
         if (posicao == COMPRADO)
            posicaoStop = _t1VelaAtual.minima;
         else if (posicao == VENDIDO)
            posicaoStop = _t1VelaAtual.maxima;
         break;
      case STOP_T2_VELA_ATUAL:
         if (posicao == COMPRADO)
            posicaoStop = _t2VelaAtual.minima;
         else if (posicao == VENDIDO)
            posicaoStop = _t2VelaAtual.maxima;
         break;
      case STOP_T3_VELA_ATUAL:
         if (posicao == COMPRADO)
            posicaoStop = _t3VelaAtual.minima;
         else if (posicao == VENDIDO)
            posicaoStop = _t3VelaAtual.maxima;
         break;
   }
   if (posicao == COMPRADO) {
      if (_operacaoAtual == SITUACAO_ABERTA || _operacaoAtual == SITUACAO_BREAK_EVEN)
         posicaoStop -= getStopExtra();
      else
         posicaoStop -= getAumentoStopExtra();
   }
   else if (posicao == VENDIDO) {
      if (_operacaoAtual == SITUACAO_ABERTA || _operacaoAtual == SITUACAO_BREAK_EVEN)
         posicaoStop += getStopExtra();
      else
         posicaoStop += getAumentoStopExtra();
   }
   return posicaoStop;
}


bool TradeOut::eTakeProfitT1(ENUM_OBJETIVO condicao) {
   return (
      condicao == OBJETIVO_T1_FIBO_0382 ||
      condicao == OBJETIVO_T1_FIBO_0618 ||
      condicao == OBJETIVO_T1_FIBO_1000 ||
      condicao == OBJETIVO_T1_FIBO_1382 ||
      condicao == OBJETIVO_T1_FIBO_1618 ||
      condicao == OBJETIVO_T1_FIBO_2000 ||
      condicao == OBJETIVO_T1_FIBO_2618
   );
}

bool TradeOut::eTakeProfitT2(ENUM_OBJETIVO condicao) {
   return (
      condicao == OBJETIVO_T2_FIBO_0382 ||
      condicao == OBJETIVO_T2_FIBO_0618 ||
      condicao == OBJETIVO_T2_FIBO_1000 ||
      condicao == OBJETIVO_T2_FIBO_1382 ||
      condicao == OBJETIVO_T2_FIBO_1618 ||
      condicao == OBJETIVO_T2_FIBO_2000 ||
      condicao == OBJETIVO_T2_FIBO_2618
   );
}

bool TradeOut::eTakeProfitT3(ENUM_OBJETIVO condicao) {
   return (
      condicao == OBJETIVO_T3_FIBO_0382 ||
      condicao == OBJETIVO_T3_FIBO_0618 ||
      condicao == OBJETIVO_T3_FIBO_1000 ||
      condicao == OBJETIVO_T3_FIBO_1382 ||
      condicao == OBJETIVO_T3_FIBO_1618 ||
      condicao == OBJETIVO_T3_FIBO_2000 ||
      condicao == OBJETIVO_T3_FIBO_2618
   );
}


double TradeOut::pegarValorFibo(ENUM_OBJETIVO condicao, double preco) {
   double retorno = 0;
   switch (condicao) {
      case OBJETIVO_T1_FIBO_0382:
      case OBJETIVO_T2_FIBO_0382:
      case OBJETIVO_T3_FIBO_0382:
         retorno = preco * 0.382;
         break;
      case OBJETIVO_T1_FIBO_0618:
      case OBJETIVO_T2_FIBO_0618:
      case OBJETIVO_T3_FIBO_0618:
         retorno = preco * 0.618;
         break;
      case OBJETIVO_T1_FIBO_1000:
      case OBJETIVO_T2_FIBO_1000:
      case OBJETIVO_T3_FIBO_1000:
         retorno = preco;
         break;
      case OBJETIVO_T1_FIBO_1382:
      case OBJETIVO_T2_FIBO_1382:
      case OBJETIVO_T3_FIBO_1382:
         retorno = preco * 1.382;
         break;
      case OBJETIVO_T1_FIBO_1618:
      case OBJETIVO_T2_FIBO_1618:
      case OBJETIVO_T3_FIBO_1618:
         retorno = preco * 1.618;
         break;
      case OBJETIVO_T1_FIBO_2000:
      case OBJETIVO_T2_FIBO_2000:
      case OBJETIVO_T3_FIBO_2000:
         retorno = preco * 2;
         break;
      case OBJETIVO_T1_FIBO_2618:
      case OBJETIVO_T2_FIBO_2618:
      case OBJETIVO_T3_FIBO_2618:
         retorno = preco * 2.618;
         break;
      default:
         retorno = 0;
         break;
   }
   return retorno;
}

double TradeOut::pegarTakeProfitFibo(ENUM_SINAL_POSICAO tendencia, ENUM_TEMPO_GRAFICO tempo, ENUM_OBJETIVO condicao, double preco) {
   double suporteAtual = 0;
   double resistenciaAtual = 0;
   DADOS_SR dados[];
   if (tempo == T1) {
      t1sr.atualizar(dados);
      suporteAtual = t1sr.suporteAtual(dados);
      resistenciaAtual = t1sr.resistenciaAtual(dados);
   }
   else if (tempo == T2) {
      t2sr.atualizar(dados);
      suporteAtual = t2sr.suporteAtual(dados);
      resistenciaAtual = t2sr.resistenciaAtual(dados);
   }
   else if (tempo == T3) {
      t3sr.atualizar(dados);
      suporteAtual = t3sr.suporteAtual(dados);
      resistenciaAtual = t3sr.resistenciaAtual(dados);
   }
   
   double variacao = MathAbs(resistenciaAtual - suporteAtual);
   variacao = pegarValorFibo(condicao, variacao);
   if (variacao > 0) {
      if (tendencia == COMPRADO)
         return suporteAtual + variacao;
      else if (tendencia == VENDIDO)
         return resistenciaAtual - variacao;
   }
   return 0;
}

void TradeOut::adicionarTakeProfitFibo(ENUM_SINAL_POSICAO tendencia, ENUM_OBJETIVO condicao, double preco, double posicao, double vol) {

   double tp = 0;
   if (condicao == OBJETIVO_FIXO) {
      if (posicao > 0) {
         if (tendencia == COMPRADO)
            tp = preco + posicao;
         else if (tendencia == VENDIDO)
            tp = preco - posicao;
      }
   }
   else if (eTakeProfitT1(condicao)) {
      tp = pegarTakeProfitFibo(tendencia, T1, condicao, preco);      
   }
   else if (eTakeProfitT2(condicao)) {
      tp = pegarTakeProfitFibo(tendencia, T2, condicao, preco);      
   }
   else if (eTakeProfitT3(condicao)) {
      tp = pegarTakeProfitFibo(tendencia, T3, condicao, preco);
   }
   if (tp != 0) {
      if (vol > 0) {
         if (tendencia == COMPRADO)
            this.comprarTP(vol, tp);
         else if (tendencia == VENDIDO)
            this.venderTP(vol, tp);
      }
      else if (vol < 0) {
         if (tendencia == COMPRADO)
            this.venderTP(MathAbs(vol), tp);
         else if (tendencia == VENDIDO)
            this.comprarTP(MathAbs(vol), tp);
      }
   }
}

void TradeOut::configurarTakeProfit(ENUM_SINAL_POSICAO tendencia, double preco) {
   adicionarTakeProfitFibo(tendencia, getObjetivoCondicao1(), preco, getObjetivoPosicao1(), getObjetivoVolume1());
   adicionarTakeProfitFibo(tendencia, getObjetivoCondicao2(), preco, getObjetivoPosicao2(), getObjetivoVolume2());
   adicionarTakeProfitFibo(tendencia, getObjetivoCondicao3(), preco, getObjetivoPosicao3(), getObjetivoVolume3());
}


double TradeOut::pegarProximoObjetivoVolume() {
   if (_operacaoAtual == SITUACAO_ABERTA || _operacaoAtual == SITUACAO_BREAK_EVEN)
      return getObjetivoVolume1();
   else if (_operacaoAtual == SITUACAO_OBJETIVO1)
      return getObjetivoVolume2();
   else if (_operacaoAtual == SITUACAO_OBJETIVO2)
      return getObjetivoVolume3();
   else 
      return 0;
}


void TradeOut::verificarObjetivoFixo() {
   double preco = this.getPrecoEntrada();
   if (this.getPosicaoAtual() == COMPRADO) {
      if (_operacaoAtual == SITUACAO_ABERTA || _operacaoAtual == SITUACAO_BREAK_EVEN)
         preco += getObjetivoPosicao1();
      else if (_operacaoAtual == SITUACAO_OBJETIVO1) 
         preco += getObjetivoPosicao2();
      else if (_operacaoAtual == SITUACAO_OBJETIVO2)
         preco += getObjetivoPosicao3();
      if (_precoCompra >= preco)
         alterarOperacaoAtual();
   }
   else if (this.getPosicaoAtual() == VENDIDO) {
      if (_operacaoAtual == SITUACAO_ABERTA || _operacaoAtual == SITUACAO_BREAK_EVEN)
         preco -= getObjetivoPosicao1();
      else if (_operacaoAtual == SITUACAO_OBJETIVO1) 
         preco -= getObjetivoPosicao2();
      else if (_operacaoAtual == SITUACAO_OBJETIVO2)
         preco -= getObjetivoPosicao3();
      if (_precoVenda <= preco)
         alterarOperacaoAtual();
   }
}

void TradeOut::executarBreakEven() {
   if (this.getPosicaoAtual() == COMPRADO) {
      if (getBreakEven() > 0 && _precoCompra >= (this.getPrecoEntrada() + getBreakEven())) {
         if (_operacaoAtual == SITUACAO_ABERTA) {
            _operacaoAtual = SITUACAO_BREAK_EVEN;
         }
         double sl = this.getPrecoEntrada() + getBreakEvenValor();
         if (sl > this.getStopLoss()) {
            /*
            if (this.modificarPosicao(sl, 0)) {
               //escreverLog("Moving Stop to BreakEven in " + IntegerToString((int)this.getStopLoss()));
               escreverLog(StringFormat(INFO_MOVING_STOP_BREAKEVEN, this.getStopLoss()));
            }
            else {
               //escreverLog("Could not change Stop! Current StopLoss=" + IntegerToString((int)this.getStopLoss()));
               escreverLog(StringFormat(ERROR_MOVING_STOP_BREAKEVEN, this.getStopLoss()));
            }
            */
            if (this.getStopLossMin() > 0) {
               double preco = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
               double slMin = preco - this.getStopLossMin();
               if (slMin < sl) {
                  sl = slMin;
               }
            }
            this.modificarPosicao(sl, 0);
         }
      }
   }
   else if (this.getPosicaoAtual() == VENDIDO) {
      if (getBreakEven() > 0 && _precoVenda <= (this.getPrecoEntrada() - getBreakEven())) {      
         if (_operacaoAtual == SITUACAO_ABERTA) {
            _operacaoAtual = SITUACAO_BREAK_EVEN;
         }
         double sl = this.getPrecoEntrada() - getBreakEvenValor();
         if (sl < this.getStopLoss()) {
            /*
            if (this.modificarPosicao(sl, 0)) {
               //escreverLog("Moving Stop to BreakEven in " + IntegerToString((int)this.getStopLoss()));
               escreverLog(StringFormat(INFO_MOVING_STOP_BREAKEVEN, this.getStopLoss()));
            }
            else {
               //escreverLog("Could not change Stop! Current StopLoss=" + IntegerToString((int)this.getStopLoss()));
               escreverLog(StringFormat(ERROR_MOVING_STOP_BREAKEVEN, this.getStopLoss()));
            }
            */
            if (this.getStopLossMin() > 0) {
               double preco = SymbolInfoDouble(_Symbol, SYMBOL_BID);
               double slMin = preco + this.getStopLossMin();
               if (slMin > sl) {
                  sl = slMin;
               }
            }
            this.modificarPosicao(sl, 0);
         }
      }
   }
}

void TradeOut::modificarStop() {
   double tickMinimo = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_SIZE);
   if (this.getPosicaoAtual() == COMPRADO) {
      double sl = pegarPosicaoStop(COMPRADO);
      sl = sl - MathMod(sl, tickMinimo);
      if (sl > this.getStopLoss() && sl < _precoCompra) {
         /*
         if (this.modificarPosicao(sl, 0)) {
            //escreverLog("STOP changed to " + IntegerToString((int)this.getStopLoss()));
            escreverLog(StringFormat(INFO_STOP_CHANGED, (int)this.getStopLoss()));
         }
         else {
            //escreverLog("Could not change Stop! Current StopLoss=" + IntegerToString((int)this.getStopLoss()));
            escreverLog(StringFormat(ERROR_STOP_CHANGED, (int)this.getStopLoss()));
         }
         */
         if (this.getStopLossMin() > 0) {
            double preco = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
            if (sl < (preco - this.getStopLossMin())) {
               sl = preco - this.getStopLossMin();
            }
         }
         this.modificarPosicao(sl, 0);
      }
   }
   else if (this.getPosicaoAtual() == VENDIDO) {
      double sl = pegarPosicaoStop(VENDIDO);
      sl = sl - MathMod(sl, tickMinimo);
      if (sl < this.getStopLoss() && sl > _precoVenda) {
         /*
         if (this.modificarPosicao(sl, 0)) {
            //escreverLog("STOP changed to " + IntegerToString((int)this.getStopLoss()));
            escreverLog(StringFormat(INFO_STOP_CHANGED, (int)this.getStopLoss()));
         }
         else {
            //escreverLog("Could not change Stop! Current StopLoss=" + IntegerToString((int)this.getStopLoss()));
            escreverLog(StringFormat(ERROR_STOP_CHANGED, (int)this.getStopLoss()));
         }
         */
         if (this.getStopLossMin() > 0) {
            double preco = SymbolInfoDouble(_Symbol, SYMBOL_BID);
            if (sl > (preco + this.getStopLossMin())) {
               sl = preco + this.getStopLossMin();
            }
         }
         this.modificarPosicao(sl, 0);
      }
   }
}


bool TradeOut::verificarSaida() {
   
   atualizarPreco();
   
   carregarVelaT1();
   carregarVelaT2();
   carregarVelaT3();
   
   if(t1NovaVela) {
      atualizarSR(_negociacaoAtual);
   }
   if(t2NovaVela) {
      _t2TendenciaHiLo = t2hilo.tendenciaAtual();
   }
   if(t3NovaVela) {
      _t3TendenciaHiLo = t3hilo.tendenciaAtual();
   }
      
   executarBreakEven();
   
   if (t1NovaVela) {
      desenharLinhaTendencia();
      modificarStop();
   }

   ENUM_OBJETIVO objetivo = OBJETIVO_NENHUM;
   if (_operacaoAtual == SITUACAO_ABERTA || _operacaoAtual == SITUACAO_BREAK_EVEN) {
      objetivo = getObjetivoCondicao1();
   }
   else if (_operacaoAtual == SITUACAO_OBJETIVO1) {
      objetivo = getObjetivoCondicao2();
   }
   else if (_operacaoAtual == SITUACAO_OBJETIVO2) {
      objetivo = getObjetivoCondicao3();
   }
    
   if (objetivo == OBJETIVO_FIXO) {
      verificarObjetivoFixo();
   }  
   else if (objetivo == OBJETIVO_ROMPIMENTO_LT) {   
      verificarRompimentoLTB();
      verificarRompimentoLTA();
   }
   
   double precoOperacao = this.precoOperacaoAtual();
   if (getGanhoMaximoPosicao() > 0 && precoOperacao > getGanhoMaximoPosicao()) {
      this.finalizarPosicao();
   }
   
   atualizarPosicao(precoOperacao, this.precoAtual());
   return false;
}

void TradeOut::executarObjetivo(ENUM_SINAL_POSICAO tendencia) {
   if (getObjetivoCondicao1() == OBJETIVO_ROMPIMENTO_LT) {   
      double volume = pegarProximoObjetivoVolume();
      if (volume > 0) {
         if (executarAumento(tendencia, volume)) {
            alterarOperacaoAtual();
         }
      }
      else {
         alterarOperacaoAtual();
      }
   }
}