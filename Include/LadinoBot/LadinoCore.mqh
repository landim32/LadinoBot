//+------------------------------------------------------------------+
//|                                                    LadinoBot.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"

#include <LadinoBot/Strategies/Candlestick.mqh>
#include <LadinoBot/Strategies/SR.mqh>
#include <LadinoBot/Strategies/AutoTrend.mqh>
#include <LadinoBot/LadinoBase.mqh>

class LadinoCore: public LadinoBase {
   private:
      double            _StopLossMin;
      double            _StopLossMax;
      double            _StopExtra;
      ENUM_STOP         _StopInicial;
      double            _StopFixo;
      int               _AumentoMinimo;

      bool              _T1LinhaTendencia;
      bool              _T1SRTendencia;
      int               _T1HiloPeriodo;
      bool              _T1HiloTendencia;
      int               _T1MM;

      bool              _T2GraficoExtra;
      ENUM_TIMEFRAMES   _T2TempoGrafico;
      int               _T2HiloPeriodo;
      bool              _T2HiloTendencia;
      bool              _T2SRTendencia;
      int               _T2MM;

      bool              _T3GraficoExtra;
      ENUM_TIMEFRAMES   _T3TempoGrafico;
      bool              _T3HiloAtivo;
      int               _T3HiloPeriodo;
      bool              _T3HiloTendencia;
      bool              _T3SRTendencia;
      int               _T3MM;

      double            _LTExtra;
      bool              _AumentoAtivo;
      double            _AumentoStopExtra;
      int               _BreakEven;
      int               _BreakEvenValor;
      //int               _BreakEvenVolume;

      ENUM_OBJETIVO     _ObjetivoCondicao1;
      ENUM_STOP         _ObjetivoStop1;
      ENUM_OBJETIVO     _ObjetivoCondicao2;
      ENUM_STOP         _ObjetivoStop2;
      ENUM_OBJETIVO     _ObjetivoCondicao3;
      ENUM_STOP         _ObjetivoStop3;

   protected:
      ENUM_SINAL_TENDENCIA 
         _negociacaoAtual,
         _t1TendenciaHiLo, _t2TendenciaHiLo, _t3TendenciaHiLo,
         _t1TendenciaSR, _t2TendenciaSR, _t3TendenciaSR;

      VELA 
         _t1VelaAtual, _t1VelaAnterior, _t1Vela3, _t1Vela4,
         _t2VelaAtual, _t2VelaAnterior, _t2Vela3, _t2Vela4,
         _t3VelaAtual, _t3VelaAnterior, _t3Vela3, _t3Vela4;
         
      double 
         t1SuporteAtual, t2SuporteAtual, t3SuporteAtual,
         t1ResistenciaAtual, t2ResistenciaAtual, t3ResistenciaAtual;
         
      bool t1NovaVela, t2NovaVela, t3NovaVela, tentativaCandle;
      datetime t1Candle, t2Candle, t3Candle;

      int               _tamanhoLinhaTendencia;
      
      AutoTrend         autoTrend;
      HiLo              t1hilo, t2hilo, t3hilo;
      Candlestick       candleStick;
      SR                t1sr, t2sr, t3sr;
      datetime          ultimaLT;
   public:
      LadinoCore(void);
      
      int inicializar();
      
      bool carregarVelaT1();
      bool carregarVelaT2();
      bool carregarVelaT3();
      
      bool internoCarregarVela(ENUM_TIMEFRAMES tempo, bool novaVela, VELA& velaAtual, VELA& velaAnterior, VELA& vela3, VELA& vela4);
      void atualizarSR(ENUM_SINAL_TENDENCIA tendencia);
      
      virtual int inicializarView();
      
      virtual void atualizarT1SRLabel();
      virtual void atualizarT2SRLabel();
      virtual void atualizarT3SRLabel();
      
      virtual void configurarTakeProfit(ENUM_SINAL_POSICAO tendencia, double preco);
      virtual void atualizarNegociacaoAtual();
      virtual double pegarPosicaoStop(ENUM_SINAL_POSICAO posicao);
      virtual void executarObjetivo(ENUM_SINAL_POSICAO tendencia);
      
