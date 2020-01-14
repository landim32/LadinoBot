//+------------------------------------------------------------------+
//|                                                          MFI.mq5 |
//|                   Copyright 2009-2017, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright   "2009-2017, MetaQuotes Software Corp."
#property link        "http://www.mql5.com"
#property description "Money Flow Index"
//---- indicator settings
#property indicator_separate_window
#property indicator_buffers    1
#property indicator_plots      1
#property indicator_type1      DRAW_LINE
#property indicator_color1     DodgerBlue
#property indicator_maximum    100.0
#property indicator_minimum    0.0
#property indicator_level1     20.0
#property indicator_level2     80.0
#property indicator_levelcolor Silver
#property indicator_levelstyle 2
#property indicator_levelwidth 1
//---- input parameters
input int                 InpMFIPeriod=14;            // Period
input ENUM_APPLIED_VOLUME InpVolumeType=VOLUME_TICK;  // Volumes
//---- buffers
double                    ExtMFIBuffer[];
//--- global variable
int                       ExtMFIPeriod;
//+------------------------------------------------------------------+
//| Money Flow Index initialization function                         |
//+------------------------------------------------------------------+
void OnInit()
  {
//--- check for input value
   if(InpMFIPeriod<=0)
     {
      ExtMFIPeriod=14;
      Print("Parameter InpMFIPeriod has wrong value. Indicator will use value ",ExtMFIPeriod);
     }
   else ExtMFIPeriod=InpMFIPeriod;
//---- indicator buffer   
   SetIndexBuffer(0,ExtMFIBuffer);
//---- name for DataWindow and indicator subwindow label
   IndicatorSetString(INDICATOR_SHORTNAME,"MFI"+"("+string(ExtMFIPeriod)+")");
//--- set draw begin
   PlotIndexSetInteger(0,PLOT_DRAW_BEGIN,ExtMFIPeriod);
//--- set indicator digits   
   IndicatorSetInteger(INDICATOR_DIGITS,_Digits);
//---- end of initialization function
  }
//+------------------------------------------------------------------+
//| Money Flow Index                                                 |
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
   int    CalcPosition;
//---- insufficient data
   if(rates_total<ExtMFIPeriod)
      return(0);
//--- start working
   if(prev_calculated<ExtMFIPeriod)
      CalcPosition=ExtMFIPeriod;
   else
      CalcPosition=prev_calculated-1;
//--- calculate MFI by volume
   if(InpVolumeType==VOLUME_TICK)
      CalculateMFI(CalcPosition,rates_total,high,low,close,tick_volume);
   else
      CalculateMFI(CalcPosition,rates_total,high,low,close,volume);
//--- OnCalculate done. Return new prev_calculated
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| Calculate MFI by volume from argument                            |
//+------------------------------------------------------------------+
void CalculateMFI(const int nPosition,
                  const int nRatesCount,
                  const double &HiBuffer[],
                  const double &LoBuffer[],
                  const double &ClBuffer[],
                  const long &VolBuffer[])
  {
   for(int i=nPosition;i<nRatesCount && !IsStopped();i++)
     {
      double dPositiveMF=0.0;
      double dNegativeMF=0.0;
      double dCurrentTP=TypicalPrice(HiBuffer[i],LoBuffer[i],ClBuffer[i]);
      for(int j=1;j<=ExtMFIPeriod;j++)
        {
         int    index=i-j;
         double dPreviousTP=TypicalPrice(HiBuffer[index],LoBuffer[index],ClBuffer[index]);
         if(dCurrentTP>dPreviousTP) dPositiveMF+=VolBuffer[index+1]*dCurrentTP;
         if(dCurrentTP<dPreviousTP) dNegativeMF+=VolBuffer[index+1]*dCurrentTP;
         dCurrentTP=dPreviousTP;
        }
      if(dNegativeMF!=0.0) ExtMFIBuffer[i]=100.0-100.0/(1+dPositiveMF/dNegativeMF);
      else                 ExtMFIBuffer[i]=100.0;
     }
  }
//+------------------------------------------------------------------+
//| Calculate typical price                                          |
//+------------------------------------------------------------------+
double TypicalPrice(const double dHi,const double dLo,const double dCl)
  {
   return (dHi+dLo+dCl)/3;
  }
//+------------------------------------------------------------------+
