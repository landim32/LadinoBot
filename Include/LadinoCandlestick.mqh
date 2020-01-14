//+------------------------------------------------------------------+
//|                                            LadinoCandlestick.mqh |
//|                                                   Rodrigo Landim |
//|                                        http://www.emagine.com.br |
//+------------------------------------------------------------------+
#property copyright "Rodrigo Landim"
#property link      "http://www.emagine.com.br"
#property version   "1.00"

#include "Utils.mqh"

const int VELA_VERIFICA_QUANTIDADE = 100;

enum VELA_FORMATO {
   FORMATO_NENHUM,
   FORMATO_CURTA,
   FORMATO_LONGA,
   FORMATO_DOJI,
   FORMATO_MARTELO,
   FORMATO_MARTELO_INVERTIDO,
   FORMATO_MARIBOZU,
   FORMATO_MARIBOZU_LONGO,
   FORMATO_SPIN_TOP
};

enum VELA_PADRAO {
   INDEFINIDO,
   INSIDE_CANDLE_ALTA,
   INSIDE_CANDLE_BAIXA,
   ENFORCADO,
   ESTRELA_CADENTE,
   MARTELO,
   MARTELO_INVERTIDO,
   BELT_HOLD_BULL,
   BELT_HOLD_BEAR
};
enum VELA_TIPO {
   NENHUM,
   COMPRADORA,
   VENDEDORA
};
struct VELA {
   datetime tempo;
   double abertura;
   double maxima;
   double minima;
   double fechamento;
   double corpo;
   double pavil;
   double sombra_superior;
   double sombra_inferior;
   double tamanho;
   SINAL_TENDENCIA tendencia;
   VELA_TIPO tipo;
   VELA_FORMATO formato;
};

class LadinoCandlestick {
   private:

   public:
      LadinoCandlestick();
      ~LadinoCandlestick();
      bool pegarVela(MqlRates& rt, VELA& vela, ENUM_TIMEFRAMES periodo = PERIOD_CURRENT);
      VELA_PADRAO padraoVela(ENUM_TIMEFRAMES periodo = PERIOD_CURRENT);
      string textoVelaPadrao(VELA_PADRAO vela);
      bool emAlta(VELA_PADRAO vela);
      bool emBaixa(VELA_PADRAO vela);
};
//+------------------------------------------------------------------+
LadinoCandlestick::LadinoCandlestick() {
}
LadinoCandlestick::~LadinoCandlestick(){
}
//+------------------------------------------------------------------+
bool LadinoCandlestick::pegarVela(MqlRates& rt, VELA& vela, ENUM_TIMEFRAMES periodo = PERIOD_CURRENT) {

   ZeroMemory(vela);

   MqlRates rts[];
   if(CopyRates(_Symbol, periodo, 0, VELA_VERIFICA_QUANTIDADE, rts) < VELA_VERIFICA_QUANTIDADE) {
      return false;
   }
   double media = 0, total = 0;
   for(int i=0; i < VELA_VERIFICA_QUANTIDADE; i++) {
      media += rts[i].close;
      total = total + MathAbs(rts[i].open - rts[i].close);
   }
   media = media / VELA_VERIFICA_QUANTIDADE;
   total = total / VELA_VERIFICA_QUANTIDADE;
   ArrayFree(rts);

   vela.tempo = rt.time;
   vela.abertura = rt.open;
   vela.maxima = rt.high;
   vela.minima = rt.low;
   vela.fechamento = rt.close;
   vela.corpo = MathAbs(vela.fechamento - vela.abertura);
   if (vela.fechamento > vela.abertura)
      vela.sombra_superior = vela.maxima - vela.fechamento;
   else
      vela.sombra_superior = vela.maxima - vela.abertura;
   if (vela.fechamento <= vela.abertura)
      vela.sombra_inferior = vela.fechamento - vela.minima;
   else
      vela.sombra_inferior = vela.abertura - vela.minima;
   vela.pavil = vela.sombra_superior + vela.sombra_inferior;
   vela.tamanho = vela.maxima + vela.minima;
   
   if(media < vela.fechamento) 
      vela.tendencia = ALTA;
   if(media > vela.fechamento)
      vela.tendencia = BAIXA;
   if(media == vela.fechamento)
      vela.tendencia = INDEFINIDA;
   
   if (vela.fechamento > vela.abertura)
      vela.tipo = COMPRADORA;
   else if (vela.fechamento < vela.abertura)
      vela.tipo = VENDEDORA;
   else
      vela.tipo = NENHUM;
   vela.formato = FORMATO_NENHUM;
   if(vela.corpo > total * 1.3) 
      vela.formato = FORMATO_LONGA;
   if(vela.corpo < total * 0.5) 
      vela.formato = FORMATO_CURTA;
   if(vela.corpo < vela.tamanho * 0.03)
      vela.formato = FORMATO_DOJI;
      
   if((vela.sombra_inferior < vela.corpo * 0.01 || vela.sombra_superior < vela.corpo * 0.01) && vela.corpo > 0) {
      if(vela.formato == FORMATO_LONGA)
         vela.formato = FORMATO_MARIBOZU_LONGO;
      else
         vela.formato = FORMATO_MARIBOZU;
   }

   if (vela.sombra_inferior > (vela.corpo * 2) && vela.sombra_superior < (vela.corpo * 0.1))
      vela.formato = FORMATO_MARTELO;
      
   if (vela.sombra_inferior < (vela.corpo * 0.1) && vela.sombra_superior > (vela.corpo * 2))
      vela.formato = FORMATO_MARTELO_INVERTIDO;
   
   if(vela.formato == FORMATO_CURTA && vela.sombra_inferior > vela.corpo && vela.sombra_superior > vela.corpo)
      vela.formato = FORMATO_SPIN_TOP;
      
   return true;
}