      virtual double pegarMMT1();
      virtual double pegarMMT2();
      virtual double pegarMMT3();
      
      virtual void desenharLinhaTendencia();
      virtual void desenharSetaCima(long chartId, datetime tempo, double preco);
      virtual void desenharSetaBaixo(long chartId, datetime tempo, double preco);
      virtual void t1DesenharSetaCima(datetime tempo, double preco);
      virtual void t1DesenharSetaBaixo(datetime tempo, double preco);
      virtual void t2DesenharSetaCima(datetime tempo, double preco);
      virtual void t2DesenharSetaBaixo(datetime tempo, double preco);
      virtual void t3DesenharSetaCima(datetime tempo, double preco);
      virtual void t3DesenharSetaBaixo(datetime tempo, double preco);
      virtual void inicializarPosicao();
      virtual void atualizarPosicao(double precoOperacao, double precoAtual);
      
      bool getT1LinhaTendencia();
      void setT1LinhaTendencia(bool value);
      bool getT1SRTendencia();
      void setT1SRTendencia(bool value);
      int getT1HiloPeriodo();
      void setT1HiloPeriodo(int value);
      bool getT1HiloTendencia();
      void setT1HiloTendencia(bool value);
      int getT1MM();
      void setT1MM(int value);

      bool getT2GraficoExtra();
      void setT2GraficoExtra(bool value);
      ENUM_TIMEFRAMES getT2TempoGrafico();
      void setT2TempoGrafico(ENUM_TIMEFRAMES value);
      int getT2HiloPeriodo();
      void setT2HiloPeriodo(int value);
      bool getT2HiloTendencia();
      void setT2HiloTendencia(bool value);
      bool getT2SRTendencia();
      void setT2SRTendencia(bool value);
      int getT2MM();
      void setT2MM(int value);

      bool getT3GraficoExtra();
      void setT3GraficoExtra(bool value);
      ENUM_TIMEFRAMES getT3TempoGrafico();
      void setT3TempoGrafico(ENUM_TIMEFRAMES value);
      bool getT3HiloAtivo();
      void setT3HiloAtivo(bool value);
      int getT3HiloPeriodo();
      void setT3HiloPeriodo(int value);
      bool getT3HiloTendencia();
      void setT3HiloTendencia(bool value);
      bool getT3SRTendencia();
      void setT3SRTendencia(bool value);
      int getT3MM();
      void setT3MM(int value);

      double getStopLossMin();
      void setStopLossMin(double value);
      double getStopLossMax();
      void setStopLossMax(double value);
      double getStopExtra();
      void setStopExtra(double value);
      ENUM_STOP getStopInicial();
      void setStopInicial(ENUM_STOP value);
      double getStopFixo();
      void setStopFixo(double value);
      
      double getLTExtra();
      void setLTExtra(double value);
      bool getAumentoAtivo();
      void setAumentoAtivo(bool value);
      double getAumentoStopExtra();
      void setAumentoStopExtra(double value);
      int getAumentoMinimo();
      void setAumentoMinimo(int value);
      //int getBreakEven();
      //void setBreakEven(int value);
      int getBreakEvenValor();
      void setBreakEvenValor(int value);
      //int getBreakEvenVolume();
      //void setBreakEvenVolume(int value);

      ENUM_OBJETIVO getObjetivoCondicao1();
      void setObjetivoCondicao1(ENUM_OBJETIVO value);
      ENUM_STOP getObjetivoStop1();
      void setObjetivoStop1(ENUM_STOP value);
      ENUM_OBJETIVO getObjetivoCondicao2();
      void setObjetivoCondicao2(ENUM_OBJETIVO value);
      ENUM_STOP getObjetivoStop2();
      void setObjetivoStop2(ENUM_STOP value);
      ENUM_OBJETIVO getObjetivoCondicao3();
      void setObjetivoCondicao3(ENUM_OBJETIVO value);
      ENUM_STOP getObjetivoStop3();
      void setObjetivoStop3(ENUM_STOP value);
};

