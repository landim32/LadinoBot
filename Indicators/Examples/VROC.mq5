//+------------------------------------------------------------------+
//|                                                         VROC.mq5 |
//|                   Copyright 2009-2017, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright   "2009-2017, MetaQuotes Software Corp."
#property link        "http://www.mql5.com"
#property description "Volume Rate of Change"
//--- indicator settings
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_plots   1
#property indicator_type1   DRAW_LINE
#property indicator_color1  Green
#property indicator_style1  0
#property indicator_width1  1
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//--- input parametrs
input int                 InpPeriodVROC=25;           // Period
input ENUM_APPLIED_VOLUME InpVolumeType=VOLUME_TICK;  // Volumes
//---- indicator buffer
double                    ExtVROCBuffer[];
//--- global variable
int                       ExtPeriodVROC;
//+------------------------------------------------------------------+
//| VROC initialization function                                     |
//+------------------------------------------------------------------+
void OnInit()
  {
//--- check for input value
   if(InpPeriodVROC<=1)
     {
      ExtPeriodVROC=25;
      printf("Incorrect value for input variable InpPeriodVROC=%d. Indicator will use value=%d for calculations.",
             InpPeriodVROC,ExtPeriodVROC);
     }
   else ExtPeriodVROC=InpPeriodVROC;
//--- define index buffer
   SetIndexBuffer(0,ExtVROCBuffer);
//--- set indicator short name
   IndicatorSetString(INDICATOR_SHORTNAME,"VROC("+string(ExtPeriodVROC)+")");
//--- set indicator digits
   IndicatorSetInteger(INDICATOR_DIGITS,2);
//--- set draw begin
   PlotIndexSetInteger(0,PLOT_DRAW_BEGIN,ExtPeriodVROC-1);
//---- OnInit done
  }
//+------------------------------------------------------------------+
//| VROC iteration function                                          |
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
//--- check for rates count
   if(rates_total<ExtPeriodVROC)
      return(0);
//--- starting work
   int pos=prev_calculated-1;
//--- initializing ExtVROCBuffer
   if(pos<ExtPeriodVROC-1) pos=ExtPeriodVROC-1;
//--- main cycle by volume type
   if(InpVolumeType==VOLUME_TICK)
      CalculateVROC(pos,rates_total,tick_volume);
   else
      CalculateVROC(pos,rates_total,volume);
//---- OnCalculate done. Return new prev_calculated.
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| Calculate VROC by volume argument                                |
//+------------------------------------------------------------------+
void CalculateVROC(const int nPosition,
                   const int nRatesCount,
                   const long &VolBuffer[])
  {
   for(int i=nPosition;i<nRatesCount && !IsStopped();i++)
     {
      //--- getting some data
      double PrevVolume=(double)(VolBuffer[i-(ExtPeriodVROC-1)]);
      double CurrVolume=(double)VolBuffer[i];
      //--- fill ExtVROCBuffer
      if(PrevVolume!=0.0)
         ExtVROCBuffer[i]=100.0*(CurrVolume-PrevVolume)/PrevVolume;
      else
         ExtVROCBuffer[i]=ExtVROCBuffer[i-1];
     }
  }
//+------------------------------------------------------------------+
