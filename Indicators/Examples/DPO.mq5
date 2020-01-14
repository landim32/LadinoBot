//+------------------------------------------------------------------+
//|                                                          DPO.mq5 |
//|                   Copyright 2009-2017, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright   "2009-2017, MetaQuotes Software Corp."
#property link        "http://www.mql5.com"
#property description "Detrended Price Oscillator"
#include <MovingAverages.mqh>
//--- indicator settings
#property indicator_separate_window
#property indicator_buffers 2
#property indicator_plots   1
#property indicator_type1   DRAW_LINE
#property indicator_color1  DodgerBlue
//--- input parameters
input int InpDetrendPeriod=12; // Period
//--- indicator buffers
double    ExtDPOBuffer[];
double    ExtMABuffer[];
//--- global variable
int       ExtMAPeriod;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void OnInit()
  {
//--- get length of cycle for smoothing
   ExtMAPeriod=InpDetrendPeriod/2+1;
//--- indicator buffers mapping
   SetIndexBuffer(0,ExtDPOBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,ExtMABuffer,INDICATOR_CALCULATIONS);
//--- set accuracy
   IndicatorSetInteger(INDICATOR_DIGITS,_Digits+1);
//--- set first bar from what index will be drawn
   PlotIndexSetInteger(0,PLOT_DRAW_BEGIN,ExtMAPeriod-1);
//--- name for DataWindow and indicator subwindow label
   IndicatorSetString(INDICATOR_SHORTNAME,"DPO("+string(InpDetrendPeriod)+")");
//--- initialization done
  }
//+------------------------------------------------------------------+
//| Detrended Price Oscillator                                       |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const int begin,
                const double &price[])
  {
   int limit;
   int firstInd=begin+ExtMAPeriod-1;
//--- correct draw begin
   if(begin>0) PlotIndexSetInteger(0,PLOT_DRAW_BEGIN,firstInd);
//--- preliminary calculations
   if(prev_calculated<firstInd)
     {
      //--- filling  
      ArrayInitialize(ExtDPOBuffer,0.0);
      limit=firstInd;
     }
   else limit=prev_calculated-1;
//--- calculate simple moving average
   SimpleMAOnBuffer(rates_total,prev_calculated,begin,ExtMAPeriod,price,ExtMABuffer);
//--- the main loop of calculations
   for(int i=limit;i<rates_total && !IsStopped();i++)
      ExtDPOBuffer[i]=price[i]-ExtMABuffer[i];
//--- done
   return(rates_total);
  }
//+------------------------------------------------------------------+
