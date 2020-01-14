//+------------------------------------------------------------------+
//|                                                       StdDev.mq5 |
//|                   Copyright 2009-2017, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright   "2009-2017, MetaQuotes Software Corp."
#property link        "http://www.mql5.com"
#property description "Standard Deviation"
#include <MovingAverages.mqh>

#property indicator_separate_window
#property indicator_buffers 2
#property indicator_plots   1
#property indicator_type1   DRAW_LINE
#property indicator_color1  MediumSeaGreen
#property indicator_style1  STYLE_SOLID
//--- input parametrs
input int            InpStdDevPeriod=20;   // Period
input int            InpStdDevShift=0;     // Shift
input ENUM_MA_METHOD InpMAMethod=MODE_SMA; // Method
//---- buffers
double               ExtStdDevBuffer[];
double               ExtMABuffer[];
//--- global variables
int                  ExtStdDevPeriod,ExtStdDevShift;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void OnInit()
  {
//--- check for input values
   if(InpStdDevPeriod<=1)
     {
      ExtStdDevPeriod=20;
      printf("Incorrect value for input variable InpStdDevPeriod=%d. Indicator will use value=%d for calculations.",InpStdDevPeriod,ExtStdDevPeriod);
     }
   else ExtStdDevPeriod=InpStdDevPeriod;
   if(InpStdDevShift<0)
     {
      ExtStdDevShift=0;
      printf("Incorrect value for input variable InpStdDevShift=%d. Indicator will use value=%d for calculations.",InpStdDevShift,ExtStdDevShift);
     }
   else ExtStdDevShift=InpStdDevShift;
//--- set indicator short name
   IndicatorSetString(INDICATOR_SHORTNAME,"StdDev("+string(ExtStdDevPeriod)+")");
//---- define indicator buffers as indexes
   SetIndexBuffer(0,ExtStdDevBuffer);
   SetIndexBuffer(1,ExtMABuffer,INDICATOR_CALCULATIONS);
//--- set index label
   PlotIndexSetString(0,PLOT_LABEL,"StdDev("+string(ExtStdDevPeriod)+")");
//--- set index shift
   PlotIndexSetInteger(0,PLOT_SHIFT,ExtStdDevShift);
//----
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,const int prev_calculated,const int begin,const double &price[])
  {
//--- variables of indicator
   int               pos;
//--- set draw begin
   PlotIndexSetInteger(0,PLOT_DRAW_BEGIN,ExtStdDevPeriod-1+begin);
//--- check for rates count
   if(rates_total<ExtStdDevPeriod)
      return(0);
//--- starting work
   pos=prev_calculated-1;
//--- correct position for first iteration
   if(pos<ExtStdDevPeriod)
     {
      pos=ExtStdDevPeriod-1;
      ArrayInitialize(ExtStdDevBuffer,0.0);
      ArrayInitialize(ExtMABuffer,0.0);
     }
//--- main cycle
   switch(InpMAMethod)
     {
      case  MODE_EMA :
         for(int i=pos;i<rates_total && !IsStopped();i++)
           {
            if(i==InpStdDevPeriod-1)
               ExtMABuffer[i]=SimpleMA(i,InpStdDevPeriod,price);
            else
               ExtMABuffer[i]=ExponentialMA(i,InpStdDevPeriod,ExtMABuffer[i-1],price);
            //--- Calculate StdDev
            ExtStdDevBuffer[i]=StdDevFunc(price,ExtMABuffer,i);
           }
         break;
      case MODE_SMMA :
         for(int i=pos;i<rates_total && !IsStopped();i++)
           {
            if(i==InpStdDevPeriod-1)
               ExtMABuffer[i]=SimpleMA(i,InpStdDevPeriod,price);
            else
               ExtMABuffer[i]=SmoothedMA(i,InpStdDevPeriod,ExtMABuffer[i-1],price);
            //--- Calculate StdDev
            ExtStdDevBuffer[i]=StdDevFunc(price,ExtMABuffer,i);
           }
         break;
      case MODE_LWMA :
         for(int i=pos;i<rates_total && !IsStopped();i++)
           {
            ExtMABuffer[i]=LinearWeightedMA(i,InpStdDevPeriod,price);
            ExtStdDevBuffer[i]=StdDevFunc(price,ExtMABuffer,i);
           }
         break;
      default   :
         for(int i=pos;i<rates_total && !IsStopped();i++)
           {
            ExtMABuffer[i]=SimpleMA(i,InpStdDevPeriod,price);
            //--- Calculate StdDev
            ExtStdDevBuffer[i]=StdDevFunc(price,ExtMABuffer,i);
           }
     }
//---- OnCalculate done. Return new prev_calculated.
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| Calculate Standard Deviation                                     |
//+------------------------------------------------------------------+
double StdDevFunc(const double &price[],const double &MAprice[],int position)
  {
   double dTmp=0.0;
   for(int i=0;i<ExtStdDevPeriod;i++) dTmp+=MathPow(price[position-i]-MAprice[position],2);
   dTmp=MathSqrt(dTmp/ExtStdDevPeriod);
   return(dTmp);
  }
//+------------------------------------------------------------------+