VELA_PADRAO LadinoCandlestick::padraoVela(ENUM_TIMEFRAMES periodo = PERIOD_CURRENT) { 
   MqlRates rt[4];
   if(CopyRates(_Symbol, periodo, 0, 4, rt) != 4) {
      Print("CopyRates of " + _Symbol + " failed, no history");
      return INDEFINIDO;
   }
   
   VELA vela1, vela2, vela3;
   if (!(pegarVela(rt[2], vela3) && pegarVela(rt[1], vela2) && pegarVela(rt[0], vela1)))
      return INDEFINIDO;

   bool emAlta = 
      (vela1.tipo != VENDEDORA && vela2.tipo != VENDEDORA) &&
      (vela1.fechamento < vela2.fechamento && vela1.maxima < vela2.maxima && vela1.minima < vela2.minima);
   bool emQueda = 
      (vela1.tipo != COMPRADORA && vela2.tipo != COMPRADORA) &&
      (vela1.fechamento > vela2.fechamento && vela1.maxima > vela2.maxima && vela1.minima > vela2.minima);
   
   // Martelo - Reversão para Alta
   if (emQueda && vela3.formato == FORMATO_MARTELO) {
      return MARTELO;
   }
   // Martelo Invertido - Reversão para Alta
   if (emQueda && vela3.formato == FORMATO_MARTELO_INVERTIDO) {
      return MARTELO_INVERTIDO;
   }
   
   // Enforcado - Reversão para Baixa
   if (emAlta && vela3.formato == FORMATO_MARTELO) {
      return ENFORCADO;
   }
   // Estrela Cadente - Reversão para Baixa
   if (emAlta && vela3.formato == FORMATO_MARTELO_INVERTIDO) {
      return ESTRELA_CADENTE;
   }

   //Inside Candle de reversão para baixo
   if (emAlta && vela3.tipo == VENDEDORA && vela2.tipo == COMPRADORA) {
      if (vela2.corpo >= vela3.corpo && vela2.fechamento >= vela3.abertura && vela2.abertura <= vela3.fechamento)
         return INSIDE_CANDLE_BAIXA;
   }
   //Inside Candle de reversão para o alto
   if (emQueda && vela3.tipo == COMPRADORA && vela2.tipo == VENDEDORA) {
      if (vela2.corpo >= vela3.corpo && vela2.abertura >= vela3.fechamento && vela2.fechamento <= vela3.abertura)
         return INSIDE_CANDLE_ALTA;
   }
   
   return INDEFINIDO;
}

string LadinoCandlestick::textoVelaPadrao(VELA_PADRAO vela) {
   string texto;
   switch (vela) {
      case MARTELO:
         texto = "Padrão de vela atual é um martelo! Reversão para alta!";
         break;
      case ESTRELA_CADENTE:
         texto = "Padrão de vela atual é uma estrela cadente! Reversão para baixa!";
         break;
      case INSIDE_CANDLE_BAIXA:
         texto = "Inside Candle! Reversão para BAIXO!";
         break;
      case INSIDE_CANDLE_ALTA:
         texto = "Inside Candle! Reversão para o ALTO!";
         break;
      default:
         texto = "Padrão de vela indefinido!";
         break;
   }
   return texto;
}

bool LadinoCandlestick::emAlta(VELA_PADRAO vela) {
   return (vela == MARTELO || vela == MARTELO_INVERTIDO || vela == BELT_HOLD_BULL || vela == INSIDE_CANDLE_ALTA);
}

bool LadinoCandlestick::emBaixa(VELA_PADRAO vela) {
   return (vela == ENFORCADO || vela == ESTRELA_CADENTE || vela == BELT_HOLD_BEAR || vela == INSIDE_CANDLE_BAIXA);
}