LadinoCore::LadinoCore(void) {
   /*
   _tamanhoLinhaTendencia = 0; 
   _negociacaoAtual = INDEFINIDA;
   _t1TendenciaHiLo = INDEFINIDA; 
   _t2TendenciaHiLo = INDEFINIDA; 
   _t3TendenciaHiLo = INDEFINIDA;
   _t1TendenciaSR = INDEFINIDA; 
   _t2TendenciaSR = INDEFINIDA; 
   _t3TendenciaSR = INDEFINIDA;
   t1SuporteAtual = 0;
   t2SuporteAtual = 0; 
   t3SuporteAtual = 0;
   t1ResistenciaAtual = 0; 
   t2ResistenciaAtual = 0; 
   t3ResistenciaAtual = 0;

   t1NovaVela = false; 
   t2NovaVela = false; 
   t3NovaVela = false;
   tentativaCandle = false;

   _T1LinhaTendencia = false;
   _T1SRTendencia = true;
   _T1HiloPeriodo = 13;
   _T1HiloTendencia = true;
   _T1MM = 9;

   _T2GraficoExtra = true;
   _T2TempoGrafico = PERIOD_H1;
   _T2HiloPeriodo = 13;
   _T2HiloTendencia = true;
   _T2SRTendencia = false;
   _T2MM = 9;

   _T3GraficoExtra = false;
   _T3TempoGrafico = PERIOD_H2;
   _T3HiloAtivo = true;
   _T3HiloPeriodo = 5;
   _T3HiloTendencia = true;
   _T3SRTendencia = false;
   _T3MM = 9;

   _StopLossMin = 30;
   _StopLossMax = 150;
   _StopExtra = 30;
   _StopInicial = STOP_T1_HILO;
   _StopFixo = 0;
   _ForcarOperacao = true;
   _ForcarEntrada = true;

   _LTExtra = 0;
   //_MaxGain = 100;
   //_MaxLoss = -30;
   //_MaxGainPosition = 100;
   _AumentoAtivo = false;
   _AumentoStopExtra = 20;
   _AumentoMinimo = 80;
   _BreakEven = 150;
   _BreakEvenValor = 50;
   _BreakEvenVolume = 0;

   _Objetivo1Condicao = OBJETIVO_FIXO;
   _Objetivo1Volume = -1;
   _Objetivo1Posicao = 600;
   _Objetivo1Stop = STOP_T1_HILO;
   _Objetivo2Condicao = OBJETIVO_FIXO;
   _Objetivo2Volume = 0;
   _Objetivo2Posicao = 0;
   _Objetivo2Stop = STOP_T2_HILO;
   _Objetivo3Condicao = OBJETIVO_FIXO;
   _Objetivo3Volume = 0;
   _Objetivo3Posicao = 0;
   _Objetivo3Stop = STOP_T2_VELA_ATENRIOR;
   */
}

int LadinoCore::inicializar(){
   this.inicializarView();
   
   if (!t1sr.inicializar(_Period))
      return(INIT_FAILED);
   if (!t2sr.inicializar(getT2TempoGrafico()))
      return(INIT_FAILED);
   if (!t3sr.inicializar(getT3TempoGrafico()))
      return(INIT_FAILED);
      
   this.inicializarBasico();
      
   return INIT_SUCCEEDED;
}

bool LadinoCore::internoCarregarVela(ENUM_TIMEFRAMES tempo, bool novaVela, VELA& velaAtual, VELA& velaAnterior, VELA& vela3, VELA& vela4) {
   ZeroMemory(velaAtual);
   ZeroMemory(velaAnterior);
   
   MqlRates rt[5];
   if(CopyRates(_Symbol, tempo, 0, 5, rt) != 5) {
      Print("CopyRates of ",_Symbol," failed, no history");
      return false;
   }
   if (novaVela) {
      if (
         candleStick.pegarVela(rt[3], velaAtual) && 
         candleStick.pegarVela(rt[2], velaAnterior) &&
         candleStick.pegarVela(rt[1], vela3) &&
         candleStick.pegarVela(rt[0], vela4)
      )
         return true;
   }
   else {
      if (
         candleStick.pegarVela(rt[4], velaAtual) && 
         candleStick.pegarVela(rt[3], velaAnterior) &&
         candleStick.pegarVela(rt[2], vela3) &&
         candleStick.pegarVela(rt[1], vela4)
      )
         return true;
   }
   return false;
}

