//+------------------------------------------------------------------+
//|                                                          CHO.mq5 |
//|                   Copyright 2009-2017, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright   "2009-2017, MetaQuotes Software Corp."
#property link        "http://www.mql5.com"
#property description "Chaikin Oscillator"
#include <MovingAverages.mqh>
//--- indicator settings
#property indicator_separate_window
#property indicator_buffers 4
#property indicator_plots   1
#property indicator_type1   DRAW_LINE
#property indicator_color1  LightSeaGreen
//--- input parameters
input int                 InpFastMA=3;                // Fast MA period
input int                 InpSlowMA=10;               // Slow MA period
input ENUM_MA_METHOD      InpSmoothMethod=MODE_EMA;   // MA method
input ENUM_APPLIED_VOLUME InpVolumeType=VOLUME_TICK;  // Volumes
//--- indicator buffers
double                    ExtCHOBuffer[];
double                    ExtFastEMABuffer[];
double                    ExtSlowEMABuffer[];
double                    ExtADBuffer[];
static int weightfast,weightslow;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,ExtCHOBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,ExtFastEMABuffer,INDICATOR_CALCULATIONS);
   SetIndexBuffer(2,ExtSlowEMABuffer,INDICATOR_CALCULATIONS);
   SetIndexBuffer(3,ExtADBuffer,INDICATOR_CALCULATIONS);
//--- set accuracy
   IndicatorSetInteger(INDICATOR_DIGITS,0);
//--- sets first bar from what index will be drawn
   PlotIndexSetInteger(0,PLOT_DRAW_BEGIN,InpSlowMA);
//--- name for DataWindow and indicator subwindow label
   IndicatorSetString(INDICATOR_SHORTNAME,"CHO("+string(InpSlowMA)+","+string(InpFastMA)+")");
//--- initialization done
  }
//+------------------------------------------------------------------+
//| calculate AD                                                     |
//+------------------------------------------------------------------+
double AD(double high,double low,double close,long volume)
  {
   double res=0;
//---
   if(high!=low)
      res=(2*close-high-low)/(high-low)*volume;
//---
   return(res);
  }
//+------------------------------------------------------------------+
//| calculate average on array                                       |
//+------------------------------------------------------------------+
void AverageOnArray(const int mode,const int rates_total,const int prev_calculated,const int begin,
                    const int period,const double& source[],double& destination[],int &weightsum)
  {
   switch(mode)
     {
      case MODE_EMA:
         ExponentialMAOnBuffer(rates_total,prev_calculated,begin,period,source,destination);
         break;
      case MODE_SMMA:
         SmoothedMAOnBuffer(rates_total,prev_calculated,begin,period,source,destination);
         break;
      case MODE_LWMA:
         LinearWeightedMAOnBuffer(rates_total,prev_calculated,begin,period,source,destination,weightsum);
         break;
      default:
         SimpleMAOnBuffer(rates_total,prev_calculated,begin,period,source,destination);
     }
  }
//+------------------------------------------------------------------+
//| Chaikin Oscillator                                               |
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
   if(rates_total<InpSlowMA)
      return(0); // not enough bars for calculation
//--- preliminary calculations
   if(prev_calculated<1)
     {
      limit=1;
      //--- first values
      if(InpVolumeType==VOLUME_TICK)
         ExtADBuffer[0]=AD(high[0],low[0],close[0],tick_volume[0]);
      else
         ExtADBuffer[0]=AD(high[0],low[0],close[0],volume[0]);
      ExtSlowEMABuffer[0]=ExtADBuffer[0];
      ExtFastEMABuffer[0]=ExtADBuffer[0];
     }
   else limit=prev_calculated-1;
//--- calculate AD buffer
   if(InpVolumeType==VOLUME_TICK)
     {
      for(i=limit;i<rates_total && !IsStopped();i++)
         ExtADBuffer[i]=ExtADBuffer[i-1]+AD(high[i],low[i],close[i],tick_volume[i]);
     }
   else
     {
      for(i=limit;i<rates_total && !IsStopped();i++)
         ExtADBuffer[i]=ExtADBuffer[i-1]+AD(high[i],low[i],close[i],volume[i]);
     }
//--- calculate EMA on array ExtADBuffer
   AverageOnArray(InpSmoothMethod,rates_total,prev_calculated,0,InpSlowMA,ExtADBuffer,ExtSlowEMABuffer,weightslow);
   AverageOnArray(InpSmoothMethod,rates_total,prev_calculated,0,InpFastMA,ExtADBuffer,ExtFastEMABuffer,weightfast);
//--- calculate chaikin oscillator
   for(i=limit;i<rates_total && !IsStopped();i++)
      ExtCHOBuffer[i]=ExtFastEMABuffer[i]-ExtSlowEMABuffer[i];
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
