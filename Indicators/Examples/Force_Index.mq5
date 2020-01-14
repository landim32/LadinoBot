//+------------------------------------------------------------------+
//|                                                  Force_Index.mq5 |
//|                   Copyright 2009-2017, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "2009-2017, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
//--- indicator settings
#property indicator_separate_window
#property indicator_buffers 2
#property indicator_plots   1
#property indicator_type1   DRAW_LINE
#property indicator_color1  DodgerBlue
//--- input parameters
input int                 InpForcePeriod=13;             // Period
input ENUM_MA_METHOD      InpMAMethod=MODE_SMA;          // MA method
input ENUM_APPLIED_PRICE  InpAppliedPrice=PRICE_CLOSE;   // Applied price
input ENUM_APPLIED_VOLUME InpAppliedVolume=VOLUME_TICK;  // Volumes
//--- indicator buffers
double                    ExtForceBuffer[];
double                    ExtMABuffer[];
//--- MA handle
int                       ExtMAHandle;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,ExtForceBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,ExtMABuffer,INDICATOR_CALCULATIONS);
//--- sets first bar from what index will be drawn
   PlotIndexSetInteger(0,PLOT_DRAW_BEGIN,InpForcePeriod);
//--- name for DataWindow and indicator subwindow label
   IndicatorSetString(INDICATOR_SHORTNAME,"Force("+string(InpForcePeriod)+")");
//--- get MA handle
   ExtMAHandle=iMA(NULL,0,InpForcePeriod,0,InpMAMethod,InpAppliedPrice);
//--- initialization done
  }
//+------------------------------------------------------------------+
//| Force Index                                                      |
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
   int i,limit;
//--- check for rates total
   if(rates_total<InpForcePeriod)
      return(0);
//---
   int calculated=BarsCalculated(ExtMAHandle);
   if(calculated<rates_total)
     {
      Print("Not all data of ExtMAHandle is calculated (",calculated,"bars ). Error",GetLastError());
      return(0);
     }
//--- we can copy not all data
   int to_copy;
   if(prev_calculated>rates_total || prev_calculated<0) to_copy=rates_total;
   else
     {
      to_copy=rates_total-prev_calculated;
      if(prev_calculated>0) to_copy++;
     }
//---- get ma buffer
   if(IsStopped()) return(0); //Checking for stop flag
   if(CopyBuffer(ExtMAHandle,0,0,to_copy,ExtMABuffer)<=0)
     {
      Print("Getting MA data is failed! Error",GetLastError());
      return(0);
     }
//--- preliminary calculations
   if(prev_calculated<InpForcePeriod)
      limit=InpForcePeriod;
   else limit=prev_calculated-1;
//--- the main loop of calculations
   if(InpAppliedVolume==VOLUME_TICK)
     {
      for(i=limit;i<rates_total && !IsStopped();i++)
         ExtForceBuffer[i]=tick_volume[i]*(ExtMABuffer[i]-ExtMABuffer[i-1]);
     }
   else
     {
      for(i=limit;i<rates_total && !IsStopped();i++)
         ExtForceBuffer[i]=volume[i]*(ExtMABuffer[i]-ExtMABuffer[i-1]);
     }
//--- OnCalculate done. Return new prev_calculated.
   return(rates_total);
  }
//+------------------------------------------------------------------+