bool LadinoCore::carregarVelaT1() {   
   t1NovaVela = false;
   datetime candleTime = iTimeMQL4(_Symbol, _Period, 0);
   if(t1Candle != candleTime) {
      t1NovaVela = true;
      t1Candle = candleTime;
   }
   return internoCarregarVela(_Period, t1NovaVela, _t1VelaAtual, _t1VelaAnterior, _t1Vela3, _t1Vela4);
}

bool LadinoCore::carregarVelaT2() {   
   t2NovaVela = false;
   datetime candleTime = iTimeMQL4(_Symbol, _T2TempoGrafico, 0);
   if(t2Candle != candleTime) {
      t2NovaVela = true;
      t2Candle = candleTime;
   }
   return internoCarregarVela(_T2TempoGrafico, t2NovaVela, _t2VelaAtual, _t2VelaAnterior, _t2Vela3, _t2Vela4);
}

bool LadinoCore::carregarVelaT3() {   
   t3NovaVela = false;
   datetime candleTime = iTimeMQL4(_Symbol, _T3TempoGrafico, 0);
   if(t3Candle != candleTime) {
      t3NovaVela = true;
      t3Candle = candleTime;
   }
   return internoCarregarVela(_T3TempoGrafico, t3NovaVela, _t3VelaAtual, _t3VelaAnterior, _t3Vela3, _t3Vela4);
}

void LadinoCore::atualizarSR(ENUM_SINAL_TENDENCIA tendencia) {
   double preco = (tendencia == BAIXA) ? _precoVenda : _precoCompra;
   DADOS_SR dados[];
   
   t1sr.atualizar(dados);
   _t1TendenciaSR = t1sr.tendenciaAtual(dados, preco);
   t1SuporteAtual = t1sr.suporteAtual(dados);
   t1ResistenciaAtual = t1sr.resistenciaAtual(dados);
   atualizarT1SRLabel();
   
   if (_T2GraficoExtra) {
      t2sr.atualizar(dados);
      _t2TendenciaSR = t2sr.tendenciaAtual(dados, preco);
      t2SuporteAtual = t2sr.suporteAtual(dados);
      t2ResistenciaAtual = t2sr.resistenciaAtual(dados);
      atualizarT2SRLabel();
   }
   
   if (_T3GraficoExtra) {
      atualizarT3SRLabel();
      t3sr.atualizar(dados);
      _t3TendenciaSR = t3sr.tendenciaAtual(dados, preco);
      t3SuporteAtual = t3sr.suporteAtual(dados);
      t3ResistenciaAtual = t3sr.resistenciaAtual(dados);
   }
}

int LadinoCore::inicializarView() {
   return INIT_SUCCEEDED;
}

void LadinoCore::atualizarT1SRLabel() {
   // nada
}

void LadinoCore::atualizarT2SRLabel() {
   // nada
}

void LadinoCore::atualizarT3SRLabel() {
   // nada
}

void LadinoCore::configurarTakeProfit(ENUM_SINAL_POSICAO tendencia, double preco) {
   //nada
}

void LadinoCore::atualizarNegociacaoAtual() {
   //nada
}

double LadinoCore::pegarPosicaoStop(ENUM_SINAL_POSICAO posicao) {
   return EMPTY_VALUE;
}

void LadinoCore::executarObjetivo(ENUM_SINAL_POSICAO tendencia) {
   //nada
}

double LadinoCore::pegarMMT1() {
   return EMPTY_VALUE;
}

double LadinoCore::pegarMMT2() {
   return EMPTY_VALUE;
}

double LadinoCore::pegarMMT3() {
   return EMPTY_VALUE;
}

void LadinoCore::desenharLinhaTendencia() {
   //nada
}

void LadinoCore::desenharSetaCima(long chartId, datetime tempo, double preco) {
   //nada
}

