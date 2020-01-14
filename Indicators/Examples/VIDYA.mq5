//+------------------------------------------------------------------+
//|                                                        VIDYA.mq5 |
//|                   Copyright 2009-2017, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright   "2009-2017, MetaQuotes Software Corp."
#property link        "http://www.mql5.com"
#property description "Variable Index Dynamic Average"
//--- indicator settings
#property indicator_chart_window
#property indicator_buffers         1
#property indicator_plots           1
#property indicator_type1           DRAW_LINE
#property indicator_color1          Red
#property indicator_width1          1
#property indicator_label1          "VIDYA"
#property indicator_applied_price   PRICE_CLOSE
//--- input parameters
input int                InpPeriodCMO=9;              // Period CMO
input int                InpPeriodEMA=12;             // Period EMA
input int                InpShift=0;                  // Indicator's shift
//--- indicator buffers
double                  VIDYA_Buffer[];
//---
double                  ExtF;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,VIDYA_Buffer,INDICATOR_DATA);
//--- sets first bar from what index will be drawn
   PlotIndexSetInteger(0,PLOT_DRAW_BEGIN,InpPeriodEMA+InpPeriodCMO-1);
//--- sets indicator shift
   PlotIndexSetInteger(0,PLOT_SHIFT,InpShift);
//--- name for indicator label
   IndicatorSetString(INDICATOR_SHORTNAME,"VIDYA("+string(InpPeriodCMO)+","+string(InpPeriodEMA)+")");
//--- name for index label
   PlotIndexSetString(0,PLOT_LABEL,"VIDYA("+string(InpPeriodCMO)+","+string(InpPeriodEMA)+")");
//--- calculate smooth factor
   ExtF=2.0/(1.0+InpPeriodEMA);
//--- initialization done
  }
//+------------------------------------------------------------------+
//| Variable Index Dynamic Average                                   |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const int begin,
                const double &price[])
  {
//--- check for data
   if(rates_total<InpPeriodEMA+InpPeriodCMO-1)
      return(0);
//---
   int limit;
   if(prev_calculated<InpPeriodEMA+InpPeriodCMO-1)
     {
      limit=InpPeriodEMA+InpPeriodCMO-1;
      for(int i=0;i<limit;i++)
         VIDYA_Buffer[i]=price[i];
     }
   else limit=prev_calculated-1;
//--- main cycle
   for(int i=limit;i<rates_total && !IsStopped();i++)
     {
      //--- calculate CMO and get absolute value
      double mulCMO=fabs(CalculateCMO(i,InpPeriodCMO,price));
      //--- calculate VIDYA
      VIDYA_Buffer[i]=price[i]*ExtF*mulCMO+VIDYA_Buffer[i-1]*(1-ExtF*mulCMO);
     }
//--- OnCalculate done. Return new prev_calculated.
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| Chande Momentum Oscillator                                       |
//+------------------------------------------------------------------+
double CalculateCMO(int Position,const int PeriodCMO,const double &price[])
  {
   double resCMO=0.0;
   double UpSum=0.0,DownSum=0.0;
   if(Position>=PeriodCMO && ArrayRange(price,0)>Position)
     {
      for(int i=0;i<PeriodCMO;i++)
        {
         double diff=price[Position-i]-price[Position-i-1];
         if(diff>0.0)
            UpSum+=diff;
         else
            DownSum+=(-diff);
        }
      if(UpSum+DownSum!=0.0)
         resCMO=(UpSum-DownSum)/(UpSum+DownSum);
     }
   return(resCMO);
  }
//+------------------------------------------------------------------+
