//+------------------------------------------------------------------+
//|                                                          CHV.mq5 |
//|                   Copyright 2009-2017, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright   "2009-2017, MetaQuotes Software Corp."
#property link        "http://www.mql5.com"
#property description "Chaikin Volatility"
#include <MovingAverages.mqh>
//--- indicator settings
#property indicator_separate_window
#property indicator_buffers 3
#property indicator_plots   1
#property indicator_type1   DRAW_LINE
#property indicator_color1  DodgerBlue
//--- enum
enum SmoothMethod
  {
   SMA=0,// Simple MA
   EMA=1 // Exponential MA
  };
//--- input parameters
input int          InpSmoothPeriod=10;  // Smoothing period
input int          InpCHVPeriod=10;     // CHV period
input SmoothMethod InpSmoothType=EMA;   // Smoothing method
//---- buffers
double             ExtCHVBuffer[];
double             ExtHLBuffer[];
double             ExtSHLBuffer[];
//--- global variables
int                ExtSmoothPeriod,ExtCHVPeriod;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void OnInit()
  {
//--- check for input variables
   string MAName;
//--- set MA name
   if(InpSmoothType==SMA)
      MAName="SMA";
   else
      MAName="EMA";
//--- check inputs
   if(InpSmoothPeriod<=0)
     {
      ExtSmoothPeriod=10;
      printf("Incorrect value for input variable InpSmoothPeriod=%d. Indicator will use value=%d for calculations.",InpSmoothPeriod,ExtSmoothPeriod);
     }
   else ExtSmoothPeriod=InpSmoothPeriod;
   if(InpCHVPeriod<=0)
     {
      ExtCHVPeriod=10;
      printf("Incorrect value for input variable InpCHVPeriod=%d. Indicator will use value=%d for calculations.",InpCHVPeriod,ExtCHVPeriod);
     }
   else ExtCHVPeriod=InpCHVPeriod;
//---- define buffers
   SetIndexBuffer(0,ExtCHVBuffer);
   SetIndexBuffer(1,ExtHLBuffer,INDICATOR_CALCULATIONS);
   SetIndexBuffer(2,ExtSHLBuffer,INDICATOR_CALCULATIONS);
//--- set draw begin
   PlotIndexSetInteger(0,PLOT_DRAW_BEGIN,ExtSmoothPeriod+ExtCHVPeriod-1);
//--- set index label
   PlotIndexSetString(0,PLOT_LABEL,"CHV("+string(ExtSmoothPeriod)+","+MAName+")");
//--- indicator name
   IndicatorSetString(INDICATOR_SHORTNAME,"Chaikin Volatility("+string(ExtSmoothPeriod)+","+MAName+")");
//--- round settings
   IndicatorSetInteger(INDICATOR_DIGITS,1);
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
//--- variables of indicator
   int    i,pos,posCHV;
//--- check for rates total
   posCHV=ExtCHVPeriod+ExtSmoothPeriod-2;
   if(rates_total<posCHV)
      return(0);
//--- start working
   if(prev_calculated<1)
      pos=0;
   else pos=prev_calculated-1;
//--- fill H-L(i) buffer 
   for(i=pos;i<rates_total && !IsStopped();i++) ExtHLBuffer[i]=high[i]-low[i];
//--- calculate smoothed H-L(i) buffer
   if(pos<ExtSmoothPeriod-1)
     {
      pos=ExtSmoothPeriod-1;
      for(i=0;i<pos;i++) ExtSHLBuffer[i]=0.0;
     }
   if(InpSmoothType==SMA)
      SimpleMAOnBuffer(rates_total,prev_calculated,0,ExtSmoothPeriod,ExtHLBuffer,ExtSHLBuffer);
   else
      ExponentialMAOnBuffer(rates_total,prev_calculated,0,ExtSmoothPeriod,ExtHLBuffer,ExtSHLBuffer);
//--- correct calc position
   if(pos<posCHV) pos=posCHV;
//--- calculate CHV buffer
   for(i=pos;i<rates_total && !IsStopped();i++)
     {
      if(ExtSHLBuffer[i-ExtCHVPeriod]!=0.0)
         ExtCHVBuffer[i]=100.0*(ExtSHLBuffer[i]-ExtSHLBuffer[i-ExtCHVPeriod])/ExtSHLBuffer[i-ExtCHVPeriod];
      else
         ExtCHVBuffer[i]=0.0;
     }
//----
   return(rates_total);
  }
//+------------------------------------------------------------------+