void LadinoCore::desenharSetaBaixo(long chartId, datetime tempo, double preco) {
   //nada
}

void LadinoCore::t1DesenharSetaCima(datetime tempo, double preco) {
   //nada
}

void LadinoCore::t1DesenharSetaBaixo(datetime tempo, double preco) {
   //nada
}

void LadinoCore::t2DesenharSetaCima(datetime tempo, double preco) {
   //nada
}

void LadinoCore::t2DesenharSetaBaixo(datetime tempo, double preco) {
   //nada
}

void LadinoCore::t3DesenharSetaCima(datetime tempo, double preco) {
   //nada
}

void LadinoCore::t3DesenharSetaBaixo(datetime tempo, double preco) {
   //nada
}

void LadinoCore::inicializarPosicao() {
   //nada
}

void LadinoCore::atualizarPosicao(double precoOperacao, double precoAtual) {
   //nada
}

bool LadinoCore::getT1LinhaTendencia() {
   return _T1LinhaTendencia;
}

void LadinoCore::setT1LinhaTendencia(bool value) {
   _T1LinhaTendencia = value;
}

bool LadinoCore::getT1SRTendencia() {
   return _T1SRTendencia;
}

void LadinoCore::setT1SRTendencia(bool value) {
   _T1SRTendencia = value;
}

int LadinoCore::getT1HiloPeriodo() {
   return _T1HiloPeriodo;
}

void LadinoCore::setT1HiloPeriodo(int value) {
   _T1HiloPeriodo = value;
}

bool LadinoCore::getT1HiloTendencia() {
   return _T1HiloTendencia;
}

void LadinoCore::setT1HiloTendencia(bool value) {
   _T1HiloTendencia = value; 
}

int LadinoCore::getT1MM() {
   return _T1MM;
}

void LadinoCore::setT1MM(int value) {
   _T1MM = value;
}

bool LadinoCore::getT2GraficoExtra() {
   return _T2GraficoExtra;
}

void LadinoCore::setT2GraficoExtra(bool value) {
   _T2GraficoExtra = value;
}

ENUM_TIMEFRAMES LadinoCore::getT2TempoGrafico() {
   return _T2TempoGrafico;
}

void LadinoCore::setT2TempoGrafico(ENUM_TIMEFRAMES value) {
   _T2TempoGrafico = value;
}

int LadinoCore::getT2HiloPeriodo() {
   return _T2HiloPeriodo;
}

void LadinoCore::setT2HiloPeriodo(int value) {
   _T2HiloPeriodo = value;
}

bool LadinoCore::getT2HiloTendencia() {
   return _T2HiloTendencia;
}

void LadinoCore::setT2HiloTendencia(bool value) {
   _T2HiloTendencia = value;
}

bool LadinoCore::getT2SRTendencia() {
   return _T2SRTendencia;
}

void LadinoCore::setT2SRTendencia(bool value) {
   _T2SRTendencia = value;
}

int LadinoCore::getT2MM() {
   return _T2MM;
}

void LadinoCore::setT2MM(int value) {
   _T2MM = value;
}

bool LadinoCore::getT3GraficoExtra() {
   return _T3GraficoExtra;
}

void LadinoCore::setT3GraficoExtra(bool value) {
   _T3GraficoExtra = value;
}

ENUM_TIMEFRAMES LadinoCore::getT3TempoGrafico() {
   return _T3TempoGrafico;
}

void LadinoCore::setT3TempoGrafico(ENUM_TIMEFRAMES value) {
   _T3TempoGrafico = value;
}

bool LadinoCore::getT3HiloAtivo() {
   return _T3HiloAtivo;
}

void LadinoCore::setT3HiloAtivo(bool value) {
   _T3HiloAtivo = value;
}

int LadinoCore::getT3HiloPeriodo() {
   return _T3HiloPeriodo;
}

void LadinoCore::setT3HiloPeriodo(int value) {
   _T3HiloPeriodo = value;
}

bool LadinoCore::getT3HiloTendencia() {
   return _T3HiloTendencia;
}

