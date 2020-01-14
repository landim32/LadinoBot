//+------------------------------------------------------------------+
//|                                                          ADX.mq5 |
//|                   Copyright 2009-2017, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright   "2009-2017, MetaQuotes Software Corp."
#property link        "http://www.mql5.com"
#property description "Average Directional Movement Index"
#include <MovingAverages.mqh>

#property indicator_separate_window
#property indicator_buffers 6
#property indicator_plots   3
#property indicator_type1   DRAW_LINE
#property indicator_color1  LightSeaGreen
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
#property indicator_type2   DRAW_LINE
#property indicator_color2  YellowGreen
#property indicator_style2  STYLE_DOT
#property indicator_width2  1
#property indicator_type3   DRAW_LINE
#property indicator_color3  Wheat
#property indicator_style3  STYLE_DOT
#property indicator_width3  1
#property indicator_label1  "ADX"
#property indicator_label2  "+DI"
#property indicator_label3  "-DI"
//--- input parameters
input int InpPeriodADX=14; // Period
//---- buffers
double    ExtADXBuffer[];
double    ExtPDIBuffer[];
double    ExtNDIBuffer[];
double    ExtPDBuffer[];
double    ExtNDBuffer[];
double    ExtTmpBuffer[];
//--- global variables
int       ExtADXPeriod;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void OnInit()
  {
//--- check for input parameters
   if(InpPeriodADX>=100 || InpPeriodADX<=0)
     {
      ExtADXPeriod=14;
      printf("Incorrect value for input variable Period_ADX=%d. Indicator will use value=%d for calculations.",InpPeriodADX,ExtADXPeriod);
     }
   else ExtADXPeriod=InpPeriodADX;
//---- indicator buffers
   SetIndexBuffer(0,ExtADXBuffer);
   SetIndexBuffer(1,ExtPDIBuffer);
   SetIndexBuffer(2,ExtNDIBuffer);
   SetIndexBuffer(3,ExtPDBuffer,INDICATOR_CALCULATIONS);
   SetIndexBuffer(4,ExtNDBuffer,INDICATOR_CALCULATIONS);
   SetIndexBuffer(5,ExtTmpBuffer,INDICATOR_CALCULATIONS);
//--- indicator digits
   IndicatorSetInteger(INDICATOR_DIGITS,2);
//--- set draw begin
   PlotIndexSetInteger(0,PLOT_DRAW_BEGIN,ExtADXPeriod<<1);
   PlotIndexSetInteger(1,PLOT_DRAW_BEGIN,ExtADXPeriod);
   PlotIndexSetInteger(2,PLOT_DRAW_BEGIN,ExtADXPeriod);
//--- indicator short name
   string short_name="ADX("+string(ExtADXPeriod)+")";
   IndicatorSetString(INDICATOR_SHORTNAME,short_name);
//--- change 1-st index label
   PlotIndexSetString(0,PLOT_LABEL,short_name);
//---- end of initialization function
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
//--- checking for bars count
   if(rates_total<ExtADXPeriod)
      return(0);
//--- detect start position
   int start;
   if(prev_calculated>1) start=prev_calculated-1;
   else
     {
      start=1;
      ExtPDIBuffer[0]=0.0;
      ExtNDIBuffer[0]=0.0;
      ExtADXBuffer[0]=0.0;
     }
//--- main cycle
   for(int i=start;i<rates_total && !IsStopped();i++)
     {
      //--- get some data
      double Hi    =high[i];
      double prevHi=high[i-1];
      double Lo    =low[i];
      double prevLo=low[i-1];
      double prevCl=close[i-1];
      //--- fill main positive and main negative buffers
      double dTmpP=Hi-prevHi;
      double dTmpN=prevLo-Lo;
      if(dTmpP<0.0)   dTmpP=0.0;
      if(dTmpN<0.0)   dTmpN=0.0;
      if(dTmpP>dTmpN) dTmpN=0.0;
      else
        {
         if(dTmpP<dTmpN) dTmpP=0.0;
         else
           {
            dTmpP=0.0;
            dTmpN=0.0;
           }
        }
      //--- define TR
      double tr=MathMax(MathMax(MathAbs(Hi-Lo),MathAbs(Hi-prevCl)),MathAbs(Lo-prevCl));
      //---
      if(tr!=0.0)
        {
         ExtPDBuffer[i]=100.0*dTmpP/tr;
         ExtNDBuffer[i]=100.0*dTmpN/tr;
        }
      else
        {
         ExtPDBuffer[i]=0.0;
         ExtNDBuffer[i]=0.0;
        }
      //--- fill smoothed positive and negative buffers
      ExtPDIBuffer[i]=ExponentialMA(i,ExtADXPeriod,ExtPDIBuffer[i-1],ExtPDBuffer);
      ExtNDIBuffer[i]=ExponentialMA(i,ExtADXPeriod,ExtNDIBuffer[i-1],ExtNDBuffer);
      //--- fill ADXTmp buffer
      double dTmp=ExtPDIBuffer[i]+ExtNDIBuffer[i];
      if(dTmp!=0.0)
         dTmp=100.0*MathAbs((ExtPDIBuffer[i]-ExtNDIBuffer[i])/dTmp);
      else
         dTmp=0.0;
      ExtTmpBuffer[i]=dTmp;
      //--- fill smoothed ADX buffer
      ExtADXBuffer[i]=ExponentialMA(i,ExtADXPeriod,ExtADXBuffer[i-1],ExtTmpBuffer);
     }
//---- OnCalculate done. Return new prev_calculated.
   return(rates_total);
  }
//+------------------------------------------------------------------+
