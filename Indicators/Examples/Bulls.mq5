//+------------------------------------------------------------------+
//|                                                        Bulls.mq5 |
//|                   Copyright 2009-2017, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright   "2009-2017, MetaQuotes Software Corp."
#property link        "http://www.mql5.com"
#property description "Bulls Power"
//--- indicator settings
#property indicator_separate_window
#property indicator_buffers 2
#property indicator_plots   1
#property indicator_type1   DRAW_HISTOGRAM
#property indicator_color1  Silver
#property indicator_width1  2
//--- input parameters
input int InpBullsPeriod=13; // Period
//--- indicator buffers
double    ExtBullsBuffer[];
double    ExtTempBuffer[];
//--- MA handle
int       ExtEmaHandle;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,ExtBullsBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,ExtTempBuffer,INDICATOR_CALCULATIONS);
//--- set accuracy
   IndicatorSetInteger(INDICATOR_DIGITS,_Digits+1);
//--- sets first bar from what index will be drawn
   PlotIndexSetInteger(0,PLOT_DRAW_BEGIN,InpBullsPeriod-1);
//--- name for DataWindow and indicator subwindow label
   IndicatorSetString(INDICATOR_SHORTNAME,"Bulls("+(string)InpBullsPeriod+")");
//--- get handle for MA
   ExtEmaHandle=iMA(NULL,0,InpBullsPeriod,0,MODE_EMA,PRICE_CLOSE);
//--- initialization done
  }
//+------------------------------------------------------------------+
//| Average True Range                                               |
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
//--- check for bars count
   if(rates_total<InpBullsPeriod)
      return(0);// not enough bars for calculation   
//--- not all data may be calculated
   int calculated=BarsCalculated(ExtEmaHandle);
   if(calculated<rates_total)
     {
      Print("Not all data of ExtEmaHandle is calculated (",calculated,"bars ). Error",GetLastError());
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
//---- get ma buffers
   if(IsStopped()) return(0); //Checking for stop flag
   if(CopyBuffer(ExtEmaHandle,0,0,to_copy,ExtTempBuffer)<=0)
     {
      Print("getting ExtEmaHandle is failed! Error",GetLastError());
      return(0);
     }
//--- first calculation or number of bars was changed
   if(prev_calculated<InpBullsPeriod)
      limit=InpBullsPeriod;
   else limit=prev_calculated-1;
//--- the main loop of calculations
   for(i=limit;i<rates_total && !IsStopped();i++)
     {
      ExtBullsBuffer[i]=high[i]-ExtTempBuffer[i];
     }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