void LadinoCore::setT3HiloTendencia(bool value) {
   _T3HiloTendencia = value;
}

bool LadinoCore::getT3SRTendencia() {
   return _T3SRTendencia;
}

void LadinoCore::setT3SRTendencia(bool value) {
   _T3SRTendencia = value;
}

int LadinoCore::getT3MM() {
   return _T3MM;
}

void LadinoCore::setT3MM(int value) {
   _T3MM = value;
}

double LadinoCore::getStopLossMin() {
   return _StopLossMin;
}

void LadinoCore::setStopLossMin(double value) {
   _StopLossMin = value;
}

double LadinoCore::getStopLossMax() {
   return _StopLossMax;
}

void LadinoCore::setStopLossMax(double value) {
   _StopLossMax = value;
}

double LadinoCore::getStopExtra() {
   return _StopExtra;
}
void LadinoCore::setStopExtra(double value) {
   _StopExtra = value;
}

ENUM_STOP LadinoCore::getStopInicial() {
   return _StopInicial;
}

void LadinoCore::setStopInicial(ENUM_STOP value) {
   _StopInicial = value;
}

double LadinoCore::getStopFixo() {
   return _StopFixo;
}

void LadinoCore::setStopFixo(double value) {
   _StopFixo = value;
}
      
double LadinoCore::getLTExtra() {
   return _LTExtra;
}

void LadinoCore::setLTExtra(double value) {
   _LTExtra = value;
}

bool LadinoCore::getAumentoAtivo() {
   return _AumentoAtivo;
}

void LadinoCore::setAumentoAtivo(bool value) {
   _AumentoAtivo = value;
}

double LadinoCore::getAumentoStopExtra() {
   return _AumentoStopExtra;
}

void LadinoCore::setAumentoStopExtra(double value) {
   _AumentoStopExtra = value;
}

int LadinoCore::getAumentoMinimo() {
   return _AumentoMinimo;
}

void LadinoCore::setAumentoMinimo(int value) {
   _AumentoMinimo = value;
}

/*
int LadinoCore::getBreakEven() {
   return _BreakEven;
}

void LadinoCore::setBreakEven(int value) {
   _BreakEven = value;
}
*/

int LadinoCore::getBreakEvenValor() {
   return _BreakEvenValor;
}

void LadinoCore::setBreakEvenValor(int value) {
   _BreakEvenValor = value;
}

/*
int LadinoCore::getBreakEvenVolume() {
   return _BreakEvenVolume;
}

void LadinoCore::setBreakEvenVolume(int value) {
   _BreakEvenVolume = value;
}
*/

ENUM_OBJETIVO LadinoCore::getObjetivoCondicao1() {
   return _ObjetivoCondicao1;
}

void LadinoCore::setObjetivoCondicao1(ENUM_OBJETIVO value) {
   _ObjetivoCondicao1 = value;
}

ENUM_STOP LadinoCore::getObjetivoStop1() {
   return _ObjetivoStop1;
}

void LadinoCore::setObjetivoStop1(ENUM_STOP value) {
   _ObjetivoStop1 = value;
}

ENUM_OBJETIVO LadinoCore::getObjetivoCondicao2() {
   return _ObjetivoCondicao2;
}

void LadinoCore::setObjetivoCondicao2(ENUM_OBJETIVO value) {
   _ObjetivoCondicao2 = value;
}

ENUM_STOP LadinoCore::getObjetivoStop2() {
   return _ObjetivoStop2;
}

void LadinoCore::setObjetivoStop2(ENUM_STOP value) {
   _ObjetivoStop2 = value;
}

ENUM_OBJETIVO LadinoCore::getObjetivoCondicao3() {
   return _ObjetivoCondicao3;
}

void LadinoCore::setObjetivoCondicao3(ENUM_OBJETIVO value) {
   _ObjetivoCondicao3 = value;
}

ENUM_STOP LadinoCore::getObjetivoStop3() {
   return _ObjetivoStop3;
}

void LadinoCore::setObjetivoStop3(ENUM_STOP value) {
   _ObjetivoStop3 = value;
}
