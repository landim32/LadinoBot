//+------------------------------------------------------------------+
//|                                                           MI.mq5 |
//|                   Copyright 2009-2017, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright   "2009-2017, MetaQuotes Software Corp."
#property link        "http://www.mql5.com"
#property description "Mass Index"
#include <MovingAverages.mqh>
//--- indicator settings
#property indicator_separate_window
#property indicator_buffers 4
#property indicator_plots   1
#property indicator_type1   DRAW_LINE
#property indicator_color1  DodgerBlue
#property indicator_level1 27
#property indicator_level2 26.5
#property indicator_levelcolor DarkGray
//--- input parametrs
input int InpPeriodEMA=9;        // First EMA period
input int InpSecondPeriodEMA=9;  // Second EMA period
input int InpSumPeriod=25;       // Mass period
//--- global variables
int       ExtPeriodEMA;
int       ExtSecondPeriodEMA;
int       ExtSumPeriod;
//---- indicator buffers
double    ExtHLBuffer[];
double    ExtEHLBuffer[];
double    ExtEEHLBuffer[];
double    ExtMIBuffer[];
//+------------------------------------------------------------------+
//| MI initialization function                                       |
//+------------------------------------------------------------------+
void OnInit()
  {
//--- check input variables
   if(InpPeriodEMA<=0)
     {
      ExtPeriodEMA=9;
      printf("Incorrect value for input variable InpPeriodEMA=%d. Indicator will use value=%d for calculations.",
             InpPeriodEMA,ExtPeriodEMA);
     }
   else ExtPeriodEMA=InpPeriodEMA;
   if(InpSecondPeriodEMA<=0)
     {
      ExtSecondPeriodEMA=9;
      printf("Incorrect value for input variable InpSecondPeriodEMA=%d. Indicator will use value=%d for calculations.",
             InpSecondPeriodEMA,ExtSecondPeriodEMA);
     }
   else ExtSecondPeriodEMA=InpSecondPeriodEMA;
   if(InpSumPeriod<=0)
     {
      ExtSumPeriod=25;
      printf("Incorrect value for input variable PeriodSum=%d. Indicator will use value=%d for calculations.",
             InpSumPeriod,ExtSumPeriod);
     }
   else ExtSumPeriod=InpSumPeriod;
//--- define buffers
   SetIndexBuffer(0,ExtMIBuffer);
   SetIndexBuffer(1,ExtEHLBuffer,INDICATOR_CALCULATIONS);
   SetIndexBuffer(2,ExtEEHLBuffer,INDICATOR_CALCULATIONS);
   SetIndexBuffer(3,ExtHLBuffer,INDICATOR_CALCULATIONS);
//--- number of digits of indicator value
   IndicatorSetInteger(INDICATOR_DIGITS,2);
//--- name for DataWindow and indicator subwindow label
   IndicatorSetString(INDICATOR_SHORTNAME,"Mass Index("+string(ExtPeriodEMA)+","+string(ExtSecondPeriodEMA)+","+string(ExtSumPeriod)+")");
   PlotIndexSetString(0,PLOT_LABEL,"MI("+string(ExtPeriodEMA)+","+string(ExtSecondPeriodEMA)+","+string(ExtSumPeriod)+")");
//--- indexes draw begin settings
   PlotIndexSetInteger(0,PLOT_DRAW_BEGIN,ExtPeriodEMA+ExtSecondPeriodEMA+ExtSumPeriod-3);
//---- OnInit done
  }
//+------------------------------------------------------------------+
//| Mass Index                                                       |
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
//--- check for bars count
   int posMI=ExtSumPeriod+ExtPeriodEMA+ExtSecondPeriodEMA-3;
   if(rates_total<posMI)
      return(0);
//--- start working
   int pos=prev_calculated-1;
//--- correct position
   if(pos<1)
     {
      ExtHLBuffer[0]=high[0]-low[0];
      pos=1;
     }
//--- main cycle
   for(int i=pos;i<rates_total && !IsStopped();i++)
     {
      //--- fill main data buffer
      ExtHLBuffer[i]=high[i]-low[i];
      //--- calculate EMA values
      ExtEHLBuffer[i]=ExponentialMA(i,ExtPeriodEMA,ExtEHLBuffer[i-1],ExtHLBuffer);
      //--- calculate EMA on EMA values
      ExtEEHLBuffer[i]=ExponentialMA(i,ExtSecondPeriodEMA,ExtEEHLBuffer[i-1],ExtEHLBuffer);
      //--- calculate MI values
      double dTmp=0.0;
      for(int j=0;j<ExtSumPeriod && i>=posMI;j++)
         if(ExtEEHLBuffer[i-j]!=0.0)
            dTmp+=ExtEHLBuffer[i-j]/ExtEEHLBuffer[i-j];
      ExtMIBuffer[i]=dTmp;
     }
//---- OnCalculate done. Return new prev_calculated.
   return(rates_total);
  }
//+------------------------------------------------------------------+
