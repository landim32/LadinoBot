//+------------------------------------------------------------------+
//|                                                          PVT.mq5 |
//|                   Copyright 2009-2017, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright   "2009-2017, MetaQuotes Software Corp."
#property link        "http://www.mql5.com"
#property description "Price and Volume Trend"

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_plots   1
#property indicator_type1   DRAW_LINE
#property indicator_color1  DodgerBlue
//--- input parametrs
input ENUM_APPLIED_VOLUME InpVolumeType=VOLUME_TICK; // Volumes
//---- indicator buffer
double                    ExtPVTBuffer[];
//+------------------------------------------------------------------+
//| PVT initialization function                         |
//+------------------------------------------------------------------+
void OnInit()
  {
//--- define indicator buffer
   SetIndexBuffer(0,ExtPVTBuffer);
//--- set indicator digits
   IndicatorSetInteger(INDICATOR_DIGITS,_Digits);
//--- name for DataWindow and indicator label
   IndicatorSetString(INDICATOR_SHORTNAME,"PVT");
//--- set index empty value
   PlotIndexSetDouble(0,PLOT_EMPTY_VALUE,0.0);
//--- set index draw begin
   PlotIndexSetInteger(0,PLOT_DRAW_BEGIN,1);
//---- OnInit done
  }
//+------------------------------------------------------------------+
//| PVT iteration function                              |
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
//--- variables
   int pos;
//--- check for bars count
   if(rates_total<2)
      return(0);
//--- start calculation
   pos=prev_calculated-1;
//--- correct position, when it's first iteration
   if(pos<0)
     {
      pos=1;
      ExtPVTBuffer[0]=0.0;
     }
//--- main cycle
   if(InpVolumeType==VOLUME_TICK)
      CalculatePVT(pos,rates_total,close,tick_volume);
   else
      CalculatePVT(pos,rates_total,close,volume);
//---- OnCalculate done. Return new prev_calculated.
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| Calculate PVT by volume argument                                 |
//+------------------------------------------------------------------+
void CalculatePVT(int nPosition,
                  int nRatesCount,
                  const double &ClBuffer[],
                  const long &VolBuffer[])
  {
   if(nPosition<=0) nPosition=1;
//---
   for(int i=nPosition;i<nRatesCount && !IsStopped();i++)
     {
      //--- get some data
      double PrevClose=ClBuffer[i-1];
      //--- calculate PVT value
      if(PrevClose!=0)
         ExtPVTBuffer[i]=((ClBuffer[i]-PrevClose)/PrevClose)*VolBuffer[i]+ExtPVTBuffer[i-1];
      else ExtPVTBuffer[i]=ExtPVTBuffer[i-1];
     }
//---
  }
//+------------------------------------------------------------------+
