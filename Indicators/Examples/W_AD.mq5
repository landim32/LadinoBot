//+------------------------------------------------------------------+
//|                                                         W_AD.mq5 |
//|                   Copyright 2009-2017, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright   "2009-2017, MetaQuotes Software Corp."
#property link        "http://www.mql5.com"
#property description "Larry Williams' Accumulation/Distribution"
//--- indicator settings
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_plots   1
#property indicator_type1   DRAW_LINE
#property indicator_color1  LightSeaGreen
//---- buffers
double ExtWADBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void OnInit()
  {
//---- define buffer
   SetIndexBuffer(0,ExtWADBuffer);
//--- set draw begin
   PlotIndexSetInteger(0,PLOT_DRAW_BEGIN,1);
//--- indicator name
   IndicatorSetString(INDICATOR_SHORTNAME,"W_A/D");
//--- round settings
   IndicatorSetInteger(INDICATOR_DIGITS,_Digits);
//---- OnInit done
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
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
   if(rates_total<2)
      return(0);
//--- start working
   int pos=prev_calculated-1;
//--- correct position, set initial value
   if(pos<=0)
     {
      pos=1;
      ExtWADBuffer[0]=0.0;
     }
//--- main cycle
   for(int i=pos;i<rates_total && !IsStopped();i++)
     {
      //--- get data
      double hi=high[i];
      double lo=low[i];
      double cl=close[i];
      double prev_cl=close[i-1];
      //--- calculate TRH and TRL
      double trh=MathMax(hi,prev_cl);
      double trl=MathMin(lo,prev_cl);
      //--- calculate WA/D
      if(IsEqualDoubles(cl,prev_cl,_Point))
         ExtWADBuffer[i]=ExtWADBuffer[i-1];
      else
        {
         if(cl>prev_cl)
            ExtWADBuffer[i]=ExtWADBuffer[i-1]+cl-trl;
         else
            ExtWADBuffer[i]=ExtWADBuffer[i-1]+cl-trh;
        }
     }
//---- OnCalculate done. Return new prev_calculated.
   return(rates_total);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsEqualDoubles(double d1,double d2,double epsilon)
  {
   if(epsilon<0.0) epsilon=-epsilon;
   if(epsilon>0.1) epsilon=0.00001;
//---
   double diff=d1-d2;
   if(diff>epsilon || diff<-epsilon) return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
