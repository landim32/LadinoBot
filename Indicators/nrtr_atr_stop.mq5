//+------------------------------------------------------------------+
//|                                                NRTR_ATR_STOP.mq5 |
//|                                     Copyright 2013, PunkBASSter. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, PunkBASSter."
#property link      "http://www.mql5.com"
#property version   "1.00"
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_plots   2
//--- plot Up
#property indicator_label1  "Up"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrGreen
#property indicator_style1  STYLE_SOLID
#property indicator_width1  2
//--- plot Dn
#property indicator_label2  "Dn"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrRed
#property indicator_style2  STYLE_SOLID
#property indicator_width2  2
//---
input int ATR=13; //ATR period
input double K=1.6;    //Coefficient
//--- indicator buffers
double         Up[];
double         Dn[];
string         sym;
bool           first;
int            hATR=INVALID_HANDLE;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum MODE
  {
   MODE_UP,
   MODE_DN,
  };
MODE mode;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,Up);
   SetIndexBuffer(1,Dn);
   IndicatorSetInteger(INDICATOR_DIGITS,_Digits);
//----
   ArraySetAsSeries(Up,true);
   ArraySetAsSeries(Dn,true);
   hATR=iATR(_Symbol,_Period,ATR);
   if(hATR==INVALID_HANDLE)
     {
      Print("Failed to initialize ATR.");
      return(INIT_FAILED);
     }
   first=true;
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
   ArraySetAsSeries(high,true);
   ArraySetAsSeries(low,true);
   int i,limit;
   double REZ,md,buf[1];
   limit=rates_total-ATR-1;
//----
   if(first)
     {
      md=0;
      for(i=0; i<limit; i++)
        {
         CopyBuffer(hATR,0,i,1,buf);
         md+=buf[0];
        }
      CopyBuffer(hATR,0,limit,1,buf);
      REZ=K*buf[0];
      if(buf[0]<md/limit)
        {
         Up[limit+1]=low[limit+1]-REZ;
         mode=MODE_UP;
        }
      if(buf[0]>md/limit)
        {
         Dn[limit+1]=high[limit+1]+REZ;
         mode=MODE_DN;
        }
      first=false;
     }
//----
   for(i=limit-1; i>=0; i--)
     {
      Dn[i] = EMPTY_VALUE;
      Up[i] = EMPTY_VALUE;
      CopyBuffer(hATR,0,i,1,buf);
      REZ=K*buf[0];
      //----
      if(mode==MODE_DN && low[i+1]>Dn[i+1])
        {
         Up[i+1]=low[i+1]-REZ;
         mode=MODE_UP;
        }
      //----
      if(mode==MODE_UP && high[i+1]<Up[i+1])
        {
         Dn[i+1]=high[i+1]+REZ;
         mode=MODE_DN;
        }
      //----
      if(mode==MODE_UP)
        {
         if(low[i+1]>Up[i+1]+REZ)
           {
            Up[i] = low[i+1] - REZ;
            Dn[i] = EMPTY_VALUE;
           }
         else
           {
            Up[i] = Up[i+1];
            Dn[i] = EMPTY_VALUE;
           }
        }
      //----
      if(mode==MODE_DN)
        {
         if(high[i+1]<Dn[i+1]-REZ)
           {
            Dn[i] = high[i+1] + REZ;
            Up[i] = EMPTY_VALUE;
           }
         else
           {
            Dn[i] = Dn[i+1];
            Up[i] = EMPTY_VALUE;
           }
        }
     }
//---
   return(rates_total);
  }
//+------------------------------------------------------------------+
