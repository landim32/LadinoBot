//+------------------------------------------------------------------+
//|                                                          WPR.mq5 |
//|                   Copyright 2009-2017, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright   "2009-2017, MetaQuotes Software Corp."
#property link        "http://www.mql5.com"
#property description "Larry Williams' Percent Range"
//---- indicator settings
#property indicator_separate_window
#property indicator_level1     -20.0
#property indicator_level2     -80.0
#property indicator_levelstyle STYLE_DOT
#property indicator_levelcolor Silver
#property indicator_levelwidth 1
#property indicator_maximum    0.0
#property indicator_minimum    -100.0
#property indicator_buffers    1
#property indicator_plots      1
#property indicator_type1      DRAW_LINE
#property indicator_color1     DodgerBlue
//---- input parameters
input int InpWPRPeriod=14; // Period
//---- buffers
double    ExtWPRBuffer[];
//--- global variables
int       ExtPeriodWPR;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void OnInit()
  {
//--- check for input value
   if(InpWPRPeriod<3)
     {
      ExtPeriodWPR=14;
      Print("Incorrect InpWPRPeriod value. Indicator will use value=",ExtPeriodWPR);
     }
   else ExtPeriodWPR=InpWPRPeriod;
//---- name for DataWindow and indicator subwindow label
   IndicatorSetString(INDICATOR_SHORTNAME,"%R"+"("+string(ExtPeriodWPR)+")");
//---- indicator's buffer   
   SetIndexBuffer(0,ExtWPRBuffer);
   PlotIndexSetInteger(0,PLOT_DRAW_BEGIN,ExtPeriodWPR-1);
//--- digits   
   IndicatorSetInteger(INDICATOR_DIGITS,2);
//----
  }
//+------------------------------------------------------------------+
//| Williams’ Percent Range                                          |
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
//---- insufficient data
   if(rates_total<ExtPeriodWPR)
      return(0);
//--- start working
   int i=prev_calculated-1;
//--- correct position
   if(i<ExtPeriodWPR-1) i=ExtPeriodWPR-1;
//---  main cycle
   while(i<rates_total && !IsStopped())
     {
      //--- calculate maximum High
      double dMaxHigh=MaxAr(high,ExtPeriodWPR,i);
      //--- calculate minimum Low
      double dMinLow=MinAr(low,ExtPeriodWPR,i);
      //--- calculate WPR
      if(dMaxHigh!=dMinLow)
         ExtWPRBuffer[i]=-(dMaxHigh-close[i])*100/(dMaxHigh-dMinLow);
      else
         ExtWPRBuffer[i]=ExtWPRBuffer[i-1];
      //--- increment i for next iteration
      i++;
     }
   //--- return new prev_calculated value
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| Maximum High                                                     |
//+------------------------------------------------------------------+
double MaxAr(const double &array[],int period,int cur_position)
  {
   double Highest=array[cur_position];
   for(int i=cur_position-1;i>cur_position-period;i--)
     {
      if(Highest<array[i]) Highest=array[i];
     }
   return(Highest);
  }
//+------------------------------------------------------------------+
//| Minimum Low                                                      |
//+------------------------------------------------------------------+
double MinAr(const double &array[],int period,int cur_position)
  {
   double Lowest=array[cur_position];
   for(int i=cur_position-1;i>cur_position-period;i--)
     {
      if(Lowest>array[i]) Lowest=array[i];
     }
   return(Lowest);
  }
//+------------------------------------------------------------------+ 
