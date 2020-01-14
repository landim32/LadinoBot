//+------------------------------------------------------------------+
//|                                                     DeMarker.mq5 |
//|                   Copyright 2009-2017, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "2009-2017, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#include <MovingAverages.mqh>
//--- indicator settings
#property indicator_separate_window
#property indicator_buffers 5
#property indicator_plots   1
#property indicator_type1   DRAW_LINE
#property indicator_color1  DodgerBlue
#property indicator_level1  0.3
#property indicator_level2  0.7
//--- input parameters
input int InpDeMarkerPeriod=14; // Period
//--- indicator buffers
double    ExtDeMarkerBuffer[];
double    ExtDeMaxBuffer[];
double    ExtDeMinBuffer[];
double    ExtAvgDeMaxBuffer[];
double    ExtAvgDeMinBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,ExtDeMarkerBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,ExtDeMaxBuffer,INDICATOR_CALCULATIONS);
   SetIndexBuffer(2,ExtDeMinBuffer,INDICATOR_CALCULATIONS);
   SetIndexBuffer(3,ExtAvgDeMaxBuffer,INDICATOR_CALCULATIONS);
   SetIndexBuffer(4,ExtAvgDeMinBuffer,INDICATOR_CALCULATIONS);
//--- set accuracy
   IndicatorSetInteger(INDICATOR_DIGITS,3);
//--- sets first bar from what index will be drawn
   PlotIndexSetInteger(0,PLOT_DRAW_BEGIN,InpDeMarkerPeriod);
//--- name for DataWindow and indicator subwindow label
   IndicatorSetString(INDICATOR_SHORTNAME,"DeM("+string(InpDeMarkerPeriod)+")");
//--- initialization done
  }
//+------------------------------------------------------------------+
//| DeMarker                                                         |
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
   int    i,limit;
   double dNum;
//--- check for bars count
   if(rates_total<InpDeMarkerPeriod)
      return(0);
//--- preliminary calculations
   if(prev_calculated==0)
     {
      ExtDeMaxBuffer[0]=0.0;
      ExtDeMinBuffer[0]=0.0;
      //--- filling out the array of True Range values for each period
      for(i=1;i<InpDeMarkerPeriod;i++)
        {
         if(high[i]>high[i-1]) ExtDeMaxBuffer[i]=high[i]-high[i-1];
         else ExtDeMaxBuffer[i]=0.0;

         if(low[i-1]>low[i]) ExtDeMinBuffer[i]=low[i-1]-low[i];
         else ExtDeMinBuffer[i]=0.0;
        }
      for(i=0;i<InpDeMarkerPeriod;i++) ExtDeMarkerBuffer[i]=0.0;
      limit=InpDeMarkerPeriod-1;
    }
   else limit=prev_calculated-1;
//--- the main loop of calculations
   for(i=limit;i<rates_total && !IsStopped();i++)
     {
      if(high[i]>high[i-1]) ExtDeMaxBuffer[i]=high[i]-high[i-1];
      else ExtDeMaxBuffer[i]=0.0;

      if(low[i-1]>low[i]) ExtDeMinBuffer[i]=low[i-1]-low[i];
      else ExtDeMinBuffer[i]=0.0;

      ExtAvgDeMaxBuffer[i]=SimpleMA(i,InpDeMarkerPeriod,ExtDeMaxBuffer);
      ExtAvgDeMinBuffer[i]=SimpleMA(i,InpDeMarkerPeriod,ExtDeMinBuffer);

      dNum=ExtAvgDeMaxBuffer[i]+ExtAvgDeMinBuffer[i];
      if(dNum!=0) ExtDeMarkerBuffer[i]=ExtAvgDeMaxBuffer[i]/dNum;
      else ExtDeMarkerBuffer[i]=0.0;
     }
//--- OnCalculate done. Return new prev_calculated.
   return(rates_total);
  }
//+------------------------------------------------------------------+